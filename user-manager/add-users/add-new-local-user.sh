#!/bin/bash

# This script creates a new user on the local system
# You must supply a username as an argument to the script
# Optionally, you can also provide a comment for the account as an argument
# A password will be automatically generated for the account
# The username, password, and host for the account will be displayed

# Make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]; then
  echo 'Please run with sudo or as root.'
  exit 1
fi

# If user doesn't supply at least one argument, then give them help
number_of_params="${#}"
if [[ "${number_of_params}" -lt 1 ]]; then
  echo "Usage: ${0} USERNAME [COMMENT]..."
  exit 1
fi

# The first parameter is the user name
username="${1}"

# The rest of the parameters are for the account comments
shift 1
comment="${@}"

# Generate password
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# Create the user with the password
useradd -c "${comment}" -m ${username}

# Check to see if the useradd command succeeded
if [[ "${?}" -ne 0 ]]; then
  echo 'Command useradd did NOT succeeded!'
  exit 1
fi

# Set the password
echo "${username}:${password}" | chpasswd

# Check if the passwd command succeeded
if [[ "${?}" -ne 0 ]]; then
  echo 'Command chpasswd did NOT succeeded!'
  exit 1
fi

# Force password change on first login
passwd -e ${username}

# Display the username, password, and the host where te user was created
echo -e "\nusername:\n${username}"
echo -e "\npassword:\n${PASSWORD}"
echo -e "\nhost:\n${HOSTNAME}"
exit 0
