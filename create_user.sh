#!/bin/bash

# Author: Williams Ochu
# Date Created 19-07-2024
# Date Modified: 20-07-2024

# Description: This script will create users and assign them to their appropriate groups

# Usage: Run this script while passing the txt file containing the users and groups to be created as a command line argument

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
    echo "group exists." 
else
    sudo groupadd $check
    echo "group added."
fi
done

## Lets convert our array back into string
grptostr=${mygroups[@]::${#mygroups[@]}-1}
#echo $grptostr
grpstr=${grptostr// /,}


## Lets initiate variables for user random password
tmp_pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
userwithpass="$extract_users: $tmp_pass"
#echo $tmp_pass
echo $userwithpass >> passwords.txt #/var/secure/user_passwords.txt


## Let us proceed to chceck if the user exists and create user if it does not exist 
if [ $(getent passwd $extract_users) ]; then
  echo "user exists."
else
    sudo useradd -m -s /usr/bin/bash -p $tmp_pass -G $grpstr $extract_users                                                 
    echo "$extract_users : user created." >> created_users.txt

fi

## Let us proceed to log all actions of the user
#local6.* /var/log/commands.log
#sudo systemctl restart rsyslog




<<comment

## Lets proceed to create a user for each user 
for ind_user in $myusers;do
if [ $(getent passwd "$ind_user") ]; then
  echo "user exists."
else
  echo "group does not exist."
fi
comment

done < $1

echo Users Succesfully Created  !!! 