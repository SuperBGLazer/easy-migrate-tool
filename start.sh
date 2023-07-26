#!/bin/bash

echo "Starting MySQL in the background..."

# Check if MySQL has been initialized by checking if more than 2 files exist in /var/lib/mysql
if [ "$(ls -A /var/lib/mysql)" ]; then
  echo "MySQL has already been initialized, skipping initialization..."
else
  echo "MySQL has not been initialized, initializing..."
  init_output=$(/usr/sbin/mysqld --initialize --console 2>&1)
  root_password=$(echo "$init_output" | grep -oP "temporary password is generated for root@localhost: \K(.+)")
  echo "Root password: $root_password"
fi

docker-entrypoint.sh
mysqld &

# Function to check if the MySQL port is open and accepting connections
function check_mysql_port {
  echo -n "Checking MySQL port..."
  if (echo > "/dev/tcp/127.0.0.1/3306") &>/dev/null; then
    echo "Success!"
    return 0
  else
    echo "Failed!"
    return 1
  fi
}

echo "Waiting for database connection..."
# Wait for the MySQL port to become available
until check_mysql_port
do
  # wait for 5 seconds before checking again
  sleep 5
done
echo "Database is up and running!"

# Check if the root_password variable exists and if it does, change the root password to the MYSQL_ROOT_PASSWORD environment variable
if [ ! -z "$root_password" ]; then
  echo "Changing root password..."
  mysqladmin -u root -p"$root_password" password "$MYSQL_ROOT_PASSWORD"
fi

echo "Executing easy-migrate..."
easy-migrate -u root -p root -d

# Loop forever
while true
do
  sleep 1
done
