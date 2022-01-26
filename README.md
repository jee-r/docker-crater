# Docker-crater
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/j33r/crater?style=flat-square)](https://microbadger.com/images/j33r/crater)
[![DockerHub](https://img.shields.io/badge/Dockerhub-j33r/crater-%232496ED?logo=docker&style=flat-square)](https://hub.docker.com/r/j33r/crater)
[![ghcr.io](https://img.shields.io/badge/ghrc%2Eio-jee%2D-r/crater-%232496ED?logo=github&style=flat-square)](https://ghcr.io/jee-r/crater)

A docker image for [Crater](https://craterapp.com/)

# Supported tags

| Tags | Size | Platformss | Build |
|-|-|-|-|
| `latest`, `main` | ![](https://img.shields.io/docker/image-size/j33r/crater/main?style=flat-square) | `amd64` | ![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/jee-r/docker-crater/Deploy/main?style=flat-square)
| `dev` | ![](https://img.shields.io/docker/image-size/j33r/crater/dev?style=flat-square) | `amd64` | ![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/jee-r/docker-crater/Deploy/dev?style=flat-square) | 

# What is crater ?

From [https://github.com/crater-invoice/crater](https://github.com/crater-invoice/crater):

> Crater is an open-source web & mobile app that helps you track expenses, payments & create professional invoices & estimates.
>
> Web Application is made using Laravel & VueJS while the Mobile Apps are built using React Native.

- Source Code : https://github.com/crater-invoice/crater
- Documentation: https://docs.craterapp.com/
- Official Website: https://craterapp.com/

# How to use these images

[`docker-compose`](https://docs.docker.com/compose/) can help with defining the `docker run` config in a repeatable way rather than ensuring you always pass the same CLI arguments.

before running `docker compose up -d` you should create directories, docker network and adapte this example to your environment.

Here's an example `docker-compose.yml` config:

```yaml
version: "3.9"

services:
  php:
    image: ghcr.io/jee-r/crater:dev
    container_name: crater_php
    user: "1000:1000"
    restart: unless-stopped
    networks:
      - crater
    environment:
      - HOME=/app
      - TZ=Europe/Paris
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./data/app:/app

  nginx:
    image: nginxinc/nginx-unprivileged:alpine
    container_image: crater_nginx
    restart: unless-stopped
    networks:
      - crater
      - traefik-public
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./data/nginx.conf:/etc/nginx/conf.d/default.conf
      - ./data/app:/app
    environment:
      - TZ=Europe/Paris
    expose:
      - 8080:8080
    # Traefik Labels 
    #labels:
    #  - traefik.enable=true
    #  - traefik.docker.network=traefik-public
    #  - traefik.constraint-label=traefik-public
    #  - traefik.http.routers.crater-http.rule=Host(`crater.YOURDOMAIN`)
    #  - traefik.http.routers.crater-http.entrypoints=http
    #  - traefik.http.routers.crater-http.middlewares=https-redirect
    #  - traefik.http.routers.crater-https.rule=Host(`crater.YOURDOMAIN`)
    #  - traefik.http.routers.crater-https.entrypoints=https
    #  - traefik.http.routers.crater-https.tls=true
    #  - traefik.http.routers.crater-https.tls.certresolver=le
    #  - traefik.http.services.crater.loadbalancer.server.port=8080

  mariadb_master:
    image: docker.io/bitnami/mariadb:10.6
    networks:
      - crater
    #user: 1000:1000
    restart: unless-stopped
    volumes:
      - ./data/db:/bitnami/mariadb
      - ./data/backup/db_dumps:/backup
      - /etc/localtime:/etc/localtime:ro
    environment:
      - TZ=Europe/Paris
      - MARIADB_USER=crater
      - MARIADB_DATABASE=crater
      - MARIADB_PASSWORD=HACKME
      - ALLOW_EMPTY_PASSWORD=no
      - MARIADB_ROOT_PASSWORD=HACKME
      #- MARIADB_REPLICATION_MODE=master
      #- MARIADB_REPLICATION_USER=repl_user
      #- MARIADB_REPLICATION_PASSWORD=HACKME
    healthcheck:
      test: ['CMD', '/opt/bitnami/scripts/mariadb/healthcheck.sh']
      interval: 15s
      timeout: 5s
      retries: 6
  
networks:
  crater:
    attachable: true
#  traefik-public:
#    external: true

```

## Volume mounts

- `data/app`: This directory contain the crater app 
- `data/db`: This is where the database is stored
- `data/nginx.conf`: nginx config file
- `/etc/localtime`: This directory is for have the same time as host in the container.


## Environment variables

- `TZ`: To change the timezone of the container set the `TZ` environment variable. The full list of available options can be found on [Wikipedia](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

# Contibute

1. Fork this repository
2. go in the `dev` branch `git checkout dev` or create a new one based on the `dev` branch
3. do your stuff
4. create a Pull Request 

Or if you don't know what all this shit mean simply open a new issue

# License

This project is under the [GNU Generic Public License v3](/LICENSE) to allow free use while ensuring it stays open.
