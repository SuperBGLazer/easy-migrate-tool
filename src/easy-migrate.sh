#!/bin/bash

# Get the username, password, ip address, and development-only flags
while getopts u:p:h:d flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) password=${OPTARG};;
        h) ip=${OPTARG};;
        d) developmentOnly=true;;
    esac
done


# Check if any changes were made to the scripts directory and get the exit code
./easy-migrate-check.sh
exitCode=$?

# If any changes were made to existing file, exit the program
if [ $exitCode -eq 1 ]; then
    >&2 echo "Changes were made to existing files. Please delete the file hashes from hashes.csv and try again."
    exit 1
fi

# Create the currentVersion.txt file if it doesn't exist
if [ ! -f currentVersion.txt ]; then
    touch currentVersion.txt
fi

# List all the files in the scripts directory and sort them
files=$(ls scripts | sort)

# Get the current version from currentVersion.txt
currentVersion=$(cat currentVersion.txt)

# If the current version is empty, set it to 0
if [ -z "$currentVersion" ]; then
    currentVersion=0
fi

# Loop over each file
for file in $files
do
    # Get the version number from the file name
    version=$(echo $file | awk -F. '{print $1}' | awk -Fv '{print $2}')

    # If the version number is less than or equal to the current version, skip it
    if [ $version -le $currentVersion ]; then
        continue
    fi

    echo "Running $file, version $version"

    # Create the flags for the MySQL command if they exist
    if [ ! -z "$username" ]; then
        usernameFlag="-u$username"
    fi

    if [ ! -z "$password" ]; then
        passwordFlag="-p$password"
    fi

    if [ ! -z "$ip" ]; then
        ipFlag="-h $ip"
    fi
    
    # Check if the first line in the script contains development only and check if the development only flag was passed
    firstLine=$(head -n 1 scripts/$file)

    if [[ $firstLine == *"-- development-only"* ]] && [ -z $developmentOnly ]; then
        >&2 echo "Skipping $file, version $version"
        continue
    fi

    # Run the MySQL script
    mysql $ipFlag $usernameFlag $passwordFlag < scripts/$file

    # Check the exit code
    if [ $? -ne 0 ]; then
        >&2 echo "Error running $file, version $version"
        exit 1
    fi

    # Update the current version
    echo $version > currentVersion.txt
done

exit 0
