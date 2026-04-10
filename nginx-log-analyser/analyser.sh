#!/bin/bash

# This scrpit analysis nginx logs

log_file='./nginx-access.log'

# Clear terminal window
clear

# Check if log_file exists and is a file
if [[ ! -e "${log_file}" ]]
then
  echo "Cannot open ${log_file}" >&2
  exit 1
fi

# Top 5 IP addresses with the most requests
echo "Top 5 IP addresses with the most requests:"
cut -d " " -f 1 "${log_file}" | sort | uniq -c | sort -rn | head -5 | awk '{ print $2, "-", $1, "requests" }'
echo

# Top 5 most requested paths
echo "Top 5 most requested paths:"
cut -d " " -f 7 "${log_file}" | sort | uniq -c | sort -rn | head -5 | awk '{ print $2, "-", $1, "requests" }'
echo

# Top 5 response status codes
echo "Top 5 response status codes:"
cut -d '"' -f 3 "${log_file}" | cut -d " " -f 2 | sort | uniq -c | sort -rn | head -5 | awk '{ print $2, "-", $1, "requests" }'
echo

# Top 5 user agents
echo "Top 5 user agents:"
cut -d '"' -f 6 "${log_file}" | sort | uniq -c | sort -rn | head -5 | awk '{ first = $1; $1=""; print $0, "-", first, "requests" }' | cut -c 2-
echo