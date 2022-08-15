#! /bin/bash
apt update
apt -y install apache2
cat <<EOF> /var/www/html/index.html
<!DOCTYPE html><html lang="en"><head><title>Hello World</title></head><body><h1>Hello World!</h1></body></html>
