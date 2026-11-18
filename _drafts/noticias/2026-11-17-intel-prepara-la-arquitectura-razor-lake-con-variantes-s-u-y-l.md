---
layout: post
title: "Intel prepara la arquitectura 'Razor Lake' con variantes S, U y L"
description: "Nuevos parches del kernel de Linux revelan la existencia de múltiples versiones de la próxima plataforma Razor Lake de Intel."
image: https://www.techpowerup.com/img/cW8gRpFerVSzceJw.jpg
date: 2026-11-17 13:27:26 -0300
categories: [hardware, analisis]
tags: intel, razor lake, cpu, arquitectura, hardware, kernel linux
---

## Detalles sobre la nueva plataforma de Intel

Nuevos parches en el kernel de Linux sugieren que Intel está preparando tres versiones distintas de su próxima plataforma "Razor Lake", designadas con los sufijos S, U y L. Según la información recopilada, existe además un identificador de procesador para "Razor Lake" sin sufijo, lo que suma un total de cuatro variantes detectadas en el código.

El ingeniero de Intel, Tony Luck, presentó estos parches tras la publicación de los números de modelo en la referencia actualizada del conjunto de instrucciones de la compañía. Todos los modelos cliente pertenecen a la Familia de CPU 18. Los modelos de sobremesa utilizan los identificadores 0x06 y 0x0A para "Razor Lake" y "Razor Lake-S", respectivamente. Por su parte, las variantes móviles asignan el identificador 0x07 a "Razor Lake-L" y el 0x09 a "Razor Lake-U". Cabe destacar que en esta entrega no se ha definido una variante "Razor Lake-H".

![Arquitectura de Intel](https://www.techpowerup.com/img/cW8gRpFerVSzceJw.jpg)

## Especificaciones y compatibilidad de instrucciones

El trabajo realizado en el compilador GCC, publicado el mismo día, aporta detalles adicionales sobre la arquitectura. Inicialmente, el compilador trata a "Razor Lake" como un alias de "Nova Lake". Ambos objetivos comparten las capacidades de instrucciones listadas en el parche, incluyendo AVX10.2 y APX.

Aunque esta información permite a los desarrolladores conocer qué instrucciones puede generar el compilador, todavía existe incertidumbre sobre los cambios potenciales en el diseño de los núcleos, la capacidad de la caché o el rendimiento final. El perfil compartido en el compilador no permite determinar con precisión qué tan similares serán los procesadores terminados entre sí.

![Detalle técnico](https://www.techpowerup.com/img/BClHZmjpLbjowldC.jpg)