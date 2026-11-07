---
layout: post
title: "La AMD Radeon RX 9070 GRE alcanza los 3.9 GHz mediante una carga de trabajo personalizada en DirectX 9"
description: "Un usuario logra un overclock estable de 3.9 GHz en la Radeon RX 9070 GRE utilizando herramientas personalizadas y cargas de trabajo ligeras."
image: https://www.techpowerup.com/img/GZGgUcFpmFR0fraH.jpg
date: 2026-10-31 12:55:47 -0300
categories: [hardware]
tags: [amd, radeon, overclocking, gpu, rx 9070 gre, hardware]
---

La tarjeta gráfica AMD Radeon RX 9070 GRE ha alcanzado oficialmente una frecuencia de 3.9 GHz bajo condiciones de prueba muy específicas. Este hito fue logrado por el usuario "ShrimpBrime" en los foros de TechPowerUp, quien desarrolló herramientas personalizadas para unidades de procesamiento gráfico Radeon denominadas "R-Team OC" y "GPU Frequency Generator".

El experimento se realizó utilizando una GPU XFX Radeon RX 9070 Swift de fábrica, sin recurrir a modificaciones de la VBIOS, sistemas de refrigeración especializados u otros cambios de hardware. Aunque el overclock se mantuvo estable durante un periodo de tiempo, se registró un fallo del controlador que se recuperó poco después de la captura de las imágenes de prueba.

## Metodología y carga de trabajo

Para lograr estas frecuencias, se utilizó la herramienta de ajuste y monitoreo RTOC. En lugar de emplear un título de juegos 3D exigente, la GPU fue sometida a una carga de trabajo compuesta por triángulos regulares en DirectX 9. Este enfoque convierte el resultado en una prueba de concepto técnica más que en un rendimiento aplicable a escenarios de uso real o gaming convencional.

Mediante el generador de frecuencia personalizado basado en DirectX 9, la GPU renderizó una escena simplificada que consistía en 2,048 triángulos por llamada de dibujo (draw call) y 2,048 llamadas de dibujo por fotograma, lo que suma un total de 4,194,304 triángulos. Si bien esta tarea es mínima para los estándares de las tarjetas gráficas modernas, resultó suficiente para mantener la alta frecuencia solicitada.

## Verificación de datos y telemetría

Según el desarrollador, la lectura de 3.9 GHz se mantuvo constante bajo carga, evitando ser un simple pico momentáneo de telemetría. Asimismo, se logró reproducir de forma repetida una frecuencia de aproximadamente 3.85 GHz utilizando los controles de overclocking oficiales del software Radeon de AMD.

Para garantizar la precisión de las mediciones, se realizó una comparación entre los datos de GPU-Z y HWiNFO64 frente a la telemetría recopilada a través de las interfaces ADL y ADLX de AMD. La herramienta RTOC realiza consultas de datos de monitoreo cada 2 ms, aunque se informó que la telemetría más reciente sobre la gestión de energía llega aproximadamente cada 15.5 ms.

![Captura de frecuencia de la Radeon RX 9070 GRE](https://www.techpowerup.com/img/GZGgUcFpmFR0fraH.jpg)
![Detalle de telemetría de la GPU](https://www.techpowerup.com/img/V9uwbZtCUIB3FEjR.jpg)
![Pruebas de estabilidad en DirectX 9](https://www.techpowerup.com/img/bVGR1wLQMKjErOCc.jpg)
![Resultados de monitoreo de hardware](https://www.techpowerup.com/img/KxfRQUnDajDzpOLG.jpg)