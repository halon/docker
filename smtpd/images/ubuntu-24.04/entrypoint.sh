#!/bin/sh
set -e

if [ -f /etc/halon/tls/ca-crt/tls.crt ]; then
    cp /etc/halon/tls/ca-crt/tls.crt /usr/local/share/ca-certificates/halon-ca.crt
    update-ca-certificates
fi

/opt/halon/bin/halonctl license fetch --username ${HALON_REPO_USER} --password ${HALON_REPO_PASS} --path /license.key

exec "$@"
