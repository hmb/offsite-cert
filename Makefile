all:
	@echo "possible targets: install, clean"

install:
	install -d $(DESTDIR)/usr/bin/
	install -m 755 src/offsite-cert $(DESTDIR)/usr/bin/
#	install -d $(DESTDIR)/var/lib/offsite-cert/
	install -d $(DESTDIR)/etc/offsite-cert/
	install -m 640 conf/offsite-cert.conf $(DESTDIR)/etc/offsite-cert/

clean:
	@echo "scripting only, nothing to do"

.PHONY: all install clean
