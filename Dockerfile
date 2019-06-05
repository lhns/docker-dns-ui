FROM php:apache
MAINTAINER LolHens <pierrekisters@gmail.com>


ENV DNSUI_VERSION 0.2.3
ENV DNSUI_NAME dns-ui-$DNSUI_VERSION
ENV DNSUI_FILE v$DNSUI_VERSION.tar.gz
ENV DNSUI_URL https://github.com/operasoftware/dns-ui/archive/$DNSUI_FILE
ENV DNSUI_HOME /usr/local/dns-ui


ADD ["https://raw.githubusercontent.com/LolHens/docker-tools/master/bin/cleanimage", "/usr/local/bin/"]
RUN chmod +x "/usr/local/bin/cleanimage"

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y \
      libicu-dev \
 && docker-php-ext-configure intl \
 && docker-php-ext-install intl \
 && docker-php-ext-configure json \
 && docker-php-ext-install json \
 && docker-php-ext-configure curl \
 && docker-php-ext-install curl \
 && docker-php-ext-configure mbstring \
 && docker-php-ext-install mbstring \
 && docker-php-ext-configure ldap \
 && docker-php-ext-install ldap \
 && docker-php-ext-configure pgsql \
 && docker-php-ext-install pgsql \
 && cleanimage

RUN cd "/tmp" \
 && curl -LO $DNSUI_URL \
 && tar -xf $DNSUI_FILE \
 && mv $DNSUI_NAME $DNSUI_HOME \
 && cleanimage

COPY dns-ui.conf /etc/httpd/conf.d/

RUN sbt tasks
