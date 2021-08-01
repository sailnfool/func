.PHONY: all scripts
.ONESHELL:
all: scripts
scripts:
	cd scripts
	make uninstall install
	cd ..
install:
	cd scripts
	make uninstall install clean
	cd ..
sinstall:
	cd scripts
	make suninstall sinstall clean
	cd ..
suninstall:
	cd scripts
	make suninstall clean
