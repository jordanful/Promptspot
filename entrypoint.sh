#!/bin/bash
set -e

# Wait for the DB to be ready
dockerize -wait tcp://db:5432 -timeout 1m

# bin/rails db:seed
# bin/rails db:migrate
bin/rails db:setup

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
