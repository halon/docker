#!/bin/sh
set -e

/opt/halon/bin/halonctl license fetch --username ${HALON_REPO_USER} --password ${HALON_REPO_PASS} --path /var/run/halon/license.key

exec "$@"
