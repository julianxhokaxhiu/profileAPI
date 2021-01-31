#!/usr/bin/env bash

##################################
# Utility functions
##################################

function util_exists
{
  if ! type "$1" > /dev/null 2>&1; then
    echo -e "Could not find '\e[36m$1\e[0m' in your current environment. Please ensure it is installed before running this script again."
    exit 1
  fi
}

##################################
# Preflight checks before building
##################################

util_exists "make"
util_exists "curl"
util_exists "jq"
util_exists "docker"
util_exists "docker-compose"
