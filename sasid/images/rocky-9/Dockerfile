FROM rockylinux:9
LABEL org.opencontainers.image.authors="support@halon.io"

ARG HALON_REPO_USER
ARG HALON_REPO_PASS

RUN yum update -y && yum install -y epel-release

RUN echo "[halon]" >> /etc/yum.repos.d/Halon.repo
RUN echo "name=Halon repository" >> /etc/yum.repos.d/Halon.repo
RUN echo "baseurl=https://${HALON_REPO_USER}:${HALON_REPO_PASS}@repo.halon.io/dists/rhel9/amd64/stable" >> /etc/yum.repos.d/Halon.repo
RUN echo "gpgcheck=1" >> /etc/yum.repos.d/Halon.repo
RUN echo "gpgkey=https://raw.githubusercontent.com/halon/pgp-keys/master/pgp-keys/7F0A73B5.asc" >> /etc/yum.repos.d/Halon.repo
RUN echo "enabled=1" >> /etc/yum.repos.d/Halon.repo
RUN yum install -y sasid-5.1.3

RUN groupadd -g 2000 sasid
RUN useradd -u 2000 -g 2000 sasid

RUN /usr/bin/install -d -m 0770 -g 2000 /var/sasid/data
RUN /usr/bin/install -d -m 0770 -g 2000 /var/sasid/rsync
RUN /usr/bin/install -d -m 0770 -g 2000 /var/log/sasid

CMD [ "/opt/sasid/bin/sasid", "-c", "/etc/sasid/sasid.conf" ]
