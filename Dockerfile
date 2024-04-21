FROM unit:1.32.1-php8.3

LABEL org.opencontainers.image.authors="andrew.stephanoff@gmail.com"

ARG DEBIAN_FRONTEND="noninteractive"
ARG TZ="UTC"

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    && apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes \
        libc-client-dev \
        libicu-dev \
        libkrb5-dev \
        libldap2-dev \
        libmagickwand-dev \
        libmemcached-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        zlib1g-dev \
    && docker-php-ext-configure imap \
        --with-kerberos \
        --with-imap-ssl \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install \
        bcmath \
        gd \
        imap \
        intl \
        ldap \
        opcache \
        pdo \
        pdo_mysql \
        soap \
        zip \
    && pecl channel-update pecl.php.net \
    && pecl install \
        igbinary \
        imagick \
        memcached \
        msgpack \
        redis \
        xdebug \
    && docker-php-ext-enable \
        bcmath \
        gd \
        igbinary \
        imap \
        imagick \
        intl \
        ldap \
        memcached \
        msgpack \
        opcache \
        pdo_mysql \
        redis \
        soap \
        xdebug \
        zip

ADD config.json /docker-entrypoint.d/config.json
ADD xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /srv/www
