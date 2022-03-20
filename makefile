.PHONY: all scripts
.ONESHELL:
all: scripts
scripts:
	cd scripts
	make uninstall linstall install
	cd ..
