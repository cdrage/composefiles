Docker compose files yo.

## Mail

### Introduction
No more fiddling around with Zimbra. Extremely fast microservices in regards to mail. 
Original source: https://github.com/frankh/docker-compose-mailbox

### Containers
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

### Setup

Email settings:

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

### Records

Create the appropriate A records / mx / txt for this.
