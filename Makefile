# Makefile to compile looktxt.
# just type: make

# simple one-shot compile
all:	
	${CC} -O3 -o looktxt -g looktxt.c

clean: 
	rm -f *.o looktxt

install:
	install -D looktxt \
		$(DESTDIR)$(prefix)/usr/bin/looktxt

distclean: clean

uninstall:
	-rm -f $(DESTDIR)$(prefix)/usr/bin/looktxt

.PHONY: all install clean distclean uninstall

