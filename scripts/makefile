SHELL=/bin/bash
PREFIX?=$(HOME)
SPREFIX?=/usr/local
PREFIX2?=/tftpboot/global/rnovak
.sh:
	@rm -f $@
	cp $< $@
INSTALL =       func.arithmetic \
		func.config \
		func.cwave \
		func.debug \
		func.doshells \
		func.env \
		func.errecho \
		func.getprojdir \
		func.hmsout \
		func.insufficient \
		func.kbytes \
		func.locker \
		func.logger \
		func.nice2num \
		func.onefilehash \
		func.onefilereformat \
		func.os \
		func.pathmunge \
		func.random \
		func.regex \
		func.toseconds \
		func.uuid \
		zfunc.zfsparent \
		zfunc.results \
		find_sim \
		getb2sum \
		getgitroot \
		histogram \
		mypr \
		nowinUCT \
		pinger \
		pinger2 \
		proj_setup \
		pathmunge \
		sourcedate \
		uuid
#		func.kkbytes \
#		func.kerrecho \
#		func.knice2num \
#		func.kinsufficient \

EXECDIR := $(PREFIX)/bin
EXECDIR2 := $(PREFIX2)/bin
SEXECDIR := $(SPREFIX)/sbin


.PHONY: clean uninstall all
all: $(INSTALL)
install: $(INSTALL)
	mkdir -p $(EXECDIR)
	install -o $(USER) -C $? $(EXECDIR)
	rm -f $?
sinstall: $(INSTALL)
	mkdir -p $(SEXECDIR)
	install -o root -C $? $(SEXECDIR)
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
suninstall: 
	@for execfile in $(INSTALL); do \
		echo rm -f $(SEXECDIR)/$$execfile; \
		rm -f $(SEXECDIR)/$$execfile; \
	done
jetinstall: $(INSTALL)
	mkdir -p $(EXECDIR2)
	install -o $(USER) -c $? $(EXECDIR2)
$(EXECDIR):
	mkdir -p $(EXECDIR)
$(SEXECDIR):
	mkdir -p $(SEXECDIR)
$(EXECDIR2):
	mkdir -p $(EXECDIR2)
