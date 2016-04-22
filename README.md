# Docker Compose Files

Unless otherwise stated, simple run `docker-compose up` in each folder!

All compose files use `version: '2'` of the API, so this requires: `docker 1.10+` and `docker-compose 1.6+`.

## Sensu Server

Monitoring server

#### Configuration

Before deployment, generate the appropriate SSL certs with:
```sh
./gen-ssl.sh
```

#### Files

In order to deploy sensu-clients, use the /ssl/client certs.

feel free to edit `sensu-checks.json` and `sensu.json` to your liking.

## PowerDNS

PowerDNS server and poweradmin interface

[original source](https://github.com/obi12341/docker-pdns)

Default credentials:
  - POWERDNS on :8080: admin/admin
  - PDNS on 8001: admin/changeme
  - PDNS API on 8001: changeme

#### Configuration

These options can be set:

  - PDNS_ALLOW_AXFR_IPS
  - PDNS_MASTER
  - PDNS_SLAVE
  - PDNS_CACHE_TTL
  - PDNS_DISTRIBUTOR_THREADS
  - PDNS_RECURSIVE_CACHE_TTL
  - PDNS_RECURSIVE_CACHE_TTL
  - PDNS_WEBSERVER
  - PDNS_API
  - PDNS_API_KEY
  - PDNS_PASSWORD
  - PDNS_WEB_PORT
  - POWERADMIN_HOSTMASTER
  - POWERADMIN_NS1
  - POWERADMIN_NS2
