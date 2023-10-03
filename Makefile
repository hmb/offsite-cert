build:
	mkdir -p build
	sed -e '/^[[:blank:]]*$$/d;$$a\' doc/offsite-cert.man > build/offsite-cert.man

install:
	install -d $(DESTDIR)/etc/offsite-cert/
	install -m 640 conf/offsite-cert.conf $(DESTDIR)/etc/offsite-cert/
	install -m 640 conf/domains $(DESTDIR)/etc/offsite-cert/
	install -d $(DESTDIR)/usr/bin/
	install -m 755 src/offsite-cert $(DESTDIR)/usr/bin/
#	install -d $(DESTDIR)/var/lib/offsite-cert/

clean:
	rm -rf build

.PHONY: all install clean
