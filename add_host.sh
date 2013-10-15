#!/bin/bash

read -p "Enter the server name your want (without www) :" ServerName
read -p "Enter document root (e.g.: /var/www/website, dont forget the /):" DocumentRoot
if $ServerName == ''; then
    echo "ServerName must be not empty !"
    exit 1;
fi
if $DocumentRoot == ''; then
    echo "DocumentRoot must be not empty !"
    exit 1;
fi

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo cp templateHost /etc/apache2/sites-available/$ServerName

if ! echo -e /etc/pache2/sites-available/$ServerName; then
    echo "Virtual host wasn't created !"
    exit 1;
else
    echo "Configuration file added !"
fi

sudo sed -i "s/\$ServerName/$ServerName/g" /etc/apache2/sites-available/$ServerName
sudo sed -i -e "s/\$DocumentRoot/$(echo $DocumentRoot | sed -e 's/\(\/\|\\\|&\)/\\&/g')/g" /etc/apache2/sites-available/$ServerName

if [ -d $DocumentRoot ]; then
    echo "document root exists"
else
    echo "document root doesn't exist. Creating new one"
    sudo mkdir $DocumentRoot
    sudo chown `whoami` $DocumentRoot
    chmod 755 $DocumentRoot
    cp phpinfo.php $DocumentRoot"/index.php"
fi

sudo a2ensite $ServerName

sudo -- sh -c "echo 127.0.1.1 $ServerName >> /etc/hosts"

sudo /etc/init.d/apache2 reload
sudo /etc/init.d/apache2 restart

echo "New host "$ServerName" created successfuly. Press any key to exit"
read DocumentRoot
