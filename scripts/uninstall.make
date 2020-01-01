.PHONY: clean
clean: 
	@for execfile in $(INSTALL); do \
		echo rm -f $$execfile; \
		rm -f $$execfile; \
	done
.PHONY: uninstall
uninstall: 
	@for execfile in $(INSTALL); do \
		echo sudo rm -f $(EXECDIR)/$$execfile; \
		sudo rm -f $(EXECDIR)/$$execfile; \
	done
