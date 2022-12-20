MAKEFLAGS += --silent

SERVER := 127.0.0.1:8080

APP ?= demo

.DEFAULT_GOAL := help

all: kind setup port_forward test status ## Do all

kind:
	kind create cluster --config config/kind.yaml --wait 60s || true

setup: ## Setup kinD with ArgoCD + Nginx Ingress
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=300s
	kubectl cluster-info
	scripts/argocd/up.sh
	scripts/ingress/up.sh

status: ## Status
	argocd --server $(SERVER) --insecure app list

sync: login ## Deploy application and sync
	kubectl apply -f $(APP)/application.yaml
	argocd --server $(SERVER) --insecure app sync $(APP)
	argocd --server $(SERVER) --insecure app wait $(APP)

port_forward: ## Port forward
	scripts/argocd/port_forward.sh &
	sleep 1

login: ## ArgoCD Login
	scripts/argocd/login.sh

test: sync ## Test app
	[ -f ./tests/test.sh ] && ./tests/test.sh $(APP)

clean: ## Clean
	kind delete cluster

help:  ## Display this help menu
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: help clean test sync login status kind all

-include include.mk
