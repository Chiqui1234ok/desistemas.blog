---
layout: post
title: "Qualcomm valida su tecnología HBC de alto ancho de banda; las primeras muestras llegarán en 2027"
description: "Qualcomm valida su arquitectura HBC, que utiliza memoria LPDDR apilada para mejorar la eficiencia energética en procesos de IA."
image: https://tpucdn.com/img/MXEl7cU2DLxb2odz.jpg
date: 2026-11-02 13:11:21 -0300
categories: [hardware, analisis]
tags: qualcomm, hbc, lpddr, hbm, hardware, inteligencia artificial
---

Qualcomm ha validado oficialmente su concepto de High Bandwidth Compute (HBC), tecnología que la compañía [presentó](https://www.techpowerup.com/350281/qualcomm-hbc-gen-1-achieves-133-tb-s-bandwidth-by-stacking-lpddr-memory) durante el verano pasado. En lugar de utilizar los métodos tradicionales de HBM y dies de computación independientes, la empresa ha desarrollado una tecnología que apila múltiples capas de LPDDR e integra un die base que funciona como motor de cómputo para la inferencia de inteligencia artificial.

En los laboratorios de Qualcomm en San Diego, la primera generación de HBC ha alcanzado la validación de silicio, demostrando capacidades completas de lectura, escritura y computación cercana a la memoria (*near-memory computation*). La arquitectura HBC utiliza memoria LPDDR organizada en un apilamiento vertical 3D, interconectada mediante vías a través del silicio (TSVs). Este enfoque proporciona una mayor eficiencia energética que la HBM tradicional, dado que los chips LPDDR consumen menos energía mientras ofrecen un ancho de banda y capacidad similares.

## Optimización del movimiento de datos

La técnica consiste en apilar múltiples capas de LPDDR sobre un die de cómputo base, el cual realiza operaciones de cómputo cerca de la memoria y delega el procesamiento a los dies adyacentes. Si bien este método presenta similitudes con el funcionamiento de la memoria HBM4 —donde el die base actúa como una capa lógica para mejorar la integración de soluciones de cómputo para el rastreo de paquetes y la preparación de datos—, Qualcomm busca alcanzar una eficiencia superior.

El objetivo de la compañía es lograr un incremento de seis veces en el ancho de banda por vatio en comparación con las especificaciones actuales de HBM. Al posicionar el cómputo directamente debajo de los stacks de memoria, se logra que los datos viajen solo unos pocos micrómetros en lugar de varios centímetros, optimizando drásticamente el movimiento de la información dentro del sistema.

![Arquitectura de Qualcomm HBC](https://tpucdn.com/img/MXEl7cU2DLxb2odz.jpg)