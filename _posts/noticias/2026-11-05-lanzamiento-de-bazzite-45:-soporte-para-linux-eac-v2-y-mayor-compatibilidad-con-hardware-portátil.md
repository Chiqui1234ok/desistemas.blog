---
layout: post
title: "Lanzamiento de Bazzite 45: Soporte para Linux EAC V2 y mayor compatibilidad con hardware portátil"
description: "Bazzite 45 llega basado en Fedora 45, con soporte para el sistema anticheat de Epic Games y nueva compatibilidad con dispositivos handheld."
image: https://www.techpowerup.com/img/O5B4BRKwmjklxvtH.jpg
date: 2026-11-05 12:23:23 -0300
categories: [gaming, hardware]
tags: bazzite, linux, fedora, gaming, hardware, epic games, handheld
---

## Actualización de base y compatibilidad de hardware

Tras el lanzamiento oficial de Fedora 45, se ha presentado Bazzite 45, una versión que utiliza dicha base e integra los entornos de escritorio Gnome 51.1 y KDE Plasma 6.8.2. Esta actualización incluye kernels OGC actualizados: la versión 7.2.15 para plataformas AMD e Intel, y la 6.18.60 para usuarios de NVIDIA.

En cuanto al soporte de dispositivos, se ha extendido la compatibilidad para incluir nuevas consolas portátiles como el [Acer Predator Atlas 8 y el ASUS ROG Xbox Ally X20](https://www.techpowerup.com/354071/bazzite-linux-gets-new-handheld-pc-support-with-asus-rog-xbox-ally-x20-and-acer-predator-atlas). Asimismo, se han añadido nuevos periféricos, destacando el soporte para el hardware de volantes Logitech TrueForce.

![Interfaz de Bazzite](https://www.techpowerup.com/img/O5B4BRKwmjklxvtH.jpg)

## Mejoras en drivers y estabilidad del sistema

La versión 45 de Bazzite incorpora la actualización de los controladores Mesa a la versión 26.2.6. Además, se han realizado ajustes en componentes clave: InputPlumber ha sido actualizado y CoolerController se ha trasladado a un contenedor Docker oficial. En busca de una mayor estabilidad y para mitigar errores en KDE, se ha procedido a la eliminación de XWaylandVideoBridge.

## Integración con Epic Games y soporte para EAC V2

Uno de los avances más significativos es que Epic Games ha aceptado a Bazzite como proveedor de claves de firma. Según se detalla en el [anuncio oficial en la página de Universal Blue](https://universal-blue.discourse.group/t/bazzite-45-is-here/12702), el equipo de desarrollo ha implementado un verificador de preparación para Linux EAC V2.

Esta herramienta permite comprobar automáticamente si el sistema cumple con los [requisitos más recientes de EAC V2](https://www.techpowerup.com/353720/fortnite-is-coming-to-linux-confirms-epic-games). El proceso analiza la configuración del kernel y la BIOS, verificando parámetros críticos como la firma de módulos, Secure Boot, TPM 2.0, measured boot, IOMMU, kernel lockdown, kexec y BPF LSM. En caso de detectar cualquier incompatibilidad, el sistema notificará al usuario de forma inmediata.