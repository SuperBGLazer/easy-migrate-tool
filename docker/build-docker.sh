#!/bin/bash

mkdir -p /SQL/scripts
apt-get update
apt-get install -y wget mysql-server netcat

# Set root password for MySQL
MYSQL_ROOT_PASSWORD="root"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

# Install easy-migrate-tool
dpkg -i easy-migrate*.deb

dpkg -i easy-migrate_0.0.1_all.deb
rm *.deb

# Configure MySQL to allow root login from any IP
echo "UPDATE mysql.user SET Host='%' WHERE User='root';" | mysql -u root -p$MYSQL_ROOT_PASSWORD
echo "FLUSH PRIVILEGES;" | mysql -u root -p$MYSQL_ROOT_PASSWORD

# Restart MySQL service
service mysql restart
