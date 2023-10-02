#
# Offsite certificate renewal
#
# Copyright © 2023 Holger Böhnke <offsite-cert@biz.amarin.de>
# distributed under the terms of the AGPL v3
#

# set the mail address this cronjob mails to
#MAILTO=offsite-cert@example.com

# download the certificates to check for new releases once per day
# m h dom mon dow user      command
31  2 *   *   *   root      [ -x /usr/bin/offsite-cert ] && /usr/bin/offsite-cert
