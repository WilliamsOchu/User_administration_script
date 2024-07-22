#!/bin/bash

# Author: Williams Ochu
# Date Created 19-07-2024
# Date Modified: 20-07-2024

# Description: This script will create users and assign them to their appropriate groups

# Usage: Run this script while passing the txt file containing the users and groups to be created as a command line argument. Kindly note each line of the txt file must end with a comma

## Check for root privileges
if [ ! $(id -u) = 0 ]; then
  echo "Script must be run as root"
  exit 1
fi

## Lets create a file where the script logs will be sent to 
LOGFILE="/var/log/user_management.log"

if test -f "$LOGFILE"; then
    echo file exists > /dev/null
else
    sudo touch "$LOGFILE"
fi

# Redirect stdout (file descriptor 1) to the log file
exec > >(tee -a $LOGFILE > /dev/null) 

# Redirect stderr (file descriptor 2) to the log file
exec 2> >(tee -a $LOGFILE >&2 > /dev/null)

# Log each command being executed (useful for debugging)
set -x


## Lets create the directory where passwords will be stored
passdir="/var/secure"
if [ -d "$passdir" ]; then
    echo password dir exists > /dev/null
else
    sudo mkdir /var/secure
fi


## Lets initiate a loop to kickstart the creation process
while read -r line; do

## Lets create an array to hold the usernaes
myusers=()

## Lets create another array to hold the group names 
mygroups=()

## Lets read the contents of the file
file_contents=$(echo "$line")
#echo $file_contents

## Lets ectract the usernames of the file contents being read
extract_users=$(echo "$line" | cut -d ";" -f 1 )
#echo $extract_users

## Lets extract the groupnames of the file contents being read
extract_grps=$(echo "$line" | cut -d ";" -f 2 )
#echo $extract_grps

## Lets extract the individual group names and create a group if the group does not exists
IFS=',' read -ra array <<< "$extract_grps"

for element in "${array[@]}"; do
    #echo "$element"
    mygroups+=("$element")  
done
#echo ${mygroups[@]}

## Checking if the group already exists
for check in ${mygroups[@]::${#mygroups[@]}-1}; do                            
    if [ $(getent group $check) ]; then
    echo "group exists." > /dev/null
else
    sudo groupadd $check
    #echo "group added."
fi
done

## Lets convert our array back into string
grptostr=${mygroups[@]::${#mygroups[@]}-1}
#echo $grptostr
grpstr=${grptostr// /,}

## Lets initiate variables for user random password
tmp_pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
userwithpass="$extract_users,$tmp_pass"
#echo $tmp_pass
echo $userwithpass >> /var/secure/user_passwords.csv


## Let us proceed to chceck if the user exists and create user if it does not exist 
if [ $(getent passwd $extract_users) ]; then
    echo "user exists." > /dev/null
else
    sudo useradd -m -s /usr/bin/bash -p $tmp_pass -G $grpstr $extract_users                                                 
    echo "$extract_users : user created." >> /var/secure/created_users.txt
fi

done < $1

## Permit access to the passwords file to only the owner
sudo chmod 700 /var/secure/user_passwords.csv
echo "Done"