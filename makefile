.PHONY: all scripts
.ONESHELL:
all: scripts
scripts:
	cd scripts
	make uninstall install clean
	cd ..
install:
	cd scripts
	make uninstall install clean
	cd ..
jetinstall:
	cd scripts
	make jetinstall clean
	cd ..
