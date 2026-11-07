---
layout: post
title: "Bazzite 45: Soporte para Linux EAC V2 y expansión de compatibilidad con hardware portátil"
description: "Bazzite 45 debuta con base en Fedora 45, nuevos kernels y un verificador para asegurar la compatibilidad con el sistema EAC V2 de Epic Games."
image: https://www.techpowerup.com/img/O5B4BRKwmjklxvtH.jpg
date: 2026-11-05 12:23:23 -0300
categories: [gaming, hardware]
tags: [bazzite, fedora, linux, gaming, hardware, epic games]
---

Poco después del lanzamiento oficial de Fedora 45, se ha presentado la nueva versión de Bazzite 45. Esta actualización se ha rebasado a Fedora 45 e integra entornos de escritorio actualizados, incluyendo GNOME 51.1 y KDE Plasma 6.8.2.

## Actualizaciones de Kernel y Hardware

La nueva versión de Bazzite incluye actualizaciones en los kernels OGC de Linux: la versión 7.2.15 para usuarios de AMD e Intel, y la 6.18.60 para usuarios de NVIDIA. Asimismo, se ha ampliado el soporte de hardware para incluir dispositivos como el [Acer Predator Atlas 8 y el ASUS ROG Xbox Ally X20](https://www.techpowerup.com/354071/bazzite-linux-gets-new-handheld-pc-support-with-asus-rog-xbox-ally-x20-and-acer-predator-atlas), además de periféricos adicionales como el hardware de volantes de carreras Logitech TrueForce.

En cuanto al software de sistema, los controladores Mesa se han actualizado a la versión 26.2.6 e InputPlumber ha recibido una actualización. Por su parte, CoolerController se ha trasladado al contenedor oficial de Docker, mientras que XWaylandVideoBridge ha sido eliminado con el objetivo de aumentar la estabilidad y corregir errores en KDE.

## Compatibilidad con Epic Games y el sistema EAC V2

De acuerdo con el [anuncio oficial](https://universal-blue.discourse.group/t/bazzite-45-is-here/12702) en la página de Universal Blue Discourse, Epic Games ha aceptado a Bazzite como proveedor de claves de firma. 

Como parte de este avance, el equipo de desarrollo ha implementado un verificador de preparación para Linux EAC V2 dentro de Bazzite 45. Esta herramienta analiza automáticamente los [requisitos más recientes de Linux EAC V2](https://www.techpowerup.com/353720/fortnite-is-coming-to-linux-confirms-epic-games) y los compara con la configuración actual del kernel y la BIOS. El proceso de verificación abarca parámetros críticos como la firma de módulos y del kernel, Secure Boot, TPM 2.0, measured boot, IOMMU, kernel lockdown, kexec y BPF LSM. En caso de detectarse alguna incompatibilidad, el sistema notificará al usuario de inmediato.

![Captura de Bazzite 45 1](https://www.techpowerup.com/img/O5B4BRKwmjklxvtH.jpg)
![Captura de Bazzite 45 2](https://www.techpowerup.com/img/3vV9BRE3sNX9aFGZ.jpg)