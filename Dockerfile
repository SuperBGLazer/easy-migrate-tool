FROM mysql

# Create the /SQL directory in the container
RUN mkdir /SQL

# Copy only the necessary files to the /SQL directory inside the container
COPY ./SQL /SQL/
COPY *.sh /SQL/
COPY package/usr/bin /usr/bin/


# Set the working directory to /SQL
WORKDIR /SQL

RUN chmod +x start.sh

RUN cp ./start.sh /start.sh

# Expose port 3306
EXPOSE 3306

RUN chown -R mysql:mysql /var/lib/mysql
RUN chmod -R 755 /var/lib/mysql

# Add the command to run easy-migrate after MySQL starts
CMD ["/start.sh"]
