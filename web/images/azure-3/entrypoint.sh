#!/bin/sh
set -e

cp /etc/halon/tls/ca-crt/tls.crt /etc/pki/ca-trust/source/anchors/halon-ca.crt
update-ca-trust extract

exec "$@"
