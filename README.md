# RasberryPi--Door_Monitoring_System
This is my project for Operating System

## Overview
This project demonstrates how to create a door monitoring system using a Raspberry Pi and an ultrasonic sensor. The system is coded in shell script and sends email notifications based on the status of the door. When the door opens, a warning email is sent to the user. If the door remains open for more than five seconds, a second warning email is sent. Once the door closes, an email notification is sent to inform the user that the door is closed.

## Features
- Door Monitoring: Detects if the door is open or closed using an ultrasonic sensor.
- Email Notifications: Sends email alerts when the door opens, remains open for more than five seconds, and closes.
- Shell Script: The monitoring and notification logic is implemented using a shell script.

## Components
- Raspberry Pi 4
- Ultrasonic sensor 
- Breadboard and Jumper wires
- Power supply for the Raspberry Pi
- Internet connection for sending emails
