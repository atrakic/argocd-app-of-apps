all:
	@helm template --set-string logging.enable=false .

cert-manager:
	helm show values jetstack/cert-manager

prometheus-community:
	helm show values prometheus-community/kube-prometheus-stack
