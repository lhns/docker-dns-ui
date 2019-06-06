#!/bin/bash

cat config_template.ini | envsubst > config/config.ini

if ! grep -q 'add_user' migrations/002.php
then
  sed -i '/\}$/{e cat '<(echo '
    require('"'../core.php'"');
    $user = new User;
    $user->auth_realm = '"'local'"';
    $user->uid = '"'admin'"';
    $user->name = '"'$DNSUI_ADMIN_NAME'"';
    $user->email = '"'$DNSUI_ADMIN_EMAIL'"';
    $user->active = 1;
    $user->admin = 1;
    $user_dir->add_user($user);
')$'\n}' migrations/002.php
fi

apache2ctl start
tail -f /var/log/apache2/error.log | sed -u 's/\\n/\n/g' | sed -u 's/\\t/\t/g'
