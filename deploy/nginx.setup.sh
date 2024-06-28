#!/bin/bash

DOMAIN_OR_IP="4.246.136.160"
WEB_ROOT="/var/www/userinfosite"
CONFIG_FILE="/etc/nginx/conf.d/userinfosite.conf"
REPO_URL="https://github.com/vicradon/user-info-site.git"

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use sudo."
    exit 1
fi

sudo apt update && sudo apt install -y nginx || { echo "Failed to install Nginx"; exit 1; }

sudo systemctl start nginx && sudo systemctl enable nginx || { echo "Failed to start or enable Nginx"; exit 1; }

if [ ! -d "$WEB_ROOT" ]; then
    sudo mkdir -p $WEB_ROOT || { echo "Failed to create web root directory"; exit 1; }
fi

if [ ! -d "$WEB_ROOT/.git" ]; then
    sudo -u $USER git clone $REPO_URL $WEB_ROOT || { echo "Failed to clone repository"; exit 1; }
else
    echo "Repository already cloned in $WEB_ROOT"
fi

sudo chown -R $USER:$USER $WEB_ROOT || { echo "Failed to change ownership"; exit 1; }
sudo chmod -R 755 $WEB_ROOT || { echo "Failed to set permissions"; exit 1; }

echo "server {
    listen 80;
    server_name $DOMAIN_OR_IP;

    root $WEB_ROOT;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}" | sudo tee $CONFIG_FILE || { echo "Failed to create Nginx configuration"; exit 1; }

sudo nginx -t && sudo systemctl restart nginx || { echo "Nginx configuration test failed"; exit 1; }

echo "Nginx is set up to serve your static website at http://$DOMAIN_OR_IP"
