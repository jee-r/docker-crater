FROM php:7.4-fpm-bullseye

LABEL name="docker-crater" \
      maintainer="Jee jee@jeer.fr" \
      description="Free & Open Source Invoice App for Freelancers & Small Businesses" \
      url="https://craterapp.com" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-crater"
      
RUN apt-get update && apt-get install -y \
      git \
      curl \
      libpng-dev \
      libonig-dev \
      libxml2-dev \
      zip \
      unzip \
      libzip-dev \
      libmagickwand-dev \
      mariadb-client && \
    pecl install imagick && \
    docker-php-ext-enable imagick && \
    docker-php-ext-install \
      pdo_mysql \
      mbstring \
      zip \
      exif \
      pcntl \
      bcmath \
      gd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY rootfs / 

ENTRYPOINT ["/usr/local/bin/entrypoint"]
