FROM debian:stretch

WORKDIR /usr/share/kanboard

ARG PHP_VERSION=7.2

# Install nginx

RUN apt update
RUN apt install -y \
    nginx \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    wget

# nginx Configuration
RUN rm /etc/nginx/sites-enabled/default
COPY ./configuration/standalone.conf /etc/nginx/sites-enabled/standalone.conf

# PHP 7.2 installation    
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt update
RUN apt install -y php${PHP_VERSION} \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-sqlite \
    curl \
    git

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" 
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir /usr/local/bin --filename composer
RUN php -r "unlink('composer-setup.php');"

# PHP-FPM Configuration
RUN mkdir -p /run/php
#COPY ./php /etc/php/${PHP_VERSION}/fpm/pool.d/

# Kanboard source code
RUN git clone https://github.com/kanboard/kanboard.git /usr/share/kanboard
RUN composer install
RUN chown -R www-data:www-data /usr/share/kanboard

# Start PHP-FPM in the background
RUN php-fpm${PHP_VERSION}

RUN apt install -y supervisor
# Configuration for supervisord
RUN mkdir -p /var/log/supervisor /etc/supervisor/conf.d
COPY configuration/supervisor.conf /etc/supervisor/supervisor.conf

# TODO: DB CONFIGURATION, PHP VERSION SUPERVISORD

CMD [ "supervisord", "-c", "/etc/supervisor/supervisor.conf" ]