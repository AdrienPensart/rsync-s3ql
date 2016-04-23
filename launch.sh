#!/bin/bash

tmpfile=$(mktemp /tmp/test-XXX.env)
echo "Using $tmpfile"
gpg2 --decrypt -r adrien.pensart@corp.ovh.ca testcontainer.env.gpg > $tmpfile
docker run -d --env-file $tmpfile --privileged -p 2222:22 -t rsync-s3ql
