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
RUN yum install -y savdid-3.93.1

RUN echo "[kubernetes]" >> /etc/yum.repos.d/kubernetes.repo
RUN echo "name=Kubernetes" >> /etc/yum.repos.d/kubernetes.repo
RUN echo "baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/" >> /etc/yum.repos.d/kubernetes.repo
RUN echo "enabled=1" >> /etc/yum.repos.d/kubernetes.repo
RUN echo "gpgcheck=1" >> /etc/yum.repos.d/kubernetes.repo
RUN echo "gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key" >> /etc/yum.repos.d/kubernetes.repo
RUN yum install -y kubectl

RUN yum install -y wget zip findutils

RUN groupadd -g 2000 savdid
RUN useradd -u 2000 -g 2000 savdid

RUN /usr/bin/install -d -m 0770 -g 2000 /var/run/savdid

CMD [ "/opt/savdid/bin/savdid", "-c", "/etc/savdid/savdid.conf" ]
