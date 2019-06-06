#!/bin/bash

cp -n $DNSUI_HOME/config-sample.ini $DNSUI_HOME/config/config.ini

apache2ctl start
tail -f /var/log/apache2/error.log | sed -u 's/\\n/\n/g' | -u sed 's/\\t/\t/g'
