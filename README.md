# Docker Compose Files

```
                  ##         .
            ## ## ##        ==
         ## ## ## ## ##    ===
     /"""""""""""""""""\___/ ===
~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
     \______ o           __/
       \    \         __/
        \____\_______/
```

A collection of Docker Compose files I use. Read below for a description of each container.

Unless otherwise stated, simply run:

```sh
docker-compose up
```

All compose files use: `version: '2'` of the API, so this requires: `docker 1.10+` and `docker-compose 1.6+`.

## Sensu Server

**Description:**

Monitoring server

**Configuration:**

Before deployment, generate the appropriate SSL certs with:

```sh
./gen-ssl.sh
```

These certs will be located within the SSL folder of the working directory.

**Files:**

In order to deploy sensu-clients, use the /ssl/client certs.

Feel free to edit `sensu-checks.json` and `sensu.json` to your liking. This including setting your slack server as well as any email notifications.

## PowerDNS

**Description:**

PowerDNS server with the poweradmin interface

**Credentials:**

POWERDNS on 8080: 
  - admin/admin
  - This is changed after initial login

PDNS on 8001:
  - admin/changeme
  - This can be changed through the environment variables

PDNS API on 8001:
  - changeme
  - This can be changed through the environment variables

**Configuration:**

These options can be set for the powerdns image:

```sh
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
```


## Media Center (Sonarr + Radarr + Transmission + Plex)

Disclaimer: I'm not responsible for whatever you do with these Docker images. Use at your own risk.

This is a docker-compose file of plex, sonarr, radarr and transmission.

**Configuration:**

Notes for configuring:

  - Use /var/lib/transmission-daemon/downloads for the dir in sonarr and radarr (prob with radarr not detecting that something is "downloaded")
  - DONT RENAME (bug in radarr not renaming movies and removing the older folder)

Your files will be located under ./media folder in the current directory.
Same with the plex configuration data.

The files used for persistent storage upon container re-creation are as follows:
```sh
./media # media storage
./config/plex # config data
./config/sonarr
./config/radarr
```
The instructions below will show how to create these persistent configuration folders.

There's a few steps before you're 100% ready to-go.

```
mkdir media config
chown docker:docker -R media config
chmod 777 -R media config # yolo
```

**Setup:**

  1. Run `docker run --rm -it wernight/plex-media-server retrieve-plex-token` to find your Plex Token. Plug it into the `docker-compose.yaml` file where KEYHERE is located.
  2. `docker-compose up`
  3. Go to Sonarr and set everything up (http://localhost:8989).
  4. Go to Radarr and set everything up (http://localhost:7878).
  5. Go to Plex (http://localhost:32400/web)
  6. Sign in, add your server (should automatically appear as you added the Plex Token). When adding media, simply add the /media folder from the root directory of the server, both /tv and /movies.
