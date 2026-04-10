#!/bin/bash

# localhost TCP port scanner
# 0-1024        well-known ports
# 1024-49151    registered ports
# 49151-65535   dynamic/private ports

host=localhost

if [[ $# -ne 2 ]]; then
  echo 'Provide two arguments'
  exit 1
fi

start_port=$1
end_port=$2

function validate_port() {
  local port=$1
  if [[ $port =~ ^[0-9]+$ ]]; then
    if [[ $port -le 0 ]] || [[ $port -ge 65535 ]]; then
      echo "$port is not in range 0-65535"
      exit 1
    fi
  else
    echo "$port is not a number"
    exit 1
  fi
}

validate_port $start_port
validate_port $end_port

if [[ $start_port -gt $end_port ]]; then
  echo 'Starting port cannot be greater than ending port'
  exit 1
fi

echo 'Scanning ports...'
for (( port=$start_port; port<=$end_port; port++ )); do
  timeout 1 bash -c "< /dev/tcp/$host/$port" 2&> /dev/null
  if [[ $? -eq 0 ]]; then
    echo "$host has open port $port"
  fi
done
