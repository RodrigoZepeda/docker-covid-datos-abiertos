#!/bin/sh
#Create the crontab executable and start crontab
#Also, download file from first time
echo "Comenzando"
/get_file.sh -p
crond -f