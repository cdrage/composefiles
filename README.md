docker-compose files

Unless otherwise stated, simple run `docker-compose up` in each folder!

## Sensu Server

#### Introduction

A scaleable Sensu Server.


#### Requirements

Before deployment, generate the appropriate SSL certs with:
```sh
./gen-ssl.sh
```

This uses docker-compose v2 API which requires `docker 1.10+` and `docker-compose 1.6+`. Sensu server also uses the new libnetwork functionality of Docker.

#### Containers

__sensu:__ Sensu Server && Sensu API (for Uchiwa)

__redis:__ Redis database for Sensu

__rabbitmq:__ RabbitMQ database for Sensu Server && Clients

__uchiwa:__ Front-end UI for Sensu

#### Opened ports

__3000:__ Uchiwa UI

__15672:__ RabbitMQ management UI

__5671:__ RabbitMQ communication port

#### Files

In order to deploy sensu-clients, use the /ssl/client certs.

feel free to edit `sensu-checks.json` and `sensu.json` to your liking.


## Mail

#### Introduction

No more fiddling around with Zimbra. Extremely fast microservices in regards to mail. 
Original source: https://github.com/frankh/docker-compose-mailbox

#### Containers:
__mail:__
  - postfix - handle's sending and receiving email
  - dovecot - sorts incoming mail into IMAP mailboxes

__webserver:__
  - vimbadmin - web interface for creating/managing mailboxes
  - roundcube - web interface for checking a mailbox

__opendkim:__ Adds domainkey validation so that sent mails aren't flagged as spam

__spamassassin:__ Automatically filters spam for inboxes - learns based on what users mark as spam/not spam

__mysql:__ database for mail and webserver

__storagebackup:__ cron jobs for backup + list of volumes for backing up

#### Mail settings

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

#### Records

Create the appropriate A records / mx / txt for this.

