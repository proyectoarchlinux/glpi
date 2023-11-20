#!/bin/bash

apt update
apt install -y systemctl

NUEVA_CONTRASENA="1769"
echo "root:$NUEVA_CONTRASENA" | chpasswd

# Descargar el fichero
apt-get install wget && wget -q https://github.com/glpi-project/glpi/releases/download/10.0.6/glpi-10.0.6.tgz

# Descomprimir glpi y moverlo a directorio /var/www
tar xf glpi-10.0.6.tgz -C /var/www

# Crear directorios
mkdir /etc/glpi /var/log/glpi
mv /var/www/glpi/files/ /var/lib/glpi

# Crear archivo de configuracion
echo "<?php
define('GLPI_CONFIG_DIR', '/etc/glpi/');
if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
        require_once GLPI_CONFIG_DIR . '/local_define.php';
}" > /var/www/glpi/inc/downstream.php

echo "<?php
define('GLPI_VAR_DIR', '/var/lib/glpi');
define('GLPI_LOG_DIR', '/var/log/glpi');" > /etc/glpi/local_define.php

# Dar permisos
chown -R www-data: /var/www/glpi/ /etc/glpi/ /var/lib/glpi/ /var/log/glpi/

# Servicio web
a2enmod expires rewrite

echo "Alias /glpi /var/www/glpi
<Directory /var/www/glpi>
        AllowOverride all
</Directory>" > /etc/apache2/sites-available/glpi.conf

a2ensite glpi.conf

systemctl restart apache2

# PHP

# Dependencias
export DEBIAN_FRONTEND=noninteractive
apt-get install -y php
apt-get install -y php-curl php-dg php-ldap php-xml php-mysqli php-intl
apt-get install -y php-mysqli php-fileinfo php-json php-curl php-gd php-intl php-dom php-simplexml 

systemctl reload apache2

# Creacion de base de datos
apt install -y default-mysql-server
service mysql start

# Variables de configuracion
DB_NAME="glpi"
DB_USER="glpi"
DB_PASSWORD="esperances11"

# Consultas SQL
SQL_QUERIES=$(cat <<EOF
CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
GRANT SELECT ON mysql.time_zone_name TO '$DB_USER'@'localhost';
EOF
)

# Ejecutar las consultas
MYSQL_ROOT_PASSWORD="1769"
echo "$SQL_QUERIES" | mysql -u root -p"$MYSQL_ROOT_PASSWORD"

systemctl reload apache2
