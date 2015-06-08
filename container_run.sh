#!/bin/bash
s3fs -o allow_other ${YOUR_BUCKET_NAME} ${YOUR_MOUNT_POINT} \
    -o passwd_file=${YOUR_PASSWORD_FILE} \
            -o url=https://storage.googleapis.com

/usr/sbin/sshd -D
