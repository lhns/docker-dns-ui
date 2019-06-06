FROM lolhens/baseimage:latest
MAINTAINER LolHens <pierrekisters@gmail.com>


ENV DNSUI_VERSION 53f5118a1d0ebc7ae144e84480932eaa1833c818
ENV DNSUI_URL https://github.com/operasoftware/dns-ui/archive/$DNSUI_VERSION.tar.gz

ENV DNSUI_HOME /opt/dns-ui
ENV DNSUI_ADMIN_USER admin
ENV DNSUI_ADMIN_NAME admin
ENV DNSUI_ADMIN_EMAIL admin@example.com
ENV DNSUI_WEB_BASEURL https://dns.example.com
ENV DNSUI_DB_HOST localhost
ENV DNSUI_DB_DBNAME dnsui
ENV DNSUI_DB_USER username
ENV DNSUI_DB_PASS password
ENV DNSUI_API_URL http://localhost:8081
ENV DNSUI_API_KEY api_key


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

RUN mkdir "$DNSUI_HOME" \
 && curl -L $DNSUI_URL | tar -xzC "$DNSUI_HOME" --strip-components=1

WORKDIR $DNSUI_HOME

COPY ["config_template.ini", "$DNSUI_HOME/"]

COPY ["dns-ui.conf", "/etc/apache2/conf-available/"]
RUN ln -s /etc/apache2/conf-available/dns-ui.conf /etc/apache2/conf-enabled/.


COPY ["run.sh", "$DNSUI_HOME/"]
RUN chmod +x run.sh

CMD ["$DNSUI_HOME/run.sh"]
