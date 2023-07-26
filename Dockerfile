FROM ubuntu:latest

# Create the /SQL directory in the container
RUN mkdir /SQL

# Copy only the necessary files to the /SQL directory inside the container
COPY ./SQL /SQL/
COPY *.deb /SQL/
COPY *.sh /SQL/


# Set the working directory to /SQL
WORKDIR /SQL


# Run the build-docker.sh script
RUN bash build-docker.sh

RUN chmod +x start.sh

RUN cp ./start.sh /start.sh

# Expose port 3306
EXPOSE 3306

# Add the command to run easy-migrate after MySQL starts
CMD ["/start.sh"]
