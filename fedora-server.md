
# prompt color
Value	Color
0	Black
1	Red
2	Green
3	Yellow
4	Blue
5	Magenta
6	Cyan
7	White
8	Not used
9	Reset to default color
```bash
export PS1="\[$(tput setaf 2)$(tput bold)\][\u@\h \W]$ \[$(tput sgr0)\]"
```

# prevent sleep lid closed
```bash
vim /etc/systemd/logind.conf
```

```
HandleLidSwitch=ignore
```

```bash
systemctl restart systemd-logind
```

# static ip address
```bash
# nmcli c
NAME      UUID                                  TYPE      DEVICE 
enp2s0    7a096dc9-e1d8-3c86-959d-5368b93d8657  ethernet  enp2s0 
ethernet  eeb2afbb-a5a8-44a3-a10f-c2caa6ecb616  ethernet  --  
```

```bash
nmcli c edit 7a096dc9-e1d8-3c86-959d-5368b93d8657
```

```
nmcli> set ipv4.addresses 192.168.2.100/24
Do you also want to set 'ipv4.method' to 'manual'? [yes]: yes

nmcli> set ipv4.gateway 192.168.2.1

nmcli> save
Saving the connection with 'autoconnect=yes'. That might result in an immediate activation of the connection.
Do you still want to save? [yes] yes
nmcli> quit
```

restart interface
```
nmcli device disconnect enp2s0; wait ; nmcli device connect enp2s0
```

# nextcloud
https://www.howtoforge.com/how-to-install-and-configure-nextcloud-on-fedora-32/

## Prerequisites
```bash
dnf update
dnf install wget curl bzip2 nano unzip policycoreutils-python-utils -y
```

## Configure Firewall
Check if the firewall is running. Check the current allowed services/ports.
```bash
firewall-cmd --state
firewall-cmd --permanent --list-services
```

Allow HTTP and HTTPS ports.
```bash
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
```

## Install PHP
```bash
dnf install php-fpm php-cli php-gd php-mbstring php-intl php-mysqlnd php-imagick php-zip php-json php-process php-xml php-bcmath php-gmp php-ftp php-smbclient php-opcache php-ldap
dnf install php-pgsql 
```

check version:
```bash
php --version
```

## Configure PHP
Open the file /etc/php-fpm.d/www.conf.
```bash
vim /etc/php-fpm.d/www.conf
```

We need to set the Unix user/group of PHP processes to `nginx`. Find the user=apache and group=apache lines in the file and change them to nginx.
```
...
; Unix user/group of processes
; Note: The user is mandatory. If the group is not set, the default user's group
;       will be used.
; RPM: apache user chosen to provide access to the same directories as httpd
user = nginx
; RPM: Keep a group allowed to write in log dir.
group = nginx
...
```
Uncomment the PHP environment variables below.
```
env[HOSTNAME] = $HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp
```

Uncomment the opcache configuration on the last line.
```
php_value[opcache.file_cache] = /var/lib/php/opcache
```

Now edit the PHP opcache configuration /etc/php.d/10-opcache.ini.
```bash
vim /etc/php.d/10-opcache.ini
```

Change the configuration as below.
```
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=1
opcache.save_comments=1
```

Run the following commands to increase the File upload and Memory limits for PHP.
```bash
cp /etc/php.ini /etc/php.ini.bak
vim /etc/php.ini
```

```
memory_limit = 1024M
post_max_size = 32G
upload_max_filesize = 32G
```

By default, there are 3 files in /var/lib/php/ directory whose group owner are set to apache, but we are using Nginx. So we need to give the nginx user permissions to read and write to the 3 directories with setfacl.

```bash
setfacl -R -m u:nginx:rwx /var/lib/php/opcache/
setfacl -R -m u:nginx:rwx /var/lib/php/session/
setfacl -R -m u:nginx:rwx /var/lib/php/wsdlcache/
```

Enable and start the php-fpm process.
```bash
systemctl enable --now php-fpm
```

## Install Nginx
```bash
dnf install nginx -y
```

Start and enable Nginx.
```bash
systemctl enable --now nginx
```

## PostgreSQL install
https://fedoraproject.org/wiki/PostgreSQL
```bash
dnf install postgresql-server postgresql-contrib
```

Enable and start postgres it will fail
```bash
systemctl enable --now postgresql
```

```bash
# journalctl -xn
-- Journal begins at Thu 2021-04-08 21:18:47 CEST, ends at Fri 2021-04-09 20:34:38 CEST. --
Apr 09 20:34:38 fedora audit: BPF prog-id=323 op=LOAD
Apr 09 20:34:38 fedora systemd[1]: Starting PostgreSQL database server...
░░ Subject: A start job for unit postgresql.service has begun execution
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ A start job for unit postgresql.service has begun execution.
░░ 
░░ The job identifier is 4981.
Apr 09 20:34:38 fedora postgresql-check-db-dir[44080]: Directory "/var/lib/pgsql/data" is missing or empty.
Apr 09 20:34:38 fedora postgresql-check-db-dir[44080]: Use "/usr/bin/postgresql-setup --initdb"
Apr 09 20:34:38 fedora postgresql-check-db-dir[44080]: to initialize the database cluster.
Apr 09 20:34:38 fedora postgresql-check-db-dir[44080]: See /usr/share/doc/postgresql/README.rpm-dist for more information.
Apr 09 20:34:38 fedora systemd[1]: postgresql.service: Control process exited, code=exited, status=1/FAILURE
░░ Subject: Unit process exited
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ An ExecStartPre= process belonging to unit postgresql.service has exited.
░░ 
░░ The process' exit code is 'exited' and its exit status is 1.
Apr 09 20:34:38 fedora systemd[1]: postgresql.service: Failed with result 'exit-code'.
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ The unit postgresql.service has entered the 'failed' state with result 'exit-code'.
Apr 09 20:34:38 fedora systemd[1]: Failed to start PostgreSQL database server.
░░ Subject: A start job for unit postgresql.service has failed
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ A start job for unit postgresql.service has finished with a failure.
░░ 
░░ The job identifier is 4981 and the job result is failed.
```

The database initialization could be done using following command. It creates the configuration files postgresql.conf and pg_hba.conf
```bash
postgresql-setup --initdb --unit postgresql
```

```bash
systemctl restart postgresql
```

### Tips and tricks
For database management is comfortable to use graphical tools such as phpPgAdmin or pgadmin3.

```bash
#dnf install phpPgAdmin
dnf install pgadmin3
```
### Firewall
PostgreSQL operates on port 5432 (or whatever else you set in your postgresql.conf). In firewalld you can open it like this:

Rule to make it last after reboot:
```bash
firewall-cmd --permanent --add-port=5432/tcp
firewall-cmd --add-port=5432/tcp
firewall-cmd --reload
firewall-cmd --list-ports
```

### User Creation and Database Creation
https://docs.nextcloud.com/server/latest/admin_manual/configuration_database/linux_database_configuration.html
```bash
# su - postgres
```

and then run postgre's interactive shell:
```
$ psql
psql (9.3.2)
Type "help" for help.

postgres=#
```

create user
```
DROP DATABASE nextcloud;
CREATE USER nextuser WITH PASSWORD 'HzPZCReRSxauVJtbjQjHkvp72gx2URL5';
CREATE DATABASE nextcloud TEMPLATE template0 ENCODING 'UNICODE';
ALTER DATABASE nextcloud OWNER TO nextuser;
GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextuser;
```

### Configuration
The postgresql server is using two main configuration files

- /var/lib/pgsql/data/postgresql.conf
- /var/lib/pgsql/data/pg_hba.conf


#### pg_hba.conf
after modification it should look like this:
```
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
```

## Download nextcloud
```bash
cd /var/www/html
wget https://download.nextcloud.com/server/releases/latest.tar.bz2
tar -jxvf latest.tar.bz2
```

```bash
mkdir /var/www/html/nextcloud/data
chown -R nginx:nginx /var/www/html/nextcloud
sudo chmod -R 0770 /var/www/html/nextcloud

```

## Configure Nginx for Nextcloud
```bash
mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled
vim /etc/nginx/nginx.conf
```

Paste the following lines after the line include /etc/nginx/conf.d/*.conf
```
include /etc/nginx/sites-enabled/*.conf;
server_names_hash_bucket_size 64;
```

Create the file /etc/nginx/sites-available/nextcloud.conf
```bash
vim /etc/nginx/sites-available/nextcloud.conf
```

```
upstream php-handler {
    server  unix:/run/php-fpm/www.sock;
}

server {
    #listen 443 ssl;
    listen 80;
    server_name 192.168.2.100;

    #ssl_certificate /etc/ssl/nginx/cloud.example.com.crt;
    #ssl_certificate_key /etc/ssl/nginx/cloud.example.com.key;

    # Add headers to serve security related headers
    # Before enabling Strict-Transport-Security headers please read into this
    # topic first.
    # add_header Strict-Transport-Security "max-age=15768000;
    # includeSubDomains; preload;";
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;

    # Path to the root of your installation
    root /var/www/html/nextcloud/;

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # The following 2 rules are only needed for the user_webfinger app.
    # Uncomment it if you're planning to use this app.
    #rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
    #rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json
    # last;

    location = /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }
    location = /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }

    # set max upload size
    client_max_body_size 512M;
    fastcgi_buffers 64 4K;

    # Disable gzip to avoid the removal of the ETag header
    gzip off;

    # Uncomment if your server is build with the ngx_pagespeed module
    # This module is currently not supported.
    #pagespeed off;

    error_page 403 /core/templates/403.php;
    error_page 404 /core/templates/404.php;

    location / {
        rewrite ^ /index.php$uri;
    }

    location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
        deny all;
    }
    location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
        deny all;
    }

    location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|core/templates/40[34])\.php(?:$|/) {
        include fastcgi_params;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        #fastcgi_param HTTPS on;
        #Avoid sending the security headers twice
        fastcgi_param modHeadersAvailable true;
        fastcgi_param front_controller_active true;
        fastcgi_pass php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off;
    }

    location ~ ^/(?:updater|ocs-provider)(?:$|/) {
        try_files $uri/ =404;
        index index.php;
    }

    # Adding the cache control header for js and css files
    # Make sure it is BELOW the PHP block
    location ~* \.(?:css|js)$ {
        try_files $uri /index.php$uri$is_args$args;
        add_header Cache-Control "public, max-age=7200";
        # Add headers to serve security related headers (It is intended to
        # have those duplicated to the ones above)
        # Before enabling Strict-Transport-Security headers please read into
        # this topic first.
        # add_header Strict-Transport-Security "max-age=15768000;
        #  includeSubDomains; preload;";
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag none;
        add_header X-Download-Options noopen;
        add_header X-Permitted-Cross-Domain-Policies none;
        # Optional: Don't log access to assets
        access_log off;
    }

    location ~* \.(?:svg|gif|png|html|ttf|woff|ico|jpg|jpeg)$ {
        try_files $uri /index.php$uri$is_args$args;
        # Optional: Don't log access to other assets
        access_log off;
    }
}

```

Activate this configuration file by linking it to the sites-enabled directory.
```bash
ln -s /etc/nginx/sites-available/nextcloud.conf /etc/nginx/sites-enabled/
```

Test the Nginx configuration.
```bash
nginx -t
```

Reload the Nginx service if everything is okay.
```bash
systemctl reload nginx
```

### Config nextcloud
```bash
cd /var/www/html/nextcloud
```

```
sudo -u nginx php occ  maintenance:install --database "pgsql" --database-name "nextcloud"  --database-user "nextuser" --database-pass "<db password here>" --admin-user "username" --admin-pass "<admin password here>"
```

```bash
vim /var/www/html/nextcloud/config/config.php
```

add trusted domains:
```
'trusted_domains' =>
  array (
          0 => 'localhost',
          1 => '192.168.2.100',
          2 => '10.0.0.2'
  ),
```

## Backup script
```bash
sudo su
cd /root/
vim backup.sh
```

paste:
```
rsync -Aavx /var/www/html/nextcloud/ /mnt/storage1/nextcloud_backups/nextcloud-dirbkp_`date +"%Y%m%d"`/
```

## Issues
## Internal Server error
- check permissions
- check selinux policy



## Cant log in 
```bash
chown nginx:nginx /var/lib/php/session/
chown root:nginx /var/lib/php/wsdlcache/
chown root:nginx /var/lib/php/opcache/
```

## Cant login reverse proxy on mobile
in `config.php`
add
`'overwriteprotocol' => 'https',`

```
<?php
$CONFIG = array (
  'instanceid' => 'ocaatrk6yk2d',
  'passwordsalt' => '<password salt>',
  'secret' => '<secret here>',
  'trusted_domains' => 
  array (
    0 => '192.168.2.100',
    1 => '10.0.0.2',
    2 => 'nextcloud.wielgosz.pro',
  ),
  'datadirectory' => '/var/www/html/nextcloud/data',
  'dbtype' => 'pgsql',
  'version' => '21.0.1.1',
  'overwrite.cli.url' => 'http://192.168.2.100',
  'dbname' => 'nextcloud',
  'dbhost' => 'localhost',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'dbuser' => 'nextuser',
  'dbpassword' => '<db password here>',
  'installed' => true,
  'maintenance' => false,
  'overwriteprotocol' => 'https',
);

```

# Wireguard
```bash
sudo dnf install wireguard-tools
sudo su -
cd /etc/wireguard
wg genkey | tee privatekey | wg pubkey > publickey
```

```bash
vim wg0.conf
```

```
[Interface]
Address = 10.0.0.2/32
PrivateKey = <privatekey>
ListenPort = 51820

#Registry
[Peer]
PublicKey = <publickey>
Endpoint = wielgosz.pro:51820
PersistentKeepalive = 5
AllowedIPs = 10.0.0.1/24
```

hot reload
```bash
wg syncconf wg0 <(wg-quick strip wg0)
```

modify service to auto restart
```bash
vim /usr/lib/systemd/system/wg-quick@.service
```

```
[Unit]
Description=WireGuard via wg-quick(8) for %I
After=network-online.target nss-lookup.target
Wants=network-online.target nss-lookup.target
PartOf=wg-quick.target
Documentation=man:wg-quick(8)
Documentation=man:wg(8)
Documentation=https://www.wireguard.com/
Documentation=https://www.wireguard.com/quickstart/
Documentation=https://git.zx2c4.com/wireguard-tools/about/src/man/wg-quick.8
Documentation=https://git.zx2c4.com/wireguard-tools/about/src/man/wg.8

[Service]
#Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/wg-quick up %i
ExecStop=/usr/bin/wg-quick down %i
ExecReload=/bin/bash -c 'exec /usr/bin/wg syncconf %i <(exec /usr/bin/wg-quick strip %i)'
Environment=WG_ENDPOINT_RESOLUTION_RETRIES=infinity
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target

```