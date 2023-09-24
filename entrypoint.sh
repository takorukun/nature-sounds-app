#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

HOST=${HOST}
USER=${USER}
PASS=${PASS}
DB_NAME=${DB_NAME}

mysql -h$HOST -u$USER -p$PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
