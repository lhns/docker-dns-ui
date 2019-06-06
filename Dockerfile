FROM lolhens/baseimage:latest
MAINTAINER LolHens <pierrekisters@gmail.com>


ENV DNSUI_VERSION 0.2.3
ENV DNSUI_NAME dns-ui-$DNSUI_VERSION
ENV DNSUI_FILE v$DNSUI_VERSION.tar.gz
ENV DNSUI_URL https://github.com/operasoftware/dns-ui/archive/$DNSUI_FILE
ENV DNSUI_HOME /usr/local/dns-ui


RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y \
      php \
      php-intl \
      php-json \
      php-curl \
      php-mbstring \
      php-ldap \
      php-pgsql \
 && cleanimage

RUN cd "/tmp" \
 && curl -LO $DNSUI_URL \
 && tar -xf $DNSUI_FILE \
 && mv $DNSUI_NAME $DNSUI_HOME \
 && cleanimage

COPY ["dns-ui.conf", "/etc/apache2/conf-available/"]
RUN ln -s /etc/apache2/conf-available/dns-ui.conf /etc/apache2/conf-enabled/.


RUN mv $DNSUI_HOME/config/config-sample.ini $DNSUI_HOME/config-sample.ini

CMD cp -n $DNSUI_HOME/config-sample.ini $DNSUI_HOME/config/config.ini; apache2ctl start; tail -f /var/log/apache2/error.log | sed 's/\\n/\n/g'
