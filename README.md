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

#### Configuration

These options can be set:

  - **PDNS_ALLOW_AXFR_IPS**: restrict zonetransfers to originate from these IP addresses. Enter your slave IPs here. (Default: "127.0.0.1", Possible Values: "IPs comma seperated")
  - **PDNS_MASTER**: act as master (Default: "yes", Possible Values: "yes, no")
  - **PDNS_SLAVE**: act as slave (Default: "no", Possible Values: "yes, no")
  - **PDNS_CACHE_TTL**: Seconds to store packets in the PacketCache (Default: "20", Possible Values: "<integer>")
  - **PDNS_DISTRIBUTOR_THREADS**: Default number of Distributor (backend) threads to start (Default: "3", Possible Values: "<integer>")
  - **PDNS_RECURSIVE_CACHE_TTL**: Seconds to store packets in the PacketCache (Default: "10", Possible Values: "<integer>")
  - **POWERADMIN_HOSTMASTER**: default hostmaster (Default: "", Possible Values: "<email>")
  - **POWERADMIN_NS1**: default Nameserver 1 (Default: "", Possible Values: "<domain>")
  - **POWERADMIN_NS2**: default Nameserver 2 (Default: "", Possible Values: "<domain>")
