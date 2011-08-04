#!/bin/bash
echo "Enter virtual host name:"
read ServerName
echo "Enter document root:"
read DocumentRoot
cd ~/soft/add_virtual_host
sudo cp templateHost /etc/apache2/sites-available/$ServerName
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
sudo sed 's/aaa/'"aaa\n127.0.0.1 $ServerName"'/' /etc/hosts > a
sudo mv a /etc/hosts
sudo /etc/init.d/apache2 reload
sudo /etc/init.d/apache2 restart
echo "Press any key to exit"
read DocumentRoot