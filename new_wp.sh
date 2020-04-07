#!/bin/bash
# Shell script for a plain wordpress installation with database
# useage ./new_wp.sh folder_name database_name

if [ ! -n "$1" ]
  then
    echo "No path name"
    exit 1
fi

if [ ! -n "$2" ]
  then
    echo "No database name"
    exit 1
fi


PTH="/url/to/your/webroot/$1"

if [ -d "$PTH" ]
  then
    echo "Path already exists"
    exit 1
fi

ROOT="/"
ROOTPSWD=""
DBNAME="$2"
DBUSER=""
DBPASS=""

# Create path and get WP finnish

mkdir -p "$PTH"
cd "$PTH"
wget "https://fi.wordpress.org/latest-fi.tar.gz"
tar xfz "latest-fi.tar.gz"
mv wordpress/* ./
rmdir ./wordpress/
rm -f "latest-fi.tar.gz"

# Create database

mysql -uroot -p${ROOTPSWD} -e "CREATE DATABASE $DBNAME CHARACTER SET utf8 COLLATE utf8_swedish_ci"
mysql -uroot -p${ROOTPSWD} -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost'"

# Edit config. This one is for finnish translation. Check for correct regexp if using another translation

mv wp-config-sample.php wp-config.php

sed -i "s/tietokannan_nimi/$DBNAME/g" wp-config.php
sed -i "s/tietokannan_tunnus/$DBUSER/g" wp-config.php
sed -i "s/tietokannan_salasana/$DBPASS/g" wp-config.php

# Copy boilerplate theme (optional)
#mkdir -p "$PTH/wp-content/themes/new_theme"
#rsync -av "$ROOT/your/theme/" "$PTH/wp-content/themes/new_theme"
