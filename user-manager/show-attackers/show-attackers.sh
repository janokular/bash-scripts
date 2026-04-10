#!/bin/bash

# This script counts the number of failed loggin attemps by ip address
# If there are any ips with over the limit failures, display the count, ip, and location

limit='10'
log_file="${1}"

# Make sure the file was supplied as an argument
if [[ ! -e "${log_file}" ]]; then
  echo "Cannot open log file ${log_file}" >&2
  exit 1
fi

# Display the header
echo 'count,ip,location'

# Loop through the list of failed attemps and corresponding ip addresses
grep Failed "${log_file}" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -rn | while read count ip; do
  # If the number of failed attemps is greater than the limit, display count, ip, and location
  if [[ "${count}" -gt "${limit}" ]]
  then
    location=$(geoiplookup ${ip} | awk -F ', ' '{print $2}')
    echo "${count},${ip},${location}"
  fi
done

exit 0
