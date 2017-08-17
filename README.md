# Vagrantfile and Scripts to VM Centos 7
Configuration to VM Centos 7 for project with Laravel and PostgreSQL

Testing by and Configuration MAC OS

### Prerequisites
Install Tools 

## - Download and install last Version VirtualBox - Aug 2017 (Version 5.1.26)
https://www.virtualbox.org/wiki/Downloads

## - Download and Install Vagrant - Aug 2017 (Vagrant 1.9.7)
https://www.vagrantup.com/downloads.html

## - Download ISO for VBoxGuestAdditions
http://download.virtualbox.org/virtualbox/5.1.22/VBoxGuestAdditions_5.1.22.iso

## - Define folder for VM
```
mkdir /Users/my_user_folder/Projects/my_project
```

## - Change to new directory
```
$ cd /Users/my_user_folder/Projects/my_project
```

## - Clone this repo and config path for ISO downloaded in step 3 in Vagrantfile 
second_disk = 'VBoxGuestAdditions_5.1.22.iso' 

## - Run the command below:
```
$ vagrant up
```

Now you have to wait for installation ended!

## - Right now! you can set up your working directory in this line
```
config.vm.synced_folder "/Library/WebServer/Documents/techsupport", "/var/www/html", :owner => "apache", :group => "apache", :mount_options => ["dmode=775", "fmode=664"]
```