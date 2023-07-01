#!/usr/bin/env bash

set -ev

export DEBIAN_FRONTEND=noninteractive
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
apt-get update -y
apt-get install -yq \
  apt-transport-https \
  ca-certificates \
  curl
