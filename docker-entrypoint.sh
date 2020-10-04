#!/bin/bash
# Enter the www location
cd /var/www
apt install -y sudo
apt install -y nano
apt install -y git

#Install Node.js and NPM
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
apt install -y nodejs

#Check composer version
composer --version

#Install and configure Monica
mkdir -p /var/www/monica
cd /var/www/monica
git clone https://github.com/monicahq/monica.git .
git checkout tags/v2.1.1
git checkout tags/v2.1.1

#install all packages
composer install --no-interaction --no-suggest --no-dev --ignore-platform-reqs

#Install all the front-end dependencies and tools needed to compile assets.
npm install yarn
npm install

#Compile the JS and CSS assets.
npm run production

#Generate an application key. This will set APP_KEY to the correct value automatically.
php artisan key:generate

#Run the migrations and seed the database and symlink folders.
php artisan setup:production && yes

#Change ownership of the /var/www/monica directory to www-data.
chown -R www-data:www-data /var/www
