---
layout: post
title:  "Iniciá tu homelab con Lightwhale y Docker • Linux"
date:   2026-07-19 14:00:01 -0300
categories: [linux]
tags: linux, docker, homelab, lightwhale
description: "No hay nada más fácil que armar un servidor con aplicaciones ejecutándose sobre Docker. Lightwhale inicia con Docker por defecto, permitiendo tener un homelab lo más rápido posible."
image: https://earthly.dev/blog/assets/images/systemd/1.png
---

# Introducción

Lightwhale es un [sistema operativo inmutable](#inmutabilidad) diseñado para ejecutar Docker, exclusivamente. Permite cargarse desde un almacenamiento extraíble, como un pendrive USB, sobre la memoria RAM de cualquier PC x86_64.

> Nota del autor: el uso de Lightwale me enseñó más buenas prácticas, aplicables también a sistemas operativos "normales". Esto lo vamos a repasar durante el post.

En este artículo, el lector se dará cuenta si es la distribución a elegir y porqué.

# Conceptos a aprender

## Inmutabilidad 

El sistema operativo carga en memoria RAM, lo que casi inherentemente lo convierte en un sistema inmutable. La memoria RAM mantiene los datos "vivos" mientras el equipo esté encendido. Al reiniciarse, la imágen original del sistema operativo se carga en memoria RAM.

## Directorios que sí pueden ser modificados

Por su naturaleza de ser un sistema operativo inmutable, es importante mencionar que sólo los siguientes directorios soportan escritura:

### Directorio */etc* • Configuraciones del sistema

Vital para configurar la red, SSH y resto de software. [Aunque esto lo hace vulnerable], como cualquier otro sistema común(#explicar-que-con-un-etc-abierto-se-pueden hacer crontab y mantener un troyano vivo de esa forma).

### Directorio */var* • Registros del sistema

Los "logs" del sistema operativo y sus aplicaciones se guardan en esta carpeta.

### Directorio */home* • Carpetas de los usuarios

Esta carpeta no debería usarse activamente, aunque el sistema lo permite. [¿Por qué?](#)
Se desaconseja crear usuarios, porque en el próximo reinicio estará solo su carpeta home. El usuario en sí con su ID de sí mismo y su grupo, desaparecen tras el reinicio. Es "útil" para los casos que se quieran dar distintos logins SSH, y hasta ahí.

# Sistema de archivos

Lightwhale utiliza BtrFS.

# Descarga

Lightwhale no tiene un instalador en sí, como las distribuciones Linux de escritorio o Microsoft Windows. El sistema operativo se distribuye vía una imágen ISO, que puede ser descargada desde [el link oficial](https://lightwhale.asklandd.dk/download/lightwhale-latest-x86.iso) o vía cURL:

```bash
curl -JOL https://lightwhale.asklandd.dk/download/lightwhale-latest-x86.iso
```

En el caso del tutorial, se descarga la versión 3.0.5, que se usará para los ejemplos de este artículo.

# Instalación

Una vez pasado por el [proceso de descarga](#descarga) y estando en la misma carpeta dónde reside la ISO, se puede grabar de dos formas muy convenientes:

## Vía la herramienta `dd` • Linux

Previamente se realiza un listado de los dispositivos de almacenamiento conectados, con el comando `fdisk -l`:

```bash
Disk /dev/sdd: 119.24 GiB
Disk model: INTEL SSDSC2KW128G8
```

En el caso del tutorial, la ISO se graba sobre un SSD representado en Linux cómo */dev/sdd*. Por ende, el comando `dd` debe indicar ese dispositivo luego del parámetro **of=**, así:

```bash
sudo dd bs=4M conv=fsync if=lightwhale-3.0.5-x86.iso of=/dev/sdd
```

Una vez copiada la imágen, es conectar el almacenamiento en la PC y comenzar a utilizar Docker.

## Vía Balena Etcher • Windows, Mac y Linux

Texto.

# Primer uso

