FROM ubuntu:14.04
MAINTAINER Adrien Pensart <adrien.pensart@corp.ovh.com>

RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl mosh tmux git build-essential sqlite3-dev libattr1-dev pkg-config htop locate python3-pip python3-setuptools
ENV VERSION s3ql-2.17.1

WORKDIR /
CMD ["/bin/bash"]
