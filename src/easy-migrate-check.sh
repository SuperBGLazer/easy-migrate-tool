#!/bin/bash

# Create the hashes.csv file if it doesn't exist
if [ ! -f hashes.csv ]; then
    touch hashes.csv
fi

# List all the files in the scripts directory
files=$(ls scripts)

# Count the files
count=$(ls scripts | wc -l)
echo "There are $count files in the scripts directory"

# Check if any files were deleted
deletedFiles=0
for line in $(cat hashes.csv)
do
    # Get the file name
    file=$(echo $line | awk -F, '{print $1}')

    # Check if the file exists
    if [ ! -f scripts/$file ]; then
        >&2 echo "The $file file has been deleted"
        deletedFiles=$((deletedFiles+1))
    fi
done

if [ $deletedFiles -gt 0 ]; then
    >&2 echo "$deletedFiles files have been deleted"
    exit 1
fi


# Loop through each file, create a sha512 hash, and compare it to the hash in hashes.csv
filesChanged=0
for file in $files
do

    # Make sure the file name matches the pattern v(number).sql
    if [[ ! $file =~ ^v[0-9]+\.sql$ ]]; then
        >&2 echo "The $file file does not match the pattern v(number).sql"
        exit 1
    fi

    # Create the hash
    hash=$(sha512sum scripts/$file | awk '{print $1}')

    # Get the hash from hashes.csv
    oldHash=$(grep $file hashes.csv | awk -F, '{print $2}')

    # Check if the file is in hashes.csv
    if [ -z "$oldHash" ]; then
        # The file is not in hashes.csv, so add it
        echo "$file,$hash" >> hashes.csv
        echo "The $file file has been added to hashes.csv"
        continue
    fi

    # Compare the hashes
    if [ "$hash" != "$oldHash" ]; then
        # The hashes are different, so update the hashes.csv file
        >&2 echo "The $file file has changed"
        filesChanged=$((filesChanged+1))
    fi
done

# Check if any files have been changed
if [ $filesChanged -gt 0 ]; then
    >&2 echo "$filesChanged files have changed"
    exit 1
else
    echo "No files have changed"
    exit 0
fi