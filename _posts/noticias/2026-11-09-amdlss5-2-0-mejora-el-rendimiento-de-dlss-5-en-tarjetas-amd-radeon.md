---
layout: post
title: "AMDLSS5 2.0: Mejora el rendimiento de DLSS 5 en tarjetas AMD Radeon"
description: "La nueva versión del mod AMDLSS5 introduce un motor propio que optimiza el Neural Rendering de NVIDIA en GPUs Radeon RX 9070."
image: https://tpucdn.com/img/6ud29060LWgRyFTj.jpg
date: 2026-11-09 21:14:38 -0300
categories: [hardware, gaming]
tags: amd, radeon, dlss, amdlss5, modding, rendimiento
---

El proyecto AMDLSS5, un mod gratuito diseñado para ejecutar el Neural Rendering de NVIDIA DLSS 5 en las tarjetas AMD Radeon RX 9070 y RX 9070 XT, ha alcanzado la [versión 2.0](https://github.com/Wehaveall/AMDLSS5/releases/tag/v2.0.0). Esta actualización destaca por la implementación de un motor desarrollado específicamente por el creador del proyecto, Wehaveall, lo que permite que la herramienta sea independiente y ya no requiera archivos de otros mods previos.

Anteriormente, las versiones de este software se basaban en el trabajo de Daniel Blanco, conocido por el proyecto DLSS-NR-on-AMD, el cual [logró implementar DLSS 5 en tarjetas Radeon](https://www.techpowerup.com/352360/modders-get-dlss-5-working-on-amd-graphics-cards-though-performance-is-rough) en septiembre.

## Rendimiento y comparativas

En las pruebas de rendimiento realizadas en una escena de 60 segundos de *Resident Evil Requiem* a resolución 4K utilizando FSR en una GPU RX 9070 XT, la nueva versión alcanzó un promedio de 101.2 FPS con mínimos del 1% de 78.5 FPS. Estas cifras representan una mejora de aproximadamente un 11% en el promedio de fotogramas y un 19% en los mínimos, en comparación con la versión 1.6.1, que registraba 91.3 y 66.0 FPS respectivamente.

La cifra de mejora del 64% mencionada en los informes surge de una comparativa con otros mods no identificados que alcanzaron 61.6 FPS en la misma escena. No obstante, cabe señalar que estos datos provienen de las mediciones del propio desarrollador en un único escenario y juego, por lo que no existe una comparativa estandarizada que determine el coste exacto de implementar el Neural Rendering.

## Compatibilidad y soporte de juegos

El soporte para títulos ha sido ampliado e incluye actualmente a *PRAGMATA*, *Nioh 3* y *GTA 5 Enhanced* (este último únicamente en el modo historia sin conexión y con BattlEye desactivado). 

Respecto al hardware, se estima que las tarjetas de la serie RX 9060 podrían ser compatibles, aunque aún no han sido sometidas a pruebas oficiales. Por otro lado, el soporte para la arquitectura RX 7000 se encuentra actualmente en fase alfa y todavía no ha sido validado en hardware real.

![AMDLSS5 Benchmark](https://tpucdn.com/img/0mJVEkCnDeG5eUSq.jpg)

Además, si se quiere aportar al proyecto, puede hacerse mediante [una donación](https://buy.stripe.com/7sY9AT5PjbRT4M47u9d7q01) o [regalo de un juego](https://steamcommunity.com/profiles/76561197992454025/), para que el creador **Wehaveall** tenga algo dónde testear y trabajar en compatibilizarlo con AMDLLS5.