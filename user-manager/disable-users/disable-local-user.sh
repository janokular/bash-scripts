#!/bin/bash

# This script disables, deletes, and/or archives users on the local system

archive_dir='/archive'

usage() {
  echo "Usage: ${0} [-dra] USER [USERN]"
  echo 'Disable a local Linux account.'
  echo '-d Deletes accounts instead of disabling them.'
  echo '-r Removes the home directory associated with the account(s).'
  echo '-a Creates an archive of the home directory associated with the account(s).'
  exit 1
}

# Check if script was run with sudo privileges
if [[ "${UID}" -ne 0 ]]; then
  echo "Please run with sudo or as a root." >&2
  exit 1
fi

# Check options provided by the user
while getopts dra option; do
  case ${option} in
    d) delete='true' ;;
    r) remove_home_dir='-r' ;;
    a) archive='true' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments
shift "$(( OPTIND - 1 ))"

# Check if user provided arguments to the script.
if [[ "${#}" -lt 1 ]]; then
  usage
fi

# Loop through all the usernames supplied as arguments
for account in "${@}"; do
  echo "Processing user: ${account}"
  # Check if user is not trying to disable a system account
  account_uid=$(id -u "${account}")
  if [[ "${account_uid}" -lt 1000 ]]; then
    echo "Refusing to remove the ${account} account with UID ${account_uid}." >&2
    exit 1
  else
    # Check if the account should be archived and if directory archive_dir exists
    if [[ "${archive}" = 'true' ]]; then
      if [[ ! -d "${archive_dir}" ]]; then
        echo "Creating ${archive_dir} directory." && mkdir -p ${archive_dir}
        if [[ "${?}" -ne 0 ]]; then
          echo "The archive directory ${archive_dir} could not be created." >&2
          exit 1
        fi
      fi

      # archive the user's home directory and move it into the archive_dir
      home_dir="/home/${account}"
      archive_file="${archive_dir}/${account}.tgz"
      if [[ -d "${home_dir}" ]]; then 
        echo "Archiving ${home_dir} to ${archive_file}"
        tar -zcf ${archive_file} ${home_dir} &> /dev/null
        if [[ "${?}" -ne 0 ]]; then
          echo "Could not create ${archive_file}." >&2
          exit 1
        fi
      else
        echo "${home_dir} does not exist or is not a directory." >&2
        exit 1
      fi
    fi

    # Check if user account should be deleted or disabled
    if [[ "${delete}" = 'true' ]]; then
      # Delete the user
      userdel ${remove_home_dir} ${account}

      # Check to see if the userdel command succeeded
      if [[ "${?}" -ne 0 ]]; then
        echo "The account ${account} was NOT deleted." >&2
        exit 1
      fi
      echo "The account ${account} was deleted."
    else
      # Disable user
      chage -E 0 ${account}
      
      # Check to see if the chage command succeeded
      if [[ "${?}" -ne 0 ]]; then
        echo "The account ${account} was NOT disabled." >&2
        exit 1
      fi
      echo "Disable the ${account} account."
    fi
  fi
done

exit 0
