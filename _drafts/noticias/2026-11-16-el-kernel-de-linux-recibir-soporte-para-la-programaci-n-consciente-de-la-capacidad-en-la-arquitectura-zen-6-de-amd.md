---
layout: post
title: "El kernel de Linux recibirá soporte para la programación consciente de la capacidad en la arquitectura Zen 6 de AMD"
description: "AMD implementará en el kernel de Linux un nuevo sistema de gestión de tareas para optimizar la arquitectura heterogénea de sus futuros procesadores Zen 6."
image: https://www.techpowerup.com/img/S2Q3xfTaNLYrFeug.jpg
date: 2026-11-16 20:41:59 -0300
categories: [hardware, programacion]
tags: amd, zen 6, linux, kernel, cpu, arquitectura, scheduling
---

Los rumores sobre el desarrollo de los nuevos núcleos Zen 6 LP para la próxima generación de la arquitectura de CPU de AMD (ver [Zen 6 Technical Deep Dive aquí](https://www.techpowerup.com/review/amd-zen-6-technical-deep-dive/)) parecen confirmarse. El kernel de Linux se está preparando para ofrecer soporte integral a esta nueva arquitectura.

Una serie de parches presentados por la propia AMD detalla la implementación de la programación consciente de la capacidad (*Capacity-Aware Scheduling* o CAS). Esta mejora permitiría que el kernel de Linux detecte las capacidades individuales de cada núcleo de la CPU y asigne las tareas de manera eficiente según la potencia de cada unidad.

![Arquitectura de procesadores AMD](https://www.techpowerup.com/img/S2Q3xfTaNLYrFeug.jpg)

## Mejoras en la gestión de núcleos asimétricos

En la actualidad, el controlador `amd-pstate` no exporta la capacidad por CPU, lo que provoca que el planificador trate todos los núcleos como si fueran iguales, distribuyendo las tareas sin considerar la fuerza o potencia de cada núcleo.

La implementación propuesta consta de dos etapas principales:

1. **Publicación de capacidades asimétricas:** El primer parche permite que `amd-pstate` publique capacidades por CPU mediante la interfaz de escalado de capacidad híbrida de la arquitectura. Esta función estará activada de forma predeterminada en el hardware compatible, aunque podrá desactivarse mediante el parámetro de arranque `amd_cas=disable`.

2. **Coordinación del planificador:** El segundo parche asegura que `amd-hfi` deje de intervenir cuando el sistema CAS esté activo, dado que ambos componentes gestionan el mismo estado del planificador.

![Detalles técnicos de la arquitectura Zen 6](https://www.techpowerup.com/img/tBhwrcVFiNnz9ohA.jpg)