#!/bin/bash

echo "Starting MySQL in the background..."
mysqld &

echo "Waiting for database connection..."
until mysql -e "SELECT 1;" &>/dev/null
do
  # wait for 5 seconds before checking again
  sleep 5
done
echo "Database is up and running!"

ls

echo "Executing easy-migrate..."
easy-migrate -u root -p root -d

# Loop forever
while true
do
  sleep 1
done
