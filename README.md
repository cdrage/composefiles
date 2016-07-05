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

These certs will be located within the SSL folder of the working directory.

#### Files

In order to deploy sensu-clients, use the /ssl/client certs.

Feel free to edit `sensu-checks.json` and `sensu.json` to your liking. This including setting your slack server as well as any email notifications.

## PowerDNS

PowerDNS server with the poweradmin interface

#### Credentials

POWERDNS on 8080: 
  - admin/admin
  - This is changed after initial login

PDNS on 8001:
  - admin/changeme
  - This can be changed through the environment variables

PDNS API on 8001:
  - changeme
  - This can be changed through the environment variables

#### Configuration

These options can be set for the powerdns image:

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


## CouchPotato

Disclaimer: I'm not responsible for whatever you do with these Docker images. Use at your own risk.

This is a docker-compose file of couchpotato, transmission as well as plex.

#### Configuration

Your files will be located under ./media folder in the current directory.
Same with the plex configuration data.

The files used for persistent storage upon container re-creation are as follows:
```sh
./media # media storage
./plex_config # config data
./couchpotato_config # config data
```

There's a few steps before you're 100% ready to-go.

  1. `mkdir media plex_config couchpotato_config`
  2. `chown 797:797 -R media plex_config couchpotato_config`
  3. `docker-compose up`
  4. Go to Couch Potato (http://localhost:5050)
  5. While going through the setup, set your downloader to Transmission with the credentials:
    http://transmission:9091
    admin
    admin
  6. Run through the rest of the Couch Potato setup
  7. Go to Plex (http://localhost:32400/web)
  8. Sign in, add your account. When adding media, simply add the /media folder from the root directory.
  9. (optional) remove `network_mode: host` from the docker-compose file and rebuild your cluster `docker-compose down && docker-compose up`
