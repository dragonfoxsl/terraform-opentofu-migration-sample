#!/bin/bash
# sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install nginx -y
# echo 'Hello World' | sudo tee /var/www/html/index.html
sudo systemctl enable nginx
sudo systemctl start nginx