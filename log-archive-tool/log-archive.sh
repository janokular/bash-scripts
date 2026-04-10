#!/bin/bash

# This script archives logs by compressing them and storing them in a new directory

log_dir='/var/log'
archive_dir="${HOME}/archive"
date=$(date +%Y%m%d)
time=$(date +%H%M%S)
archive_file="logs_archive_${date}_${time}.tar.gz"

usage() {
  echo "Usage: ${0} [LOG_DIR]"
  echo "Archive logs from provided directory: default ${log_dir}"
  exit 1
}

# Check if script was run with sudo privileges
if [[ "${UID}" -ne 0 ]]; then
  echo 'Please run with sudo or as a root' >&2
  exit 1
fi

# Check if user provided log_dir
if [[ "${#}" -gt 1 ]]; then
  echo 'Please provide up to one parameter' >&2
  usage
elif [[ "${#}" -eq 1 ]]
then
  log_dir="${1}"
fi

# Check if log_dir exists and is a directory
if [[ ! -d "${log_dir}" ]]; then
  echo 'Provided parameter is not a directory or does not exist' >&2
  exit 1
fi

# Check if archive_dir exists
if [[ ! -d "${archive_dir}" ]]; then
  mkdir ${archive_dir}
fi

tar -zcf ${archive_dir}/${archive_file} ${log_dir} &> /dev/null

# Check the status of the tar command
if [[ "${?}" -ne 0 ]]; then
  echo "The ${log_dir} was NOT archived" >&2
  exit 1
else
  echo "The ${log_dir} was archived as a ${archive_file}"
  exit 0
fi
