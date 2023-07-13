#!/bin/bash

description="Easy Migrate allows you to easily run and orginize your .sql scripts"
version="0.0.1"
maintainer="Breyon Gunn"

# Get the architecture of the system
architecture=$(dpkg --print-architecture)
echo "Architecture: $architecture"


mkdir -p package/DEBIAN
mkdir -p package/usr/bin

# Fix commands in easy-migrate.sh by replacing replacing ./easy-migrate-check.sh with easy-migrate-check
cp src/easy-migrate.sh src/easy-migrate.sh.fix
sed -i 's/\.\/easy-migrate-check\.sh/easy-migrate-check/g' src/easy-migrate.sh.fix


# Copy the scripts
cp src/easy-migrate.sh.fix package/usr/bin/easy-migrate
cp src/easy-migrate-check.sh package/usr/bin/easy-migrate-check

# Create the control file
echo "Package: easy-migrate" > package/DEBIAN/control
echo "Version: $version" >> package/DEBIAN/control
echo "Architecture: $architecture" >> package/DEBIAN/control
echo "Maintainer: $maintainer" >> package/DEBIAN/control
echo "Description: $description" >> package/DEBIAN/control

chmod +x packages/DEBIAN/control

# Build the package
dpkg-deb --build package


rm src/*.fix
rm -rf package

# Rename the package with the version number and architecture
mv package.deb easy-migrate-$version-$architecture.deb

exit 0