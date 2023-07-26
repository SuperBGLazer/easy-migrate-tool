#!/bin/bash

mkdir -p /SQL/scripts
apt-get update
apt-get install -y wget mysql-server netcat

# Set root password for MySQL
MYSQL_ROOT_PASSWORD="root"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

# Install easy-migrate-tool
dpkg -i *.deb

# Restart MySQL service
service mysql restart
