# Docker Compose Files

Unless otherwise stated, simple run `docker-compose up` in each folder!

All compose files use `version: '2'` of the API, so this requires: `docker 1.10+` and `docker-compose 1.6+`.

## Sensu Server

Monitoring server

#### Requirements

Before deployment, generate the appropriate SSL certs with:
```sh
./gen-ssl.sh
```

#### Files

In order to deploy sensu-clients, use the /ssl/client certs.

feel free to edit `sensu-checks.json` and `sensu.json` to your liking.

## PowerDNS

PowerDNS server and poweradmin interface


