#!/usr/bin/env bash

function docker_dev_exec() {
  local cmd="$1"
  shift
  exec docker compose exec -e RAILS_ENV=development spec "$cmd" "$@"
}

function docker_test_exec() {
  local cmd="$1"
  shift
  exec docker compose exec -e RAILS_ENV=test spec "$cmd" "$@"
}
