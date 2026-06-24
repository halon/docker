FROM ubuntu:24.04
LABEL org.opencontainers.image.authors="support@halon.io"

ARG HALON_REPO_USER
ARG HALON_REPO_PASS

RUN apt-get update && apt-get install -y wget gnupg
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates

RUN wget -O- https://raw.githubusercontent.com/halon/pgp-keys/master/pgp-keys/7F0A73B5.gpg >> /usr/share/keyrings/halon-archive-keyring.gpg
RUN . /etc/lsb-release && echo "deb [arch=`dpkg --print-architecture` signed-by=/usr/share/keyrings/halon-archive-keyring.gpg] https://repo.halon.io/ $DISTRIB_CODENAME stable" >> /etc/apt/sources.list.d/halon.list
RUN echo "machine repo.halon.io login ${HALON_REPO_USER} password ${HALON_REPO_PASS}" >> /etc/apt/auth.conf
RUN apt-get update && apt-get install -y savdid=3.93.1

RUN wget -qO - https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN chmod 644 /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl

RUN apt-get install -y wget zip

RUN groupadd -g 2000 savdid
RUN useradd -u 2000 -g 2000 savdid

RUN /usr/bin/install -d -m 0770 -g 2000 /var/run/savdid

CMD [ "/opt/savdid/bin/savdid", "-c", "/etc/savdid/savdid.conf" ]
