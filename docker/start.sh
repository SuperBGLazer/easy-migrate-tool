#!/bin/bash

echo "Starting MySQL in the background..."
mysqld --user=root &

echo "Waiting for database connection..."
until nc -z -v -w30 "127.0.0.1" "3306"
do
  # wait for 5 seconds before checking again
  sleep 5
done
echo "Database is up and running!"

echo "Executing easy-migrate..."
easy-migrate -u root -p root -d

# Loop forever
while true
do
  sleep 1
done