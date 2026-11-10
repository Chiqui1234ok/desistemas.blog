---
layout: post
title: "AMD 'Medusa Point' aparece en Geekbench con arquitectura Zen 6 híbrida"
description: "Se filtran especificaciones de la APU 'Medusa Point' de AMD, destacando su configuración de 10 núcleos Zen 6 y soporte para instrucciones AVX-512."
image: https://www.techpowerup.com/img/IX51zzIvr9oyGRd3.jpg
date: 2026-11-05 14:08:02 -0300
categories: [hardware, analisis]
tags: amd, medusa point, zen 6, cpu, apu, rdna 4, geekbench
---

![AMD Medusa Point](https://www.techpowerup.com/img/IX51zzIvr9oyGRd3.jpg)

La nueva APU de AMD, identificada bajo el nombre en clave "Medusa Point", ha aparecido en la plataforma de pruebas Geekbench. El dispositivo presenta una configuración de 10 núcleos y 20 hilos, empleando un enfoque híbrido que combina cuatro núcleos "Zen 6" con seis núcleos "Zen 6c".

En cuanto a la jerarquía de memoria, cada núcleo cuenta con 32 KB de caché de instrucciones L1, 48 KB de caché de datos L1 y 1 MB de caché L2, mientras que la totalidad de los núcleos comparten una memoria caché L3 de 16 MB. Durante las pruebas, el sistema utilizó 64 GB de memoria DDR5 en configuración de cuádruple canal con una velocidad de 5,188 MT/s.

## Especificaciones de instrucciones y frecuencia

El conjunto de instrucciones detectado confirma el soporte completo para AVX-512, incluyendo las extensiones AVX512-FP16 y AVX512-VNNI, además de AVX-VNNI. Respecto a las frecuencias de reloj, la muestra indica una frecuencia base de 2.0 GHz; no obstante, Geekbench registra una frecuencia máxima de 1996 MHz, valor que probablemente se deba a una lectura errónea de los primeros silicios de prueba.

## Arquitectura gráfica y soporte de FSR 4

Se especula que "Medusa Point" introducirá la variante "RDNA 4m" para el segmento móvil, basada en la arquitectura RDNA 4. Aunque no existen comparativas directas todavía, la presencia de instrucciones como WMMA y SWMMAC sugiere que la GPU "GFX1170" pertenece a la generación GFX11 (RDNA 3) pero incorpora módulos de RDNA 4. Esta evolución tecnológica permitiría el soporte de la tecnología FSR 4 incluso en esta APU.