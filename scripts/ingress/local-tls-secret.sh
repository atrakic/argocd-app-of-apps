#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

NS=$1
kubectl -n "$NS" create secret tls ingress-local-tls \
  --cert=tls.crt \
  --key=tls.key
