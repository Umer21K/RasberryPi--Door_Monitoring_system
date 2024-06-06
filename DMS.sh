#!/bin/bash

#variables
COUNT=0
DISTANCE=0  #distance b/w sensor and stopper
DURATION=0  #duration of wave transmitted
TRIG=26     #pin number
ECHO=18     #pin number
START=0
END=0
DATE=$(date "+%d-%b-%y")
DAY=$(date "+%A")
TO="k213352@nu.edu.pk"      #user email
SUBJECT="Door Monitor System"       #subject of email

#setting sensor
gpio -g mode $TRIG out
gpio -g mode $ECHO in

sleep 1

#code
while true;
do
    gpio -g write $TRIG 0
    sleep 0.1
    gpio -g write $TRIG 1
    sleep 0.00001
    gpio -g write $TRIG 0

    while [ $(gpio -g read $ECHO) -eq 0 ];
    do
        START=$(date +%N)
    done

    while [ $(gpio -g read $ECHO) -eq 0 ];
    do
        END=$(date +%N)
    done

    DURATION=$(awk -v st="$START" -v et="$END" 'BEGIN { printf "%.9f", et - st }')  #calculating duration wave
    dur=$(awk -v d1="$DURATION" -v conv="1000000000" 'BEGIN { printf "%.9f", d1 / conv }')  #converting nanoseconds to seconds
    DISTANCE=$(awk -v d="$dur" -v sp="17150" 'BEGIN { printf "%.9f", d * sp }') #calculating distance
    DISTANCE=$(printf "%.0f" "$DISTANCE") #converting to integer

    if [[ $DISTANCE -gt 5 ]];   #checks distance criteria
    then
        if [[ $COUNT -eq 0 ]];      #check to send mail only once
        then
            echo 1 > door_status.txt    #sets door to open status, validates countdown
            ./countdown.sh &    #& operator runs ./countdown.sh command parallely in background to account for if the door is opened for too long
            TIME=$(date "+%T")
            echo -e "$DATE \t $DAY \t $TIME \t\t Opened\n" >> history.txt     #stores status of door in history
            echo "Door is opened." | mail -s "$SUBJECT" -A history.txt "$TO"    #this commands send email
            COUNT=1
        fi
    else
        if [[ $COUNT -eq 1 ]];      #check to send mail only once
        then
            echo 0 > door_status.txt    #informs countedown to stop counting since door is closed
            TIME=$(date "+%T")
            echo -e "$DATE \t $DAY \t $TIME \t\t Closed\n" >> history.txt     #stores status of door in history
            echo "Door is closed." | mail -s "$SUBJECT" -A history.txt "$TO"    #this commands send email
            COUNT=0
        fi
    fi

    sleep 1
done
