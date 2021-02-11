https://computingforgeeks.com/how-to-install-postgresql-12-on-fedora/

```
su - postgres
psql
create user wikijs with encrypted password 'wikijsrocks';
create user wikijs with password 'wikijsrocks';
alter user wikijs with password 'wikijsrocks';

create database wiki;
grant all privileges on database wiki to wikijs;


CREATE USER wikijs WITH PASSWORD 'wikijsrocks';
```


## Cant connect
https://kb.objectrocket.com/postgresql/how-to-use-the-postgres-create-user-command-1449
edit:
```
sudo vim /var/lib/pgsql/12/data/pg_hba.conf
```
modify:
```
local	all	all	trust
host	all	127.0.0.1/32	trust
```

```
systemctl restart postgresql-12.service
```