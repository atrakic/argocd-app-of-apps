MAKEFLAGS += --silent

SERVER := 127.0.0.1:8080

APP ?= root

.DEFAULT_GOAL := help

all: kind setup port_forward deploy test status ## Do all

kind:
	kind create cluster --config config/kind.yaml --wait 60s || true
	kind version

setup: ## Setup kinD with ArgoCD + Nginx Ingress
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=300s
	kubectl cluster-info
	scripts/argocd/up.sh
	scripts/ingress/up.sh

status: ## Status
	argocd version
	argocd --server $(SERVER) --insecure app list

sync deploy: login ## Deploy application and sync
	kubectl apply -f application.yaml
	argocd --server $(SERVER) --insecure app sync $(APP)
	argocd --server $(SERVER) --insecure app wait $(APP) infra bootstrap
	#argocd --server $(SERVER) --insecure app wait monitoring
	argocd --server $(SERVER) --insecure app get $(APP)

undeploy: login ## Deploy application and sync
	argocd --server $(SERVER) --insecure app delete -y $(APP)

port_forward: ## Port forward
	scripts/argocd/port_forward.sh &
	sleep 1

login: ## ArgoCD Login
	scripts/argocd/login.sh

test: ## Test app
	argocd --server $(SERVER) --insecure app wait $(APP) guestbook
	[ -f ./test.sh ] && ./test.sh guestbook.argocd.local

clean: ## Clean
	kind delete cluster

help:  ## Display this help menu
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: help clean test sync deploy login status kind all

-include include.mk
