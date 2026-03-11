#!/bin/sh
set -e

if [ -f /etc/halon/tls/ca-crt/tls.crt ]; then
    cp /etc/halon/tls/ca-crt/tls.crt /etc/pki/ca-trust/source/anchors/halon-ca.crt
    update-ca-trust extract
fi

/opt/halon/bin/halonctl license fetch --username ${HALON_REPO_USER} --password ${HALON_REPO_PASS} --path /license.key

exec "$@"
