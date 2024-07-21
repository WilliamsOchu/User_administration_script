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
    echo "$element"
    mygroups+=("$element")  

done
#echo ${mygroups[@]}

## Checking if the group already exists
for check in ${mygroups[@]::${#mygroups[@]}-1}; do                            
    if [ $(getent group $check) ]; then
    echo "group exists."
else
    sudo groupadd $check
    echo "group does not exist."
fi
done


## Let us proceed to chceck if the user exists and create user if it does not exist 
if [ $(getent passwd $extract_users) ]; then
  echo "user exists."
else
  echo "user does not exist."
fi




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