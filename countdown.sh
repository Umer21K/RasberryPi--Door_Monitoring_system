for i in {10..1}
do
    read status < door_status.txt
    sleep 1
done

if [[ status -eq 1 ]];
then
    echo "Door is open for more than 10 seconds. Kindly check for any suspicious activity." | mail -s "ALERT! Door Monitor System" "k213352@nu.edu.pk" 
fi

