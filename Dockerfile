From ubuntu:16.04

# Install dependencies
RUN apt-get -y update && apt-get -y install software-properties-common

RUN apt-get -y update && apt-get -y --allow-unauthenticated install rsyslog supervisor php7.0-fpm php7.0-mysql php7.0-curl php7.0-mcrypt php7.0-cli php7.0-dev php-pear libsasl2-dev apache2 curl libapache2-mod-php php-bcmath autoconf g++ make openssl libssl-dev libcurl4-openssl-dev libcurl4-openssl-dev pkg-config libsasl2-dev libpcre3-dev iputils-ping

RUN a2enmod rewrite

RUN pecl install mongodb

RUN echo "extension=mongodb.so" >> /etc/php/7.0/apache2/php.ini
RUN echo "extension=mongo.so" >> /etc/php/7.0/apache2/php.ini

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

#Add site configs
ADD site.conf /etc/apache2/sites-enabled/site.conf
ADD index.php /var/www/html/index.php
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# start up apache in the foreground
# can only have one CMD per dockerfile, append multiple commands with &&

CMD  /usr/sbin/apache2ctl -D FOREGROUND
