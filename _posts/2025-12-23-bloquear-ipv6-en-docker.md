---
layout: post
title:  "Como deshabilitar IPV6 en Docker • Docker"
date:   2025-12-23 16:50:01 -0300
categories: [homelabing]
tags: linux, docker, puertos, firewall, ipv4, ipv6, tutorial
description: "En este post, el administrador de sistemas va a aprender a bloquear la exposición de puertos en el estándar IPv6, además de filtrar mediante protocolo TCP y UDP"
image: "/assets/posts/como-exponer-un-servicio-o-app-con-nginx-facil-ssl/portada.webp"
---

# Preámbulo

Algunos dicen que es por motivos de seguridad, otros porque no desean implementar IPv6. Quién les escribe, es porque no soporta escribir `docker ps` y que cada contenedor ocupe más de una línea. Cuándo ocupa más de una línea, el nombre del contenedor aparece en lugares que no son óptimos para leer.

Una forma de resolver esto, es especificar el puerto a usar, pero anteponiendo una IPv4.

# Caso de prueba

Se muestra este docker-compose.yml de ejemplo:

```yml
services:
  glance:
    container_name: glance
    image: glanceapp/glance
    restart: unless-stopped
    volumes:
      - ./config:/app/config
      - ./assets:/app/assets
      - /etc/localtime:/etc/localtime:ro
      # Optionally, also mount docker socket if you want to use the docker containers widget
      # - /var/run/docker.sock:/var/run/docker.sock:ro
    ports:
      - 100:8080
    env_file: .env
```

Este archivo va a exponer el puerto 100 en el host para IPV4 e IPV6, por eso al ejecutar `docker ps`, la salida será:

```bash
root@vps-home:/etc/docker/containers/glance# docker ps
CONTAINER    ID       IMAGE COMMAND CREATED STATUS PORTS NAMES 
f368f79a587a glanceapp/glance "/app/glance --confi…" 2 days ago Up 6 hours 0.0.0.0:100->8080/tcp, [::]:100->8080/tcp glance
```

Y este caso no es el peor, porque apenas tiene un puerto abierto. Cuándo se tienen dos o tres, la desorganización por tener IPV4 e IPV6 (cuándo el último no es necesario) es muy grande.

# Solución

Tomando de ejemplo el docker-compose.yml anterior, se debe dejar la zona de puertos de la siguiente manera:

```yml
    ports:
        - "0.0.0.0:100:8080/tcp"
```

Al colocar la IPV4 "0.0.0.0", Docker utiliza sólo este estándar.

# Epílogo

El administrador de sistemas ahora aprendió a resolver este problema de forma sencilla y sin tener que tocar el core de Docker o Linux.

¡Nos vemos en el próximo post!

## Tip extra

Si sólo quisiera usarse IPV6, la zona del docker-compose.yml sería:

```yml
    ports:
        - "[::]:100:8080"
```