# User Creation Script

## Seamlessly create user accounts on linux and assign them to groups

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

User_creation script is a utility that creates a user account on linux


## Tools Used

- Bash scripting


## Features

What this script implements:

- Create user account with appropriate home directory as the username and sets up a random login password

- Create groups

- Assign users to groups

- Set user default shell to bash

- Helps log all actions being run by the created user accounts to a central log file

<br />

## How to use
- This script follows strict adherence to the format of the employee details file being passed as command line argument
- Ensure the file being passed is nicely formatted as seen in the employee_details.txt file included in this repo 
- Run the script and pass the file containing employee details as command line argument
- Script is initialized and all functionalities are seamlessly achieved

<br />

## ToDo
- Challenge faced in this project is majorly due to extracting text from the file being passed which contains the employees usernames and groups they ought to be assigned to
- For now strict adherence formatting and styling of the file should be followed 
- Improvements to this script should be targetted towards making it work seamlessly with files of less strict formatting. (for example, including a space after the semicolon separating the user and groups will break the script)
- Passwords are stored in plain text. This should be remedied

