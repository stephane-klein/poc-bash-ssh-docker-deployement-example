#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

gomplate -f _deploy_miniflux.sh | ssh root@$SERVER1_IP 'bash -s'
