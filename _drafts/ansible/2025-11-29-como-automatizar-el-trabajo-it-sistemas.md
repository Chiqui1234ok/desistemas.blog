---
layout: post
title:  "Como automatizar el trabajo de IT (Sistemas) • Ansible"
description: "Se pueden configurar manualmente decenas de servidores de formas que parecen idénticas y sistematizadas, pero a la hora de documentar y ahorrar tiempo en el próximo deploy de servidor, Ansible no tiene rival. Ansible es un software que permite ejecutar tareas comunes de instalación y configuración de un sistema operativo."
image: "/assets/posts/como-exponer-un-servicio-o-app-con-nginx-facil-ssl/portada.webp"
date:   2025-11-26 11:45:00 -0300
categories: [homelabing]
tags: ansible, sistemas, it, automatizacion, automatizar, optimizar, linux, arch, debian
---

# Preámbulo

Se pueden configurar manualmente decenas de servidores de formas que parecen idénticas y sistematizadas, pero a la hora de documentar y ahorrar tiempo en el próximo deploy de servidor, Ansible no tiene rival.

Ansible es un software que permite ejecutar tareas comunes de instalación y configuración de un sistema operativo.
Por ejemplo, en Proxmox serviría para automatizar (o semi-automatizar) la creación del almacenamiento de discos ZFS, los programas instalados y sus versiones, la creación de máquinas virtuales y contenedores, el blacklist de drivers de GPU (necesario para hacer pasaje de procesadores gráficos a VMs y contenedores), parámetros de lanzamiento para GRUB y un largo etcétera.

La sintáxis de Ansible es como aprender un pequeño lenguaje de programación, aunque también se involucran otras "sintáxis de código". En esta guía se enseña a dominar los conceptos de Ansible, sus lenguajes, arquitectura y formas de utilizarlo. **Es realmente sencillo y corto para explicar**, así que están invitados a seguir leyendo.

# Ventajas

Antes de comenzar con los "hosts" y "playbook", es importante marcar las ventajas y buenas prácticas de Ansible:

1. Se instala en un dispositivo Linux, que controla a otros equipos remotos llamados "clientes".
2. No se requiere ningún programa extra en los clientes (sólo, opcionalmente, el usuario "ansible").
3. Los clientes pueden ser Linux, Windows o Mac.
4. Salvo que se escriba un comando manualmente, Ansible es agnóstico al sistema operativo, y el playbook será compatible en cualquier cliente.
5. Es una fuente de documentación para los clientes, porque es una forma de estandarizar las configuraciones.

# Instalación y flujo de trabajo

Ansible se puede ejecutar localmente, pero no es lo recomendable porque suma software y consume espacio en disco que luego no será aprovechado por la máquina (se supone que la máquina ejecutaría Ansible una vez, para la configuración sistematizada). Por esta razón, lo típico es instalar Ansible en un equipo "dedicado" para eso. En un entorno de homelab, el equipo de todos los días suele ser una buena opción.

> Entiendo que no siempre se tiene disponible un entorno para virtualizar todo lo que se desea, o computadoras por doquier. Por esto, [este blog también ofrece una guía a los que desean hacerlo localmente](#).

## Instalación de Ansible en Debian / Mint / Ubuntu

En cualquier distribución derivada de Debian (Debian, Devuan, Linux Mint, Ubuntu, PopOS!, etc) se puede ejecutar la instalación  como usuario administrador, con los siguientes comandos:

1. Actualizar repositorio de paquetes:

```bash
apt update
```

2. Instalar Ansible:

```bash
apt install ansible-core -y
```

## Instalación de Ansible en Arch / Manjaro / CachyOS

Para Arch y derivados que utilicen Pacman como gestor de paquetes, se puede instalar como usuario administrador con la siguiente línea:

```bash
pacman -S ansible-core
```

> En caso de no encontrar `ansible-core`, se puede instalar `ansible` (aunque es más pesado y ofrece herramientas que no son imprescindibles).

# El inventario de servidores

El archivo **hosts** almacena los servidores en los que se trabajará, y los clasifica mediante grupos.

Esta guía utilizará de ejemplo una red que tiene un servidor Linux al cuál se le quiere instalar Nginx, y otros dos servidores DNS a los cuáles hay que instalarle Docker + Adguard.

El administrador de sistemas puede escribir este archivo **hosts.ini**:

```ini
[web]
10.90.0.155 ansible_user=ansible ansible_connection=ssh

[dns]
10.90.0.254 ansible_user=ansible ansible_connection=ssh
10.8.0.254 ansible_user=ansible ansible_connection=ssh
```

