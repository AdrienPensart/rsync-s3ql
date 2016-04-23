#!/bin/bash

docker run -d --env-file prod.env --privileged -p 2222:22 -t rsync-s3ql
