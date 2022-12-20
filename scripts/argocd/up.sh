#!/usr/bin/env bash
set -o errexit

NS=argocd
kubectl create namespace "$NS" || true
kubectl apply -n "$NS" -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n "$NS" --timeout=600s
kubectl wait --for=condition=available deployment argocd-repo-server -n "$NS" --timeout=60s
kubectl wait --for=condition=available deployment argocd-dex-server -n "$NS" --timeout=60s

# disable TLS on argocd server
#kubectl -n "$NS" patch deployment argocd-server --type json \
#  -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--staticassets","/shared/app","--insecure"] }]'

#NS=argo-rollouts
#kubectl create namespace "$NS" || true
#kubectl apply -n "$NS" -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

#NS=argocd-image-updater
#kubectl create namespace "$NS" || true
#kubectl apply -n "$NS" -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml
