SHELL=/bin/bash
PREFIX?=$(HOME)
PREFIX2?=/tftpboot/global/novak5
.sh:
	@rm -f $@
	cp $< $@
INSTALL = func.arithmetic func.config func.cwave func.doshells \
		func.env func.errecho \
		func.getprojdir func.hmsout func.insufficient \
		func.onefilehash func.onefilereformat \
		func.pathmunge func.random func.debug \
		proj_setup mypr pinger find_sim \
		getb2sum pathmunge nowinUCT sourcedate getgitroot \
		histogram func.nice2num \
		func.kbytes \
		func.kkbytes func.kerrecho \
		func.knice2num func.kinsufficient \
		zfunc.zfsparent zfunc.results

EXECDIR := $(PREFIX)/bin
EXECDIR2 := $(PREFIX2)/bin

.PHONY: clean uninstall all
all: $(INSTALL)
install: $(INSTALL)
	mkdir -p $(EXECDIR)
	install -o $(USER) -C $? $(EXECDIR)
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
jetinstall: $(INSTALL)
	mkdir -p $(EXECDIR2)
	install -o $(USER) -c $? $(EXECDIR2)
$(EXECDIR):
	mkdir -p $(EXECDIR)
$(EXECDIR2):
	mkdir -p $(EXECDIR2)
