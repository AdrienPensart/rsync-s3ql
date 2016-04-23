#!/bin/bash

CRED=s3ql.cred
cat <<EOT >> $CRED
[container]
storage-url: $URL
backend-login: $TENANT:$USER
backend-password: $PASSWORD
EOT
chmod 0600 $CRED

echo "root:$PASSWORD" | chpasswd
mount.s3ql --fg --allow-other --authfile $CRED $URL /mnt

if [ $? -eq 18 ]; then
    mkfs.s3ql --authfile $CRED --plain $URL
    mount.s3ql --fg --allow-other --authfile $CRED $URL /mnt
fi

/usr/sbin/sshd -D
