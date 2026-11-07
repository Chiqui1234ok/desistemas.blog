---
layout: post
title: "Microsoft introduce Cloud Rebuild, una nueva opción de recuperación para Windows 11"
description: "Una nueva función permite reinstalar Windows 11 y sus controladores mediante la nube, incluso si el sistema no logra iniciar correctamente."
image: https://www.techpowerup.com/img/NupumpDLJTPcFYVe.jpg
date: 2026-11-01 17:13:38 -0300
categories: [hardware]
tags: [microsoft, windows 11, hardware, recuperación, nube]
---

## Nueva función de recuperación mediante la nube

Microsoft ha presentado [Cloud Rebuild](https://learn.microsoft.com/en-us/windows/configuration/cloud-rebuild/), una opción de recuperación que permite borrar y reinstalar Windows 11 descargando una imagen limpia y los controladores del equipo directamente desde Windows Update. Esta característica es capaz de funcionar incluso cuando el sistema presenta fallos que impiden el arranque.

Esta funcionalidad se incluye en la actualización opcional de vista previa [KB5127936](https://support.microsoft.com/en-us/servicing/os/windows-11/2026/10/kb5127936-windows-11-25h2-26h2-update), lanzada el 28 de octubre para las versiones Windows 11 25H2 y [26H2](https://www.techpowerup.com/353239/microsoft-launches-windows-11-26h2-update), y se encuentra actualmente en un despliegue gradual.

![Interfaz de recuperación de Windows 11](https://www.techpowerup.com/img/NupumpDLJTPcFYVe.jpg)

## Acceso y diferencias técnicas

Si el sistema operativo logra cargar correctamente, la opción se encuentra disponible en Configuración > Sistema > Recuperación bajo la denominación "Rebuild PC". En situaciones donde el equipo no arranque, el sistema accederá al Entorno de recuperación de Windows (WinRE) tras varios intentos fallidos de inicio, donde la opción de Cloud Rebuild aparecerá dentro del menú de Solucionar problemas.

A diferencia del modo de descarga en la nube que ya existía en el menú "Restablecer este equipo", Microsoft indica que [Cloud Rebuild](https://learn.microsoft.com/en-us/windows/configuration/cloud-rebuild/) ofrece una solución más completa al integrar la descarga de controladores y no depender de la integridad de la copia de Windows instalada actualmente.

## Seguridad y gestión administrativa

El proceso implica un formateo del disco del sistema, lo que conlleva la eliminación de aplicaciones, configuraciones, cuentas de usuario y archivos locales. Únicamente se preservarán los datos que hayan sido previamente sincronizados con servicios como OneDrive.

Para casos de transferencia de equipos, el usuario puede seleccionar un modo de sanitización que realiza un borrado seguro del disco. Asimismo, los administradores de TI disponen de la capacidad de ejecutar una reconstrucción de forma remota a través del Recovery CSP.