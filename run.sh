#!/bin/bash

cat config_template.ini | envsubst > config/config.ini

echo "$DNSUI_ADMIN_USER
$DNSUI_ADMIN_NAME
$DNSUI_ADMIN_EMAIL" | scripts/create_admin_account.php

apache2ctl start
tail -f /var/log/apache2/error.log | sed -u 's/\\n/\n/g' | sed -u 's/\\t/\t/g'
