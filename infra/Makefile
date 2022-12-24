all:
	@helm template . # --set-string logging.enable=false .

ingress-nginx:
	helm show values ingress-nginx --repo https://kubernetes.github.io/ingress-nginx

cert-manager:
	helm show values cert-manager --repo https://charts.jetstack.io

prometheus-community:
	helm show values kube-prometheus-stack --repo https://prometheus-community.github.io/helm-charts

sealed-secrets:
	helm show values sealed-secrets --repo https://bitnami-labs.github.io/sealed-secrets

local-path-provisioner:
	curl -s https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.23/deploy/local-path-storage.yaml

argo:
	helm show values argo --repo https://argoproj.github.io/argo-helm
