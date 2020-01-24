# Update PHP-FPM Host and port according to Environment Variables
sed -i "s/php-fpm:9100/$FASTCGI_HOST:$FASTCGI_PORT/g" /etc/nginx/sites-enabled/default

# Run NGINX
nginx -g "daemon off;"
