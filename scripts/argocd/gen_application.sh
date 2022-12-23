#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

name="${1:?Application name?}"
repoURL="${2:?Application repoURL?}"
path="${3:?Application path}"
targetRevision="${4:-HEAD}"
server="${5:-https://kubernetes.default.svc}"
project="${6:-default}"

# https://github.com/argoproj/argo-cd/blob/master/manifests/crds/application-crd.yam
tee apps/templates/"${name}.yaml"<<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
 name: "${name}"
 namespace: argocd
spec:
 project: "${project}"
 source:
  repoURL: "${repoURL}"
  targetRevision: "${targetRevision}"
  path: "${path}"
 destination:
  server: "${server}"
  namespace: "${name}"
 syncPolicy:
  syncOptions:
   - CreateNamespace=true
  automated:
   selfHeal: true
   prune: true
EOF
