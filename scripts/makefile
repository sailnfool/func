SHELL=/bin/bash
PREFIX?=$(HOME)
LPREFIX=$(HOME)/.local
.sh:
	@rm -f $@
	cp $< $@
LINSTALL =       func.arithmetic \
		func.config \
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
INSTALL =		countfiles \
		hashcreatecanonical \
		dohashes \
		find_sim \
		getgitroot \
		histogram \
		mypr \
		mysourcedate \
		nowinUCT \
		pinger \
		pinger2 \
		proj_setup \
		pathmunge \
		uuid
#		func.kkbytes \
#		func.kerrecho \
#		func.knice2num \
#		func.kinsufficient \

EXECDIR := $(PREFIX)/bin
LEXECDIR := $(LPREFIX)/bin


.PHONY: clean uninstall all
all: $(LINSTALL) $(INSTALL)
install: $(INSTALL)
	mkdir -p $(EXECDIR)
	install -o $(USER) -C $? $(EXECDIR)
	rm -f $?
linstall: $(LINSTALL)
	mkdir -p $(LEXECDIR)
	install -o $(USER) -C $? $(LEXECDIR)
	rm -f $?
clean: 
	@for execfile in $(INSTALL); do \
		echo rm -f $$execfile; \
		rm -f $$execfile; \
	done
uninstall: 
	@for execfile in $(INSTALL); do \
		echo rm -f $(EXECDIR)/$$execfile; \
		rm -f $(EXECDIR)/$$execfile; \
	done
$(EXECDIR):
	mkdir -p $(EXECDIR)
