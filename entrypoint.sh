#!/bin/bash
set -e

bin/rails db:setup
exec "$@"
