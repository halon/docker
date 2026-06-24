FROM ubuntu:24.04
LABEL org.opencontainers.image.authors="support@halon.io"

ARG HALON_REPO_USER
ARG HALON_REPO_PASS

RUN apt-get update && apt-get install -y wget gnupg
RUN apt-get update && apt-get install -y apt-transport-https

RUN wget -O- https://raw.githubusercontent.com/halon/pgp-keys/master/pgp-keys/7F0A73B5.gpg >> /usr/share/keyrings/halon-archive-keyring.gpg
RUN . /etc/lsb-release && echo "deb [arch=`dpkg --print-architecture` signed-by=/usr/share/keyrings/halon-archive-keyring.gpg] https://repo.halon.io/ $DISTRIB_CODENAME stable" >> /etc/apt/sources.list.d/halon.list
RUN echo "machine repo.halon.io login ${HALON_REPO_USER} password ${HALON_REPO_PASS}" >> /etc/apt/auth.conf
RUN apt-get update && apt-get install -y expurgate-spamd=4.54.1

RUN groupadd -g 2000 expurgate
RUN useradd -u 2000 -g 2000 expurgate

RUN /usr/bin/install -d -m 0770 -g 2000 /var/log/expurgate-spamd
RUN /usr/bin/install -d -m 0770 -g 2000 /var/spool/expurgate-spamd

CMD [ "/usr/bin/expurgate-spamd", "--no-daemonize", "--config", "/etc/expurgate-spamd/expurgate-spamd.conf" ]
