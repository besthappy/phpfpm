FROM php:fpm

ARG INSTALL_XDEBUG=true
ENV INSTALL_XDEBUG ${INSTALL_XDEBUG}
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi

RUN apt-get update && apt-get install -y libz-dev libmemcached-dev libjpeg-dev libpng-dev libmcrypt-dev libpng12-dev libxml2-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql mysqli gd opcache \
    && docker-php-ext-enable pdo pdo_mysql mysqli gd opcache \
    && docker-php-ext-install -j$(nproc) mcrypt mbstring bcmath json iconv \
    && docker-php-ext-enable mcrypt mbstring bcmath json iconv

RUN docker-php-ext-install zip \
    && docker-php-ext-enable zip

RUN curl https://getcomposer.org/download/1.2.0/composer.phar > /tmp/composer.phar \
    && chmod +x /tmp/composer.phar \
    && mv /tmp/composer.phar /usr/local/bin/composer \
    && apt-get update && apt-get install -y less \
    && curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /tmp/wp-cli.phar \
    && chmod +x /tmp/wp-cli.phar \
    && mv /tmp/wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
