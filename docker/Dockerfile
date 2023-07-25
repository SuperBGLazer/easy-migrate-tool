FROM ubuntu:latest

RUN mkdir /SQL
WORKDIR /SQL
COPY . /SQL
RUN ls
RUN bash ./build-docker.sh


COPY my.cnf /etc/mysql/my.cnf

# COPY create_all_tables.sql /docker-entrypoint-initdb.d/
EXPOSE 3306

# Add the command to run easy-migrate after MySQL starts
CMD ["bash", "./start.sh"]
