# Makefile to compile looktxt.
# Required: gcc
# Optional: HDF5/NeXus library. get it at 
#
# just type: make

ifeq ($(NEXUS_NAPI),)
  NEXUS_NAPI = $(shell [ -f /usr/include/napi.h ] && echo -DUSE_NEXUS -lNeXus || echo "");
endif

# simple one-shot compile
all:	
	${CC} -O2 -o looktxt -g looktxt.c $(NEXUS_NAPI)

clean: 
	rm -f *.o looktxt

install:
	install -D looktxt \
		$(DESTDIR)$(prefix)/usr/bin/looktxt

distclean: clean

test:
	./looktxt --version
	./looktxt --verbose --test examples/* 
	@echo Test OK

uninstall:
	-rm -f $(DESTDIR)$(prefix)/usr/bin/looktxt

.PHONY: all install clean distclean uninstall test

