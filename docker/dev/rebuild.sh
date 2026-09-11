#!/usr/bin/env bash

set -e

docker compose up -d --force-recreate --no-deps db redis test-redis

docker compose up --force-recreate --no-deps --build migrations

docker compose up -d --force-recreate --no-deps --build web worker spec assets
