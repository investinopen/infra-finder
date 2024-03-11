#!/usr/bin/env bash

set -eux

docker-compose exec web bin/rails db:create
docker-compose exec web bin/rails db:migrate
docker-compose exec web bin/rails db:seed
