SHELL=/bin/bash
LPREFIX=$(HOME)/.local
.sh:
	@rm -f $@
	cp $< $@
LINSTALL =       func.arithmetic \
		func.cwave \
		func.dec2hex \
		func.debug \
		func.doshells \
		func.env \
		func.errecho \
		func.getprojdir \
		func.hex2binfile \
		func.hex2dec \
		func.hmsout \
		func.insufficient \
		func.kbytes \
		func.locker \
		func.logger \
		func.nice2num \
		func.num2nice \
		func.onefilehash \
		func.onefilereformat \
		func.os \
		func.pathmunge \
		func.random \
		func.regex \
		func.toseconds \
		func.uuid \
		hash.askcreatecanonical \
		hash.globalcanonical \
		hash.loadcanonical \
		zfunc.zfsparent \
		zfunc.results
#		func.kkbytes \
#		func.kerrecho \
#		func.knice2num \
#		func.kinsufficient \

LEXECDIR := $(LPREFIX)/bin


.PHONY: clean uninstall all
all: $(LINSTALL)
linstall: $(LINSTALL)
	mkdir -p $(LEXECDIR)
	install -o $(USER) -C $? $(LEXECDIR)
	rm -f $?
clean: 
	@for execfile in $(LINSTALL); do \
		echo rm -f $$execfile; \
		rm -f $$execfile; \
	done
uninstall: 
	@for execfile in $(LINSTALL); do \
		echo rm -f $(EXECDIR)/$$execfile; \
		rm -f $(EXECDIR)/$$execfile; \
	done
