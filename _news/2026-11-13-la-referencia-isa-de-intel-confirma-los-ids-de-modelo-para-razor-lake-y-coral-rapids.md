---
layout: post
title: "La referencia ISA de Intel confirma los IDs de modelo para Razor Lake y Coral Rapids"
description: "Nuevas actualizaciones en la documentación de Intel revelan detalles técnicos sobre las próximas arquitecturas Razor Lake y Coral Rapids."
image: https://www.techpowerup.com/img/dAUZ3wXKDH00xQZj.jpg
date: 2026-11-13 16:51:02 -0300
categories: [hardware]
tags: intel, razor lake, coral rapids, arquitectura, procesadores
---

Intel ha incorporado las arquitecturas Razor Lake y Coral Rapids en la edición de noviembre de su [Architecture Instruction Set Extensions Programming Reference](https://cdrdv2-public.intel.com/932753/319433-063-architecture-instruction-set-extensions-programming-reference.pdf). 

> Nota del autor: recordemos que "ISA" se refiere a Instruction Set Architecture, y son el set de instrucciones instalado en el microprocesador.

Este documento es la herramienta de referencia que utilizan los desarrolladores para preparar el software compatible con los próximos lanzamientos de procesadores de la compañía.

## Identificación de modelos para Razor Lake y Coral Rapids

La revisión 063 de este documento asigna a Razor Lake cuatro nuevos valores de modelo dentro de la familia 18 (12H), la misma arquitectura que Nova Lake. Los identificadores 12_06H y 12_0AH corresponden a las variantes destinadas a equipos de escritorio, mientras que 12_07H y 12_09H cubren los modelos para ordenadores portátiles. 

En cuanto a la línea Xeon, la familia Coral Rapids ha recibido el identificador 13_08H, posicionándose de forma sucesiva a Diamond Rapids (13_01H).

## Mejoras en las capacidades de hardware

Las nuevas entradas de funciones presentan actualizaciones específicas para cada arquitectura. Razor Lake incorpora SSBD_PSFD_U_S, una característica que parece permitir un control diferenciado entre los modos de usuario y de supervisor sobre ciertos comportamientos de la memoria especulativa. Asimismo, ambas familias han ganado soporte para la virtualización del temporizador APIC, optimizada para entornos de máquinas virtuales.

Por su parte, la familia Coral Rapids incluye la nueva instrucción VPMLDSABFLYDQ, la cual está diseñada para el estándar de firma digital resistente a la computación cuántica, ML-DSA.

## Especificaciones del conjunto de instrucciones (ISA)

Según se observa en [parches de GCC para Intel](https://www.phoronix.com/news/Intel-GCC-Coral-Rapids-Razor) publicados esta semana, Razor Lake parece mantener el mismo conjunto de instrucciones (ISA) que Nova Lake. Esto implicaría que las tecnologías AVX10.2 y APX se trasladan a esta nueva arquitectura, aunque la referencia técnica aún no los ha listado explícitamente en sus filas correspondientes. 

Respecto a Coral Rapids, la arquitectura se mantendrá con el conjunto AVX10.2 en lugar de la versión más reciente, AVX10.3, al menos en esta etapa del desarrollo.