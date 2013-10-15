#!/bin/bash

if [ `whoami` != 'root' ]; then
    echo "You have to execute this script as root user"
    exit 1;
fi

read -p "Enter the server name your want (without www) :" ServerName
read -p "Enter document root (e.g.: /var/www/website, dont forget the /):" DocumentRoot
read -p "Enter the user you want to use ('apache' is default) :" UserName

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp templateHost /etc/apache2/sites-available/$ServerName

if ! echo -e /etc/pache2/sites-available/$ServerName; then
    echo "Virtual host wasn't created !"
    exit 1;
else
    echo "Configuration file added !"
fi

sed -i "s/\$ServerName/$ServerName/g" /etc/apache2/sites-available/$ServerName
sed -i -e "s/\$DocumentRoot/$(echo $DocumentRoot | sed -e 's/\(\/\|\\\|&\)/\\&/g')/g" /etc/apache2/sites-available/$ServerName

if [ -d $DocumentRoot ]; then
    echo "document root exists"
else
    echo "document root doesn't exist. Creating new one"
    mkdir $DocumentRoot
    chown $UserName $DocumentRoot
    chmod 755 $DocumentRoot
    cp phpinfo.php $DocumentRoot"/index.php"
fi

sudo a2ensite $ServerName

echo "127.0.1.1 $ServerName" >> /etc/hosts

/etc/init.d/apache2 reload
/etc/init.d/apache2 restart

echo "New host "$ServerName" created successfuly. Press any key to exit"
read DocumentRoot
