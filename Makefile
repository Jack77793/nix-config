SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

ROOTDIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

ifneq ($(filter $(firstword $(MAKECMDGOALS)), buildpkg rebuild),)
    RUNARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
    $(eval $(RUNARGS):;@:)
endif

.PHONY: all buildpkg check gc help livecd nvcheck rebuild runiso up

all: help

buildpkg: ## Build specified custom package
	@echo -e "\033[32mBuilding the package $(RUNARGS)...\033[0m"
	nix-build -E 'with import <nixpkgs> {}; callPackage $(ROOTDIR)/pkgs/$(RUNARGS) {}'

check: ## Check whether the flake evaluates and run its tests
	@echo -e "\033[32mChecking the flake...\033[0m"
	nix flake check --verbose $(ROOTDIR)

gc: ## Perform garbage collect all unused nix store entries
	@echo -e "\033[32mCollecting garbage...\033[0m"
	sudo nix-collect-garbage --delete-old

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

livecd: ## Build the livecd 'Akashi'
	@echo -e "\033[32mBuilding the iso image...\033[0m"
	nix build $(ROOTDIR)#nixosConfigurations.Akashi.config.system.build.isoImage

nvcheck: ## Run nvchecker for custom packages
	@echo -e "\033[32mRunning nvchecker...\033[0m"
	nix run nixpkgs#nvchecker -- -c nvchecker -c $(ROOTDIR)/pkgs/pkgs.toml

rebuild: ## Rebuild current host
	@echo -e "\033[32mRebuilding current system...\033[0m"
	sudo nixos-rebuild $(if $(RUNARGS),$(RUNARGS),switch) --flake $(ROOTDIR)

runiso: ## Run the built iso image
	@echo -e "\033[32mRunning the iso image...\033[0m"
	nix run nixpkgs#qemu_kvm -- -enable-kvm -m 2G -smp $$(nproc) -vga virtio -display sdl -nic user,hostfwd=tcp::2222-:22 -cdrom $(ROOTDIR)/result/iso/nixos-*.iso

up: ## Update flake inputs
	@echo -e "\033[32mUpdating flake.lock...\033[0m"
	nix flake update --flake $(ROOTDIR) --commit-lock-file
