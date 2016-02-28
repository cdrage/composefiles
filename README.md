docker-compose files

Unless otherwise stated, simple run `docker-compose up` in each folder!

## Sensu-server

__Introduction__

A scaleable Sensu Server.


__Requirements__
Before deployment, generate the appropriate SSL certs with:
```sh
./gen-ssl.sh
```

This uses docker-compose v2 API which requires `docker 1.10+` and `docker-compose 1.6+`. Sensu server also uses the new libnetwork functionality of Docker.

__Containers__
sensu:
  Sensu Server as well as Uchiwa (front-end UI) running with supervisord

redis:
  Redis database for Sensu

rabbitmq:
  RabbitMQ database for Sensu
  15672 port is also opened for rabbitmq management
  5671 port opened for sensu client connection

__Files__
In order to deploy sensu-clients, use the /ssl/client certs.

# Mail

__Introduction__
No more fiddling around with Zimbra. Extremely fast microservices in regards to mail. 
Original source: https://github.com/frankh/docker-compose-mailbox

__Containers__
mail:
  postfix - handle's sending and receiving email
  dovecot - sorts incoming mail into IMAP mailboxes

webserver:
  vimbadmin - web interface for creating/managing mailboxes
  roundcube - web interface for checking a mailbox

opendkim:
  Adds domainkey validation so that sent mails aren't flagged as spam

spamassassin:
  Automatically filters spam for inboxes - learns based on what users mark as spam/not spam

mysql:
  database for mail and webserver

storagebackup:
  cron jobs for backup + list of volumes for backing up

__Email settings__

SMTP:
mail.domain.com
587
TLS

POP3:
mail.domain.com
995
SSL

IMAP:
mail.domain.com
993
SSL

__Records__

Create the appropriate A records / mx / txt for this.

