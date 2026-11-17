.PHONY: setup init-git-config init-submodules apply-overlays list-targets

setup: init-git-config init-submodules

init-git-config:
	@# Local-only safety defaults for this clone. Idempotent.
	git config submodule.recurse false
	git config fetch.recurseSubmodules on-demand
	git config status.submoduleSummary true
	git config diff.submodule log
	git config push.recurseSubmodules check
	@echo "Local git submodule-safety config applied."

# Partial clone: trees and commits only. Blobs are fetched on demand.
# GitLab and the larger Rails apps are otherwise multi-gigabyte checkouts.
init-submodules:
	git submodule update --init --filter=blob:none
	$(MAKE) apply-overlays

apply-overlays:
	@ruby tool/apply-overlays.rb

list-targets:
	@git config -f .gitmodules --get-regexp '^submodule\..*\.path$$' | awk '{print $$2}' | sort
