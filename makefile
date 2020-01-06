.PHONY: all scripts
.ONESHELL:
all: scripts
scripts:
	cd scripts
	make install clean
	cd ..

