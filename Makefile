SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: help up gc rebuild check

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## Update flake inputs
	@echo -e "\033[32mUpdating flake.lock...\033[0m"
	nix flake update --commit-lock-file

gc: ## Perform garbage collect all unused nix store entries
	@echo -e "\033[32mCollecting garbage...\033[0m"
	sudo nix-collect-garbage --delete-old

rebuild: ## Rebuild and switch current host
	@echo -e "\033[32mRebuilding current system...\033[0m"
	sudo nixos-rebuild switch

check: ## Check whether the flake evaluates and run its tests
	@echo -e "\033[32mChecking the flake...\033[0m"
	nix flake check --verbose
