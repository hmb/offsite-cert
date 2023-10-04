# Offsite-Cert

Offsite-cert is used to download certificates from public internet sites for use
on private intranet sites.

Sometimes a LetsEncrypt certificate is desired to be deployed in a private
environment, like an office or home use for servers that are not publicly
reachable. Due to the private nature of the server, LetsEncrypt cannot validate
the domain using the `well-known` file mechanism. In cases where DNS validation
is not an option offsite-cert could be helpful.

## Operation

The offsite-cert program downloads the LetsEncrypt certificate from a publicly
reachable server. The public server itself may just use one of the standard ways
of retrieving a LetsEncrypt certificate. Offsite-cert extracts the certificate
from the SSL communication. It does not need any special access, like e.g. `ssh`
to the public server. Invoked on a daily basis via cron, it syncs the ssl
certificate from the public server to the internal one within the renewal
timeframe of the LetsEncrypt certificate expiration period.

## Setup

### Installation

The program comes as tarball and as debian package. On a debian system it can
simply be installed by downloading the latest version of
the `offsite-cert_1.0.0-1_all.deb` file and invoking:

````
sudo apt install ./offsite-cert_1.0.0-1_all.deb
````

Mind the `./` prefix to tell apt to install a file instead of a peculiar named
debian package.

To install the tarball the standard way can be used:

````
tar xf offsite-cert_1.0.0.tgz
cd offsite-cert_1.0.0/
make
sudo make install
````

While the debian package installs a cron job and the manpage, the `Makefile`
installer just installs the binary and configuration files. For simplicity no
complex configuration detection is implemented of where to install the manpage
and the cronjob. This is left as exercise to the admin.

### Package Configuration

After installation only the domains to be synced need configuring. They reside
in the `/etc/offsite-cert/domains` file. The format of that file is described in
the file itself:

````
# This is the offsite-cert domain configuration file
#
# Empty lines, lines containing whitespace only and lines starting with a '#'
# as first non-whitespace are ignored. All other lines shall have 3 space or
# tab separated records containing:
#
# <server:port> <target domain> <destination file>
#
# <server:port>     is the server to connect to. This server usually is a
#                   webserver that serves the target domain.
# <target domain>   is the domain whose certificate is to be retrieved. In many
#                   cases that will be the same as the server in <server:port>.
#                   In case the <server> serves the <target domain>, but the
#                   <target domain>s IP is different from the <server>s IP,
#                   offsite-cert will contact the <server>s IP but still get the
#                   certificate of the <target domain>.
# <destination file> is the file location where the downloaded certificate is
#                   copied to. The certificate will only be copied, if it either
#                   is not present at the destination or its content has
#                   changed.
#
# Examples:
# example.com:443   example.com         /etc/nginx/ssl.cer/example.com.crt
# example.com:443   www.example.com     /etc/nginx/ssl.cer/www.example.com.crt
````

The destination file record is the location where offsite-cert puts the
downloaded certificate file. It only copies the new certificate, if it is
different to the existing one, most probably because it has changed since the
last invocation.

### Server Configuration

To get an internal server using the certificate it has to be configured to use
the file at the same location as configured in `offsite-cert`. Of course the
server also needs the private key matching the certificate. The private key file
has to be copied from the public server to the internal server. Currently, this
step has to be done manually. Care has to be taken, that the private key is not
compromised during transfer. A preferred method is to copy it using `ssh`
or `scp`. The file permissions then have to be restricted to the owner:

````
scp example.com:/path/to/private.key /etc/nginx/ssl.key/www.example.com.key
chmod 600 /etc/nginx/ssl.key/www.example.com.key
````

The matching sample configuration of `nginx` could be something like this:

````
server
{
   listen 443;
   server_name www.example.com;
   root /var/www/;
   
   ssl on;
   ssl_certificate /etc/nginx/ssl.cer/www.example.com.crt;
   ssl_certificate_key /etc/nginx/ssl.key/www.example.com.key;
   ...
}
````

This configuration step has to be done once only. Of course the public server's
acme agent has to be configured to keep the certificate's private key during
certificate renewal. Not all agents do that in their default configuration.

An alternative approach would be that `offsite-cert` retrieves both, the private
key and the certificate. That would need a secure method to automate key
transferal, which is possibly more insecure than a onetime step carried out by
an experienced admin. It either needs root access of the internal server to the
public one or have a private key on the public server that's readable by some
other non-root user. Anyway it's not implemented in the current version.

### Server Restart

As this package is mainly targeted to debian system the restart of the internal
server is usually carried out by logrotate.

## Future Features

Some features might be nice to have for future enhancements:

- Error messaging (e.g. via mail)
- Verification that the downloaded certificate works
- Logging
- Hooks that get called on successful certificate update or on failure
- Server restart, if at least one certificate has been updated
- Retrieval of the private key from the public server

Any help is welcome.
