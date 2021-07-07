FROM php:7.4-apache

# install php module libraries
RUN apt-get update && apt-get install -y \
    vim \
    cron \
    git \
    libc-client-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libpq-dev \
    openssl \
    libxml2-dev \
    wkhtmltopdf \
    xvfb \
    zip \
    # https://github.com/docker-library/php/issues/61
    zlib1g-dev \
    libzip-dev \
&& rm -rf /var/lib/apt/lists/*

# install needed php modules (https://github.com/docker-library/php/issues/912)
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/&& \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
&& docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    iconv \
    imap \
    opcache \
    pdo_pgsql \
    pgsql \
    soap \
    zip

# install memcached and redis
RUN pecl install memcached redis && \
    docker-php-ext-enable memcached && \
    docker-php-ext-enable redis

# enable mod_rewrite
 RUN a2enmod rewrite

 # enable mod_headers
RUN a2enmod headers

# configure php
RUN echo "output_buffering = 4096" >> $PHP_INI_DIR/php.ini && \
    echo "post_max_size = 250M" >> $PHP_INI_DIR/php.ini && \
    echo "upload_max_filesize = 200M" >> $PHP_INI_DIR/php.ini && \
    echo "assert.active = 0" >> $PHP_INI_DIR/php.ini && \
    echo "short_open_tag = Off" >> $PHP_INI_DIR/php.ini && \
    echo "enable_dl = 0" >> $PHP_INI_DIR/php.ini && \
    echo "disable_classes = com,dotnet,Reflection" >> $PHP_INI_DIR/php.ini && \
    echo "disable_functions = pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority" >> $PHP_INI_DIR/php.ini && \
    echo "expose_php = 0" >> $PHP_INI_DIR/php.ini && \
    echo "log_errors = 1" >> $PHP_INI_DIR/php.ini && \
    echo "max_input_vars = 5000" >> $PHP_INI_DIR/php.ini

# install composer
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer