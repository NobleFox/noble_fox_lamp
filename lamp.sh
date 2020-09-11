#!/bin/bash
#######################################
# Bash script to install an LAMP stack in ubuntu
# Author: Subhash (serverkaka.com)

# Check if running as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Ask value for mysql root password
read -p 'db_root_password [secretpasswd]: ' db_root_password
echo

# Update system
add-apt-repository ppa:ondrej/php
apt-get install software-properties-common
sudo apt-get update -y

## Install Apache
sudo apt-get install apache2 apache2-doc apache2-mpm-prefork apache2-utils libexpat1 ssl-cert -y

## Install PHP
apt-get install php5.6 libapache2-mod-php php5.6-mysql php5.6-xml php5.6-mbstring -y

# Install MySQL database server
apt install mariadb-server
service mysql start
mysqld_safe --skip-grant-tables
sudo mysql -u root -e \
  "GRANT ALL PRIVILEGES on *.* to 'root'@'localhost' IDENTIFIED BY 'toor'; FLUSH PRIVILEGES;"


# Enabling Mod Rewrite
sudo a2enmod rewrite
sudo php5enmod mcrypt

## Install PhpMyAdmin
sudo apt-get install phpmyadmin -y

## Configure PhpMyAdmin
echo 'Include /etc/phpmyadmin/apache.conf' >>/etc/apache2/apache2.conf

# Set Permissions
sudo chown -R www-data:www-data /var/www

# Restart Apache
sudo service apache2 restart
