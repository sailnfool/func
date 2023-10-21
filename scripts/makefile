SHELL=/bin/bash
LPREFIX=$(HOME)/.local
.sh:
	@rm -f $@
	cp $< $@
LINSTALL =      func.hmsout \
		func.kbytes \
		func.onefilereformat \
		func.pathmunge \
		func.random \
		func.toseconds \
		func.uuid \
		hash.askcreatecanonical \
		hash.globalcanonical \
		hash.loadcanonical \
		zfunc.zfsparent \
		zfunc.results
#		func.errecho \
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
