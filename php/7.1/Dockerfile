# PHP 7.1 container.
FROM dockerdepot/base:ubuntu-16.04

# Increment this to trigger a full rebuild.
ENV DC_PHP_VERSION 'php-7.1-1.0.0'

# Install all packages.
RUN apt-get update

## Apache, Memcached & MySQL client.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 \
  memcached mysql-client

# Configure Apache.
COPY ./conf/apache2/httpd-vhosts.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod vhost_alias rewrite ssl headers

## Fix issue with SSLMutex.
RUN mkdir -p /var/run/apache2

# Install & configure PHP.
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  php7.1 \
  php7.1-cli \
  php7.1-gd \
  php7.1-dev \
  php7.1-curl \
  php7.1-mysql \
  php7.1-xml \
  php-memcached \
  php-soap \
  php-pear

# Configure PHP.
ADD ./conf/php/30-overrides.ini /etc/php/7.1/apache2/conf.d/30-overrides.ini

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install drush.
RUN curl -s -L https://github.com/drush-ops/drush/releases/latest | egrep -o '/drush-ops/drush/releases/download/[v.0-8]*/drush.phar' | wget --base=http://github.com/ -i - -O /usr/local/bin/drush
RUN chmod +x /usr/local/bin/drush

# Update PATH to include Composer's bin (also add into /etc/profile so that our
# tests pick it up too).
ENV COMPOSER_BIN /root/.composer/vendor/bin
ENV PATH "$COMPOSER_BIN:$PATH"
RUN echo "" >> /etc/profile
RUN echo "PATH=$COMPOSER_BIN:\$PATH" >> /etc/profile

# Registry rebuild for Drush.
RUN drush @none dl registry_rebuild-7.x

# Startup settings.
ADD ./conf/supervisor/php.conf /etc/supervisor/conf.d/php.conf

# HTTP.
EXPOSE 80

WORKDIR /var/www

CMD ["/usr/bin/supervisord", "-n"]
