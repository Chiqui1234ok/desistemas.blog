---
layout: post
title: "Intel presenta los resultados de rendimiento de su GPU D270 'Crescent Island' frente a NVIDIA"
description: "Intel revela benchmarks de la GPU D270, destacando su superioridad en cargas financieras FP64 frente a la serie RTX PRO de NVIDIA."
image: https://www.techpowerup.com/img/p8YBsPO7J3RC5W1f.jpg
date: 2026-11-17 12:16:01 -0300
categories: [hardware, analisis]
tags: intel, gpu, d270, crescent island, nvidia, benchmark, fp64, inteligencia artificial
---

Intel ha publicado los primeros resultados de rendimiento de su acelerador de IA D270, anteriormente denominado [“Crescent Island”](https://www.techpowerup.com/351901/intel-details-crescent-island-graphics-32-xe3p-cores-up-to-480-gb-lpddr5x-memory). Según los datos proporcionados por [Intel](https://www.intel.com/content/www/us/en/newsroom/news/data-center/why-intel-gpu-d270-belongs-in-the-hpc-conversation.html), esta GPU es hasta 5,9 veces más rápida que la [NVIDIA RTX PRO 6000 Blackwell](https://www.techpowerup.com/351549/nvidia-rtx-pro-6000-blackwell-96-gb-gpu-now-costs-usd-16-000) en cargas de trabajo financieras de precisión FP64.

## Rendimiento en cómputo financiero y eficiencia

Durante la presentación en el evento SC26 en Chicago, se detallaron métricas específicas donde el sistema D270 mostró una ventaja de 5,6x en el modelo European Black-Scholes, 4,6x en Binomial y 1,92x en American Black-Scholes. Un aspecto destacado es la eficiencia energética: mientras que la D270 opera con un consumo de 350 W, la NVIDIA RTX PRO 6000 posee un límite de potencia de 600 W.

Este rendimiento se atribuye principalmente a la arquitectura de los [32 núcleos Xe3P](https://www.techpowerup.com/354171/intel-crescent-island-gpu-die-shows-up-32-xe3p-cores-and-256-xmx-engines) de la unidad, cada uno de los cuales gestiona 64 operaciones FP64 FMA a una tasa nativa completa.

## Capacidades de Inteligencia Artificial

En cuanto a las métricas de inteligencia artificial, los resultados presentan márgenes menos amplios. Intel afirma haber logrado una latencia hasta un 29% menor en el modelo de decisión Drex y un incremento de 1,12x en el throughput de tokens de salida en el modelo Qwen3-30B-A3B utilizando FP8. En estas pruebas de IA, la comparativa se realizó frente a una única unidad RTX PRO 6000.

Es importante señalar que, en las pruebas financieras mencionadas anteriormente, el sistema de NVIDIA utilizaba ocho tarjetas RTX PRO 6000 frente a una sola unidad D270, aunque la compañía no ha especificado la cantidad exacta de tarjetas utilizadas en cada ejecución. Asimismo, se presentó el modelado sísmico en FP32 con Veridien, aunque no se revelaron las cifras de rendimiento para este caso.

## Especificaciones de memoria y disponibilidad

Todos los resultados obtenidos provienen de silicio en fase de preproducción, por lo que representan escenarios de rendimiento optimizados. La GPU D270 "Crescent Island" tiene la capacidad de integrar [hasta 480 GB de memoria](https://www.techpowerup.com/353647/intel-crescent-island-gpu-gets-d-series-name-supports-up-to-480-gb-of-lpddr5x), si bien las tarjetas comerciales de Intel vendrán con 160 GB de LPDDR5X como estándar. Por el momento, no se ha anunciado una fecha oficial de lanzamiento ni su precio de venta.