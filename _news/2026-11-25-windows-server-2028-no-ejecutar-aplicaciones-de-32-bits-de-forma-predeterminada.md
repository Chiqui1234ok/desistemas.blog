---
layout: post
title: "Windows Server 2028 no ejecutará aplicaciones de 32 bits de forma predeterminada"
description: "Microsoft retirará el soporte nativo de 32 bits en Windows Server 2028 por defecto para frenar vulnerabilidades y malware heredado."
image: assets/news/2026-11-25-windows-server-2028-no-ejecutar-aplicaciones-de-32-bits-de-forma-predeterminada/8NjRC6Et9HV9hAcB.webp
date: 2026-11-25 20:58:42 -0300
categories: [homelabbing]
tags: microsoft, windows server 2028, wow64, seguridad, 32 bits, ignite 2026
---

Durante el evento Ignite 2026, Microsoft confirmó que Windows Server 2028 no contará con la capacidad de ejecutar aplicaciones de 32 bits de forma predeterminada. Según explicó Elden Christensen, representante de la compañía, el subsistema WoW64 (*Windows 32-bit on Windows 64-bit*) será eliminado de las instalaciones base del próximo sistema operativo para servidores, el cual se encuentra actualmente en fase de vista previa pública.

El subsistema WoW64 funciona como la capa de compatibilidad que permite ejecutar software de 32 bits en entornos Windows de 64 bits. No obstante, Christensen aclaró que no se trata de una eliminación definitiva, sino de una transición hacia una "característica bajo demanda" (*feature on demand*). De este modo, los administradores de sistemas que aún dependan de aplicaciones empresariales antiguas de 32 bits podrán añadir este componente manualmente cuando lo necesiten.

![Anuncio de Windows Server 2028 en Ignite 2026]({{ base.url }}/assets/news/2026-11-25-windows-server-2028-no-ejecutar-aplicaciones-de-32-bits-de-forma-predeterminada/8NjRC6Et9HV9hAcB.webp)

## Seguridad por defecto frente a las amenazas actuales

El objetivo principal de esta modificación es bloquear la ejecución de malware de 32 bits, el cual resulta inoperante en el sistema operativo si el subsistema WoW64 no se encuentra instalado. Esta medida forma parte de una estrategia más amplia denominada "seguro por defecto" (*secure by default*) para Windows Server 2028.

Christensen señaló además que las herramientas de inteligencia artificial están descubriendo vulnerabilidades a un ritmo preocupante, lo que ha llevado a Microsoft a priorizar la retirada de diversos componentes heredados considerados de riesgo. Dentro de este recorte también figuran protocolos y tecnologías como SMBv1 y VBScript, e incluso se evalúa la posibilidad de abandonar el soporte para el BIOS tradicional en favor de estándares modernos.

![Detalles sobre la retirada de componentes heredados en Windows Server 2028]({{ base.url }}/assets/news/2026-11-25-windows-server-2028-no-ejecutar-aplicaciones-de-32-bits-de-forma-predeterminada/nD6gExBD3F8RCVPG.webp)

## Sin cambios para Windows 11

Esta restricción es exclusiva del entorno de servidores. Microsoft precisó que Windows 11 no se verá afectado por esta decisión y que no existen planes de retirar el soporte para software de 32 bits en su sistema operativo de escritorio, una postura clave considerando que una gran cantidad de videojuegos clásicos para PC aún dependen de dicha arquitectura.