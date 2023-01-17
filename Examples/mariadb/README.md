
## Download MariaDB 10.8.6 on ubuntu 20.04

1. curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version="mariadb-10.8.6" --os-type=ubuntu --os-version=bionic

2. sudo apt install mariadb-server

## Run mysql_secure_installation

1. sudo mysql_secure_installation

	a. Enter current password for root (enter for none): --> press enter

	b. Switch to unix_socket authentication [Y/n] --> n

	c. Change the root password? --> y

	d. Remove anonymous users? [Y/n] --> y

	e. Disallow root login remotely? --> y

	f. Remove test database and access to it? --> y

	g. Reload privilege tables now? --> y

## Connect to the sevrver and allow root to connect to any IP

1. sudo mysql

2. CREATE USER 'root'@'%' IDENTIFIED BY '$root-password'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;\
(Use the root password changed by mysql_secure_installation)

## Stop MariaDB server

1. systemctl stop mysqld

2. mariadb is installed by mysql user so change owner of below folders to current user

	a. sudo chown -R $USER /var/lib/mysql

	b. sudo chown -R $USER /run/mysqld

## Build MariaDB base image

1. cd gsc/Examples/mariadb

2. chmod +x helper.sh

3. ./helper.sh

## Build GSC image:

1. cd gsc/  

2. cp config.yaml.template config.yaml

3. Update Distro to "ubuntu:20.04" in config.yaml

4. openssl genrsa -3 -out enclave-key.pem 3072

5. ./gsc build mariadb-base Examples/mariadb/mariadb.manifest

6. ./gsc sign-image mariadb-base enclave-key.pem

## Start MariaDB server
docker run --device=/dev/sgx_enclave -v /var/lib/mysql:/var/lib/mysql -it gsc-mariadb-base 

## Connect client to the server

1. docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id

2. mysql -h IP-Address -P 3306 --protocol=TCP -u root -p\
e.g.  mysql -h 172.17.0.2 -P 3306 --protocol=TCP -u root -p

## Remove MariaDB server

sudo apt-get purge mariadb-server* mariadb-server-10.8 mariadb-server-core-10.8 mariadb-common mariadb-client-core-10.8 mariadb-client-10.8
