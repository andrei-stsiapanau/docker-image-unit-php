FROM unit:1.32.1-php8.3

LABEL org.opencontainers.image.authors="andrew.stephanoff@gmail.com"

ARG DEBIAN_FRONTEND="noninteractive"
ARG TZ="UTC"

ADD config.json /docker-entrypoint.d/

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
        igbinary \
        imagick \
        memcached \
        msgpack \
        redis \
        xdebug \
        soap \
        zip \
        && apt-get --yes remove \
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
    && apt-get --yes autoremove \
    && apt-get --yes clean

ADD config.json /docker-entrypoint.d/config.json

WORKDIR /srv/www
