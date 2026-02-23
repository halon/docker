#!/bin/sh
set -e

cp /etc/halon/tls/ca-crt/tls.crt /usr/local/share/ca-certificates/halon-ca.crt
update-ca-certificates

exec "$@"
