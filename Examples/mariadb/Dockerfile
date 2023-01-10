FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y apt-transport-https curl
RUN curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
RUN echo 'deb https://mariadb.mirror.serveriai.lt/repo/10.8/ubuntu bionic main' >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y mariadb-server
RUN mkdir /run/mysqld
RUN mkdir -p /mariadb-defaults-extra-file
COPY my.cnf /mariadb-defaults-extra-file
RUN rm -rf /var/lib/mysql/*
COPY var/lib/mysql /var/lib/mysql
RUN cd /var/lib/mysql && rm -rf aria_log.00000001 aria_log_control ib_buffer_pool  ibdata1 ib_logfile0 ddl_recovery.log
CMD ["/usr/sbin/mysqld", "--defaults-extra-file=/mariadb-defaults-extra-file/my.cnf", "--user=root"]
