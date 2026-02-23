FROM ubuntu:24.04
LABEL org.opencontainers.image.authors="support@halon.io"

ARG HALON_REPO_USER
ARG HALON_REPO_PASS

RUN apt-get update && apt-get install -y wget gnupg
RUN apt-get update && apt-get install -y apt-transport-https

RUN wget -O- https://raw.githubusercontent.com/halon/pgp-keys/master/pgp-keys/7F0A73B5.gpg >> /usr/share/keyrings/halon-archive-keyring.gpg
RUN . /etc/lsb-release && echo "deb [arch=`dpkg --print-architecture` signed-by=/usr/share/keyrings/halon-archive-keyring.gpg] https://repo.halon.io/ $DISTRIB_CODENAME stable" >> /etc/apt/sources.list.d/halon.list
RUN echo "machine repo.halon.io login ${HALON_REPO_USER} password ${HALON_REPO_PASS}" >> /etc/apt/auth.conf
RUN apt-get update && apt-get install -y halon-api=6.10.0

ENV NODE_ENV=production

RUN groupadd -g 2000 api
RUN useradd -u 2000 -g 2000 api

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD [ "/opt/halon/api/node/bin/node", "--use-openssl-ca", "/opt/halon/api/dist/bin/server.js" ]
