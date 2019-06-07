FROM lolhens/baseimage:latest
MAINTAINER LolHens <pierrekisters@gmail.com>


ENV DNSUI_VERSION 53f5118a1d0ebc7ae144e84480932eaa1833c818
ENV DNSUI_URL https://github.com/operasoftware/dns-ui/archive/$DNSUI_VERSION.tar.gz
ENV DNSUI_HOME /opt/dns-ui

# ENV DNSUI_WEB_BASEURL
ENV DNSUI_ADMIN_NAME admin
ENV DNSUI_ADMIN_EMAIL admin@example.com
ENV DNSUI_DB_HOST localhost
ENV DNSUI_DB_DBNAME dnsui
ENV DNSUI_DB_USER username
ENV DNSUI_DB_PASS password
ENV DNSUI_API_URL http://localhost:8081
ENV DNSUI_API_KEY api_key
ENV DNSUI_EMAIL_ENABLED 0
ENV DNSUI_EMAIL_FROM_ADDRESS dns@example.com
ENV DNSUI_EMAIL_FROM_NAME DNS management system
ENV DNSUI_EMAIL_REPORT_ADDRESS admin@example.com
ENV DNSUI_EMAIL_REPORT_NAME Domain administrator
ENV DNSUI_DNS_DNSSEC_ENABLED 1
ENV DNSUI_DNS_AUTOCREATE_REVERSE_RECORDS 1
ENV DNSUI_DNS_LOCAL_ZONE_SUFFIXES localdomain
ENV DNSUI_DNS_LOCAL_IPV4_RANGES 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 127.0.0.0/8
ENV DNSUI_DNS_LOCAL_IPV6_RANGES fd00::/8 ::1/128


RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y \
      gettext \
      php \
      php-intl \
      php-json \
      php-curl \
      php-mbstring \
      php-ldap \
      php-pgsql \
 && cleanimage

RUN mkdir "$DNSUI_HOME"
WORKDIR $DNSUI_HOME

RUN curl -L $DNSUI_URL | tar -xz --strip-components=1

RUN sed -i -r 's/^(\s*).*Not logged in.*$/\1$active_user = $user_dir->get_user_by_uid('"'admin'"');/' requesthandler.php

COPY ["config_template.ini", "$DNSUI_HOME/"]

COPY ["dns-ui.conf", "/etc/apache2/conf-available/"]
RUN ln -s /etc/apache2/conf-available/dns-ui.conf /etc/apache2/conf-enabled/.


COPY ["run.sh", "$DNSUI_HOME/"]
RUN chmod +x run.sh

CMD ["./run.sh"]
