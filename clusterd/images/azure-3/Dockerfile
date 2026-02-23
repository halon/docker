FROM mcr.microsoft.com/azurelinux/base/core:3.0
LABEL org.opencontainers.image.authors="support@halon.io"

ARG HALON_REPO_USER
ARG HALON_REPO_PASS

RUN tdnf install -y ca-certificates azurelinux-repos-extended shadow-utils

RUN echo "[halon]" >> /etc/yum.repos.d/Halon.repo
RUN echo "name=Halon repository" >> /etc/yum.repos.d/Halon.repo
RUN echo "baseurl=https://${HALON_REPO_USER}:${HALON_REPO_PASS}@repo.halon.io/dists/azure3/amd64/stable" >> /etc/yum.repos.d/Halon.repo
RUN echo "gpgcheck=1" >> /etc/yum.repos.d/Halon.repo
RUN echo "gpgkey=https://raw.githubusercontent.com/halon/pgp-keys/master/pgp-keys/7F0A73B5.asc" >> /etc/yum.repos.d/Halon.repo
RUN echo "enabled=1" >> /etc/yum.repos.d/Halon.repo
RUN tdnf install -y halon-clusterd-1.1.2

RUN groupadd -g 2000 clusterd
RUN useradd -u 2000 -g 2000 clusterd

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["sh", "-c", "exec env LD_LIBRARY_PATH=/opt/halon/lib/clusterd/:$LD_LIBRARY_PATH /opt/halon/sbin/clusterd -f"]
