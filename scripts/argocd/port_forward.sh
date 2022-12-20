#!/usr/bin/env bash
set -o errexit

PORT=8080
NS=argocd

echo "Forwarding argocd on port $PORT"
killall kubectl || kubectl -n "$NS" port-forward svc/argocd-server "$PORT":443
