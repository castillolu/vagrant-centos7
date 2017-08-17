#!/bin/bash
set -e 

echo "Update SO"
sudo yum update -y

echo "Install WGET for download packages"
sudo yum install -y wget

echo "Install Apache"
sudo yum install -y httpd
sudo systemctl enable httpd

echo "Set SELInux to disabled"
setenforce 0

echo "Install PHP 7 and Libraries"
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum install -y mod_php71w php71w-cli php71w-common php71w-gd php71w-mbstring php71w-mcrypt php71w-xml php71w-pgsql

echo "Restart Apache after install PHP"
sudo systemctl restart httpd

echo "PHP Version"
php -v

echo "Install VirtualBox guest additions"
sudo yum groupinstall -y "Development Tools"
sudo yum install -y kernel-devel
sudo yum install -y epel-release
sudo yum install -y dkms

echo "Mount CD Linux Additions"
sudo mkdir /mnt/VBoxLinuxAdditions
sudo mount /dev/cdrom /mnt/VBoxLinuxAdditions
echo "Install Linux Additions"
sudo sh /mnt/VBoxLinuxAdditions/VBoxLinuxAdditions.run

echo "Install PostgreSQL and Setup"
sudo yum install -y postgresql-server postgresql-contrib

echo "Initialize your Postgres database and start PostgreSQL:"
sudo postgresql-setup initdb
sudo systemctl start postgresql
echo "Configure PostgreSQL to start on boot:"
sudo systemctl enable postgresql

echo "Install and set Firewall"
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=5432/tcp --permanent
sudo firewall-cmd --reload

echo "Set password for postgres User"
sudo cat /vagrant/user_postgres | chpasswd

echo "-------------------- fixing listen_addresses on postgresql.conf"
sudo sed -i "s/#listen_address.*/listen_addresses '*'/" /var/lib/pgsql/data/postgresql.conf

echo "-------------------- fixing postgres pg_hba.conf file"
# replace the ipv4 host line with the above line
sudo cat >> /var/lib/pgsql/data/pg_hba.conf <<EOF
# Accept all IPv4 connections - FOR DEVELOPMENT ONLY!!!
host    all         all         0.0.0.0/0             md5
EOF
echo "-------------------- creating postgres vagrant role with password vagrant"
# Create Role and login
sudo su postgres -c "psql -c \"CREATE ROLE vagrant SUPERUSER LOGIN PASSWORD 'vagrant'\" "
echo "-------------------- creating demo database"
# Create demo database
sudo su postgres -c "createdb -E UTF8 -T template0 --locale=en_US.utf8 -O vagrant demo"

echo "-------------------- installing composer"
sudo curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

exit 0
