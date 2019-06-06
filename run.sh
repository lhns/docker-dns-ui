#!/bin/bash

cat config_template.ini | envsubst > config/config.ini

if ! grep -q 'INSERT INTO "user"' migrations/002.php
then
  sed -i '/\}$/{e cat '<(echo '
    $stmt = $this->database->prepare('"'"'
    INSERT INTO "user" (uid, name, email, active, admin, auth_realm)
      VALUES (?, ?, ?, ?, ?, ?)
    '"'"')->execute(array(
        "admin",
        $_ENV["DNSUI_ADMIN_NAME"],
        $_ENV["DNSUI_ADMIN_EMAIL"],
        1,
        1,
        "local"
    ));
')$'\n}' migrations/002.php
fi

apache2ctl start
tail -f /var/log/apache2/error.log | sed -u 's/\\n/\n/g' | sed -u 's/\\t/\t/g'
