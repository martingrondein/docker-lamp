FROM php:8.1.7-fpm-alpine3.16

# Set Composer version to install - https://getcomposer.org/download/
ARG COMPOSER_VERSION="2.3.7"
ARG COMPOSER_SUM="3f2d46787d51070f922bf991aa08324566f726f186076c2a5e4e8b01a8ea3fd0"

# Install system dependencies
RUN set -eux \
    && apk add --no-cache \
        ca-certificates \
        freetype \
        git \
        make \
        nano \
        nodejs \
        npm \
        openssl \
        tar \
        unzip \
        vim \
        yaml

# Install php extensions
RUN set -eux \
    && apk add --no-cache \
        curl-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        openssl-dev \
        yaml-dev \
        zlib-dev

# Install Docker extensions
RUN set -eux \
    && docker-php-ext-install \
        exif \
        pcntl \
        pdo_mysql \
        zip

# Configure PHP extensions
RUN set -eux \
    && docker-php-ext-configure \
        gd --with-jpeg --with-webp --with-freetype

# Insall PHP gd extension
RUN set -eux \
    && docker-php-ext-install gd

# Install Composer
RUN set -eux \
    && curl -LO "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" \
    && echo "${COMPOSER_SUM}  composer.phar" | sha256sum -c - \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && composer --version \
    && true

# Perform PHP-FPM testing
RUN set -eux \
    && echo "Performing PHP-FPM tests..." \
    && echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
    && php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^8.1' \
    && /usr/local/sbin/php-fpm --test \
    \
    && PHP_ERROR="$( php -v 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
    && PHP_ERROR="$( php -i 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
    \
    && PHP_FPM_ERROR="$( php-fpm -v 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
    && PHP_FPM_ERROR="$( php-fpm -i 2>&1 1>/dev/null )" \
    && if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
    && rm -f /usr/local/etc/php/php.ini \
    && true

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents
COPY . /var/www

STOPSIGNAL SIGQUIT

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]