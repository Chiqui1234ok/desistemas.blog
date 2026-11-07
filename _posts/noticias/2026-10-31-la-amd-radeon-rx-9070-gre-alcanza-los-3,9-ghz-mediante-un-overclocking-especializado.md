---
layout: post
title: "La AMD Radeon RX 9070 GRE alcanza los 3,9 GHz mediante un overclocking especializado"
description: "Un usuario logra una frecuencia récord de 3,9 GHz en la Radeon RX 9070 GRE utilizando una carga de trabajo personalizada en DirectX 9."
image: https://www.techpowerup.com/img/GZGgUcFpmFR0fraH.jpg
date: 2026-10-31 12:55:47 -0300
categories: [hardware]
tags: [amd, radeon, rx 9070 gre, overclocking, gpu, directx 9]
---

La tarjeta gráfica AMD Radeon RX 9070 GRE ha alcanzado una frecuencia de reloj de 3,9 GHz en una prueba de concepto reciente. Este hito fue logrado por el usuario "ShrimpBrime" del foro de TechPowerUp, quien desarrolló herramientas personalizadas para GPUs Radeon denominadas "R-Team OC" y "GPU Frequency Generator".

El experimento se realizó utilizando una unidad XFX Radeon RX 9070 GRE Swift de serie, sin aplicar modificaciones en la VBIOS, sistemas de refrigeración especializados ni cambios de hardware adicionales. Aunque el overclocking se mantuvo estable durante un periodo de tiempo, se registró un fallo en el controlador que provocó una recuperación inmediata tras la captura de las imágenes de prueba.

## Metodología de la prueba

Para lograr estas frecuencias, se utilizó la herramienta RTOC (R-Team OC) para el ajuste y monitoreo de la GPU. En lugar de emplear un título de juego 3D exigente, la GPU fue sometida a una carga de trabajo mediante triángulos estándar en DirectX 9. Este método, si bien no es aplicable en escenarios de uso real o en pruebas de rendimiento de videojuegos, sirve como una demostración técnica de la capacidad del silicio.

Mediante el generador de frecuencias personalizado, la GPU renderizó una escena sencilla compuesta por 2.048 triángulos por llamada de dibujo (*draw call*) y 2.048 llamadas de dibujo por cuadro, sumando un total de 4.194.304 triángulos. Esta carga de trabajo, ligera para los estándares de las tarjetas gráficas modernas, permitió mantener la frecuencia elevada de manera sostenida.

## Verificación de datos

Según el desarrollador, la lectura de 3,9 GHz se mantuvo bajo carga y no se trató de un pico momentáneo de telemetría. Asimismo, se pudo reproducir una frecuencia de aproximadamente 3,85 GHz de forma constante, incluso utilizando los controles de overclocking oficiales de AMD Radeon Software.

Para garantizar la exactitud de los resultados, se compararon los datos de GPU-Z y HWiNFO64 con la telemetría obtenida a través de las interfaces ADL y ADLX de AMD. El sistema de monitoreo RTOC realiza consultas de datos cada 2 ms, contrastando con la llegada de la telemetría de gestión de energía de AMD, que ocurre aproximadamente cada 15,5 ms.

![AMD Radeon RX 9070 GRE OC](https://www.techpowerup.com/img/GZGgUcFpmFR0fraH.jpg)
![Captura de telemetría](https://www.techpowerup.com/img/V9uwbZtCUIB3FEjR.jpg)