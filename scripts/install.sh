#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

ssh root@$SERVER1_IP 'bash -s' < install_basic_server_configuration.sh
