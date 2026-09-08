---
layout: post
title:  "Instalar un servidor web • Linux"
date:   2025-02-18 19:00:01 +0000
tags: servidor, servidor web, httpd, nginx, php, servicio
---

# Preámbulo

A veces, sólo se precisa un servidor web que sirva HTML. Sin puntos de ataque a vulnerabilidades, y sólo lenguajes de programación que se ejecutan en front-end. Este tutorial va a suplir esa necesidad, y servirá para cuándo se desee realizar el tutorial de Kubernetes, próximamente.

Se asume que ya se tiene una distribución Debian instalada, mediante un [contenedor LXC en Proxmox](#) o en una computadora [real](#) o [virtual](#), con la paquetería ***apt*** configurada y actualizada.

En caso de que no sea así, un buen comienzo sería:

- [Instalación de un contenedor LXC Debian • Proxmox](#)
- [Instalación de Debian en una computadora real • Linux](#)
- [Instalación de Debian en una VM • Proxmox](#)

# Instalar nginx

El servidor web puede manejarse con Apache (httpd) o Nginx. El segundo tiene fama histórica de ser más ligero. Se instalará siendo administrador:

```bash
su -
```

Y se escribe el comando:

```bash
apt install nginx -y
```

Esta instalación también iniciará ***nginx*** como servicio, cosa que debe comprobarse con:

```bash
systemctl status nginx
```

Se puede ejecutar `systemctl start nginx`, si la salida del comando anterior no dice "active (running)".

## Instalar dependencias

Aunque opcional, se recomienda instalar ***git*** para luego poder descargar un sitio de prueba.

```bash
apt install git -y
```

# Averiguar la IP del servidor

Para saber la IP del servidor y poder comprobar que se puede acceder al sitio web por defecto de Nginx, se ejecuta:

```bash
ip addr
```

Esto arrojará un output, usualmente con dos interfaces: "lo" y otra que comienza con "eth", "eno", "ensp", etc. Esa interfaz es la que nos dirá la IP.

![Dirección IP]({{ base.url }}/assets/posts/instalar-un-servidor-web/ip-addr-1.png)

Esta IP será por la cuál podremos ver el sitio web que aloje este servidor, en un futuro cercano.

# Entrar al sitio web del servidor

De momento, Nginx ofrece una página web de prueba para ser visitada, accesible desde la IP del servidor mediante el navegador web de nuestra elección. Se verá algo similar a ésto:

![Welcome to Nginx]({{ base.url }}/assets/posts/welcome-to-nginx.png)

# Montar un sitio real

La carpeta dónde se aloja el sitio web por defecto está en **/var/www/html/**. Allí se encuentra el archivo **index.nginx-debian.html**, que será ignorado en cuánto se vuelque el nuevo sitio web.

Si aún tu sitio no está listo, realicé uno para que no quede vacío, y tus visitantes no queden impactados por un mensaje en inglés que poco tiene que ver con tu actividad.

