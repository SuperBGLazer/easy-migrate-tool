# Easy Migrate Tool for MySQL

The Easy Migrate Tool for MySQL is a command-line utility that simplifies the process of migrating MySQL scripts to a server. It allows you to easily run and manage versioned SQL scripts in a specified directory and ensures that only modified scripts are executed.

## Features

- Runs MySQL scripts in a directory called `scripts`.
- Each script file must have a name like `v1.sql`, `v2.sql`, and so on. If the file is not named that, it won't work.
- Checks if any of the scripts have been modified before running them.
- Stores all script hashes in a file called `hashes.csv`.
- After each file is migrated to the server, the current version is kept in a file called `currentVersion.txt`.

## Installation (Build From Source)

Before running the tool, make sure you have the following prerequisites:

- MySQL server is installed and running.
- MySQL command-line client is installed and accessible from the terminal.

To install the Easy Migrate Tool, follow these steps:

1. Clone or download this repository to your local machine.

2. Navigate to the project directory.

3. Run the build.sh script using the following command:
```bash
bash ./build.sh
```
The script will generate a package named easy-migrate-\<version>-\<arch>.deb.

5. To install the Easy Migrate Tool, execute the following command, replacing \<version> with the appropriate value:
```bash
dpkg -i easy-migrate-<version>-all.deb
```

## Usage

To run the Easy Migrate Tool, use the following command:
```bash
easy-migrate -u <username> -p <password> -h <ip> -d
```


The tool supports the following flags:

- `-u` or `--username`: The MySQL username.
- `-p` or `--password`: The MySQL password.
- `-h` or `--ip`: The MySQL server IP address.
- `-d` or `--development-only`: Optional flag to enable development-only mode. When this flag is provided, any script containing the `-- development-only` comment in its first line will be executed during the migration process.


## Scripts Directory

Place your versioned SQL scripts in a directory called `scripts`. Each script file should follow the naming convention `v1.sql`, `v2.sql`, and so on. If a file does not have the correct name format, it will not be processed.

## Script Hashes

The Easy Migrate Tool stores the hashes of all scripts in a file called `hashes.csv`. When running the tool, it compares the hashes of the scripts in the `scripts` directory with the stored hashes in the file. If any changes are detected, the tool won't run the modified script to avoid potential database issues.

**Note:** Do not modify the `hashes.csv` file manually.

## Current Version

After each successful migration, the current version is stored in a file called `currentVersion.txt`.

## Development-only Mode
The development-only mode allows you to execute specific scripts during the migration process that are intended for development purposes. By using the `-d` flag, any script that includes the `-- development-only` comment in its first line will be executed. In addition, scripts without that flag will also be executed. This can be useful when you have scripts that contain development-specific changes or data and should only be executed in a development environment.

To utilize the development-only mode, follow these steps:

Ensure that the `-d` flag is included when running the easy-migrate command.
Add the `-- development-only` comment in the first line of any script that should be executed in development-only mode.
Example script (v3.sql) with the --development-only comment:

```sql
--development-only
-- This script contains development-specific changes
-- Execute this only in a development environment

ALTER TABLE my_table ADD COLUMN new_column INT;
```
Now you can use the -d flag to enable the development-only mode and execute specific scripts during the migration process in a development environment.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
