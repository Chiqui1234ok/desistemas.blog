---
layout: post
title:  "Como entrar a una máquina virtual (VM) sin SSH, SPICE/QXL o escritorio remoto • Proxmox"
date:   2025-11-07 10:37:00 -0300
categories: [homelabing]
tags: proxmox, ssh, qxl, spice, serial, puerto serie
---

# Preámbulo

Hoy, el router no funcionaba. Ayer había hecho unos cambios muy tarde y algo hice mal. Por culpa del sueño, hoy no tenía red ni era posible entrar a ninguna web (tampoco al panel de Proxmox, para arreglar el desastre).

### Mi caso:

> Se enciende la máquina para homelab, para tener otro día de trabajo. En esta PC, se implementó un router virtualizado y varios servicios y máquinas virtuales con Windows. La máquina virtual de Windows inició, pero sin internet. Al iniciar sesión y entrar al panel de Proxmox, el navegador notifica que no pudo encontrarse la dirección. Evidentemente el router está muerto, aunque iniciado (según `qm status 200`).
> Hay muchas formas de solucionarlo, la más fácil sería hacer *rollback* a un snapshot dónde el router funcione. **Pueden haber situaciones dónde volver a un snapshot estable no sea posible** y, para colmo (y por seguridad), no existan formas de conectarse remotamente al router virtualizado.

# Entrar a una VM desde la terminal

Si, se puede entrar a una VM, incluso desde el host Proxmox sin necesidad de interfaz gráfica (es decir, sin gestor de ventanas ni escritorio).

Esto es posible gracias al puerto de escucha / socket que puede crearse con un puerto serie (serial) virtual.

✍ En tan sólo 5 minutos, se explica el caso, la solución y la prueba.

{% include youtube.html videoUrl="https://www.youtube.com/embed/OmHjDegXKA0?si=PYdRPR013AmY9ZoM" %}
 
# Epílogo

Ahora, el administrador de sistemas tiene una herramienta más para diagnosticar y arreglar problemas, incluso sin tener red.

Nos vemos en un próximo post 😉