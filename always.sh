#!/bin/bash
set -e 

echo "Update SO"
sudo yum update -y

echo "Set SELInux to disabled"
setenforce 0

echo "Install PHP Libraries"
#Add libraries or extension for php
#sudo yum install -y php71w-pgsql

echo "Restart Apache after install PHP Libraries"
sudo systemctl restart httpd

exit 0
