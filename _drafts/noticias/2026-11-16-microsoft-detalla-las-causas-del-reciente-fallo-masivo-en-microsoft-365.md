---
layout: post
title: "Microsoft detalla las causas del reciente fallo masivo en Microsoft 365"
description: "Un error en una actualización y fallos en la gestión de carga provocaron la caída de servicios clave como Outlook, Teams y OneDrive."
image: https://www.techpowerup.com/img/OH82rOFykDXbxkx1.jpg
date: 2026-11-16 15:37:59 -0300
categories: [hardware, analisis]
tags: microsoft, microsoft 365, outage, infraestructura, tech news
---

Microsoft ha publicado un [informe preliminar post-incidente](https://www.365fanatic.com/wp-content/uploads/2026/11/PostIncidentReport.pdf) para explicar la reciente [caída de Microsoft 365](https://www.techpowerup.com/354799/microsoft-365-outage-enters-second-day-as-outlook-and-teams-struggle-to-recover). Según la compañía, los usuarios se vieron afectados durante casi 24 horas, en un periodo comprendido entre las 16:20 UTC del 12 de noviembre y las 16:10 UTC del 13 de noviembre.

La interrupción impidió que numerosos usuarios accedieran a sus bandejas de entrada en Outlook y provocó retrasos en la entrega de correos electrónicos. Asimismo, otros servicios fundamentales como Microsoft Teams, Copilot, SharePoint y OneDrive sufrieron afectaciones, debido a su dependencia funcional de Exchange Online.

## Causas técnicas de la interrupción

La compañía ha identificado tres problemas concurrentes que desencadenaron la crisis. El factor principal fue una corrección de software diseñada específicamente para los servidores de puerta de enlace (gateway) de Microsoft 365. Esta actualización introdujo una contención de bloqueos (*lock contention*) en un proceso interno de Windows, lo que derivó en un agotamiento de CPU y memoria bajo ciertas condiciones de carga.

Se ha señalado que este error permaneció inadvertido durante más de tres meses, debido a que las pruebas de carga de Microsoft se realizaron en equipos con capacidades inferiores, los cuales no fueron capaces de estresar la corrección de manera adecuada.

La situación se agravó cuando el servicio Teams intentó realizar una conmutación por error hacia la puerta de enlace principal compartida con Exchange Online. Esto provocó un desplazamiento de tráfico hacia los servidores restantes, los cuales colapsaron ante la carga adicional. En el punto crítico de la incidencia, se estima que más del 80% de los servidores no respondieron.

![Infraestructura de servidores afectados](https://www.techpowerup.com/img/oA8Zho6D68YSNlaw.jpg)