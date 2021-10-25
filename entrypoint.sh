#!/bin/bash
set -e

rm -f /map/tmp/pids/server.pid

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup

exec bundle exec "$@"
