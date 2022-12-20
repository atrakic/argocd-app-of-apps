#!/usr/bin/env bash
set -o errexit

SERVER=127.0.0.1:8080
ARGO_PASSWORD=$(kubectl get secret argocd-initial-admin-secret \
    --namespace argocd \
    --output jsonpath="{.data.password}" |
    base64 --decode)

argocd login $SERVER \
    --insecure \
    --username=admin \
    --password="$ARGO_PASSWORD"
