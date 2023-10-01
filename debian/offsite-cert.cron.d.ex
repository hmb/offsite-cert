#
# Regular cron jobs for the offsite-cert package
#
0 4	* * *	root	[ -x /usr/bin/offsite-cert_maintenance ] && /usr/bin/offsite-cert_maintenance
