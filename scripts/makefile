SHELL=/bin/bash
.sh:
	@rm -f $@
	cp $< $@
INSTALL = func.config func.cwave func.doshells \
		  func.env func.errecho func.genrange \
		  func.getprojdir func.insufficient \
		  func.onefilehash func.onefilereformat \
		  func.pathmunge \
			proj_setup mypr pinger find_sim \
			getb2sum pathmunge nowinUCT sourcedate getgitroot

PROJECT := func
EXECDIR := $(HOME)/bin

.PHONY: clean uninstall all
all: $(INSTALL)
install: $(INSTALL)
	mkdir -p $(EXECDIR)
	install -g $(PROJECT) -o $(USER) -C $? $(EXECDIR)
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
project:
	proj_setup $(PROJECT)
$(EXECDIR):
	mkdir -p $(EXECDIR)

