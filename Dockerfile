FROM ubuntu:14.04
MAINTAINER Adrien Pensart <adrien.pensart@corp.ovh.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq
RUN apt-get install -y curl mosh tmux git build-essential libsqlite3-dev libattr1-dev pkg-config htop locate python3-pip python3-setuptools libfuse-dev openssh-server
ENV VERSION s3ql-2.17.1

RUN curl -O -J -L https://bitbucket.org/nikratio/s3ql/downloads/${VERSION}.tar.bz2
RUN tar xvj -C /usr/src -f ${VERSION}.tar.bz2
WORKDIR /usr/src/${VERSION}
RUN pip3 install dugong llfuse defusedxml pycrypto apsw
RUN python3 setup.py build_ext --inplace
RUN python3 setup.py install

RUN mkdir /var/run/sshd
RUN echo "root:$(date +%s | sha256sum | base64 | head -c 16 ; echo)" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY rsync-s3ql.sh /home/
COPY fuse.conf /etc/
WORKDIR /home
EXPOSE 22
CMD bash rsync-s3ql.sh
