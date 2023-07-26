#!/bin/bash

description="Easy Migrate allows you to easily run and orginize your .sql scripts"
version="1.0.0"
maintainer="Breyon Gunn"

# Get the architecture of the system
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
echo "Architecture: all" >> package/DEBIAN/control
echo "Maintainer: $maintainer" >> package/DEBIAN/control
echo "Description: $description" >> package/DEBIAN/control

chmod +x packages/DEBIAN/control

# Build the package
dpkg-deb --build package


# Rename the package with the version number and architecture
mv package.deb ./easy-migrate_${version}_all.deb

# Build the docker image superlazer/easy-migrate-mysql with the current version
docker build -t superlazer/easy-migrate-mysql:${version} .

# Check if the push docker flag is set
if [ "$1" == "--push" ]; then
  echo "Pushing docker image to docker hub..."

  # Push the docker image to docker hub
  docker push superlazer/easy-migrate-mysql:${version}

  # Push the docker image to docker hub with the latest tag
  docker tag superlazer/easy-migrate-mysql:${version} superlazer/easy-migrate-mysql:latest
  docker push superlazer/easy-migrate-mysql:latest

else
  echo "Skipping docker push..."
fi

# Remove the docker image
docker rmi superlazer/easy-migrate-mysql:${version}

rm src/*.fix
rm -rf package

exit 0
