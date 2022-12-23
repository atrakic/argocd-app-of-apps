#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

curl -fisk -LX GET 127.0.0.1:80 -H"Host: $1"
