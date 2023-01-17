# SPDX-License-Identifier: LGPL-3.0-or-later
# Copyright (C) 2023 Intel Corporation

FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y apt-transport-https curl
RUN curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
RUN echo 'deb https://mariadb.mirror.serveriai.lt/repo/10.8/ubuntu focal main' >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y mariadb-server

RUN mkdir /run/mysqld

RUN mkdir -p /mariadb-defaults-extra-file
COPY my.cnf /mariadb-defaults-extra-file

CMD ["/usr/sbin/mysqld", "--defaults-extra-file=/mariadb-defaults-extra-file/my.cnf", "--user=root"]
