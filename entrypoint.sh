#!/bin/bash
set -e

dockerize -wait tcp://db:5432 -timeout 1m
bin/rails db:setup
exec "$@"
