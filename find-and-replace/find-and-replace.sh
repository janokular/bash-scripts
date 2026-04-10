#!/bin/bash

# Script used to find and replace string occurences inside files in directory recursively

usage() {
  echo "Usage: ${0} FIND REPLACE DIR"
  exit 1
}

# If user doesn't supply three arguments, then give them help
number_of_params="${#}"
if [[ "${number_of_params}" -ne 3 ]]; then
  usage
fi

find="${1}"
replace="${2}"
dir="${3}"

# Check if $dir exists
if [[ ! -d "${dir}" ]]; then
  echo "${dir} does not exist" >&2
  exit 1
fi

# Recursivly search for files containing find string
grep -rl "${find}" "${dir}" | while read -r FILE; do
  sed -i -e "s/${find}/${replace}/g" "${FILE}"

  # Check if string was successfully replaced
  if [[ "${?}" -ne 0 ]]; then
    echo "Could not replace string '${find}' with '${replace}' in ${FILE}" >&2
  else
    echo "Successfully replaced string '${find}' with '${replace}' in ${FILE}"
  fi
done
