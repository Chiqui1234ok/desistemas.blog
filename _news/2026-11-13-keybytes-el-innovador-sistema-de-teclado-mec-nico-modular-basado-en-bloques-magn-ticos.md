---
layout: post
title: "Keybytes: El innovador sistema de teclado mecánico modular basado en bloques magnéticos"
description: "Keybytes es un nuevo sistema de teclado mecánico modular que utiliza unidades individuales magnéticas para una reconfiguración total."
image: https://www.techpowerup.com/img/60p4MlUE1EvWH5rH.jpg
date: 2026-11-13 18:48:06 -0300
categories: [hardware]
tags: keybytes, hardware, teclado mecánico, modding, diy
---

El ámbito de los teclados mecánicos DIY es conocido por sus diseños de nicho, y el proyecto Keybytes, desarrollado por el modder notaroomba, se presenta como una innovadora prueba de concepto. Este sistema, detallado en [GitHub](https://github.com/NotARoomba/keybytes) y [KBDnews](https://kbd.news/Keybytes-2938.html), propone una arquitectura modular diseñada para alcanzar niveles de personalización extremos.

## Arquitectura modular: Keybits y Keyword

El concepto fundamental reside en el uso de "Keybits", que son unidades individuales de sockets para interruptores mecánicos MX de altura completa. Cada Keybit cuenta con su propia placa de circuito impreso (PCB) y conectores magnéticos que permiten ensamblarlos entre sí, facilitando la creación de un teclado infinitamente reconfigurable.

El núcleo del sistema es la "Keyword", una placa base que integra el puerto USB Type-C, el circuito de carga de la batería y un microcontrolador STM32WB55. Esta placa se conecta a cada Keybit, el cual incorpora su propio microcontrolador RISC-V CH592F y mecanismos avanzados que permiten la conexión de las piezas de forma independiente a su rotación.

![Diseño del sistema Keybytes](https://www.techpowerup.com/img/60p4MlUE1EvWH5rH.jpg)

## Versatilidad y expansión técnica

El proyecto ofrece diversas opciones de personalización técnica para los entusiastas del hardware. Existen versiones de PCB alternativas que incluyen sensores Hall de tres ejes, lo que permitiría implementar funciones similares a un joystick o interruptores de efecto Hall. Asimismo, se han diseñado "Keybits" espaciadores en tamaños de 1u, 0.75u y 0.5u para permitir el paso de energía entre módulos.

En la revisión de diseño más reciente, cada Keybit dispone de seis imanes por lado y un sistema de detección automática de polaridad. Esta característica técnica permite que los interruptores se dispongan de forma alineada o con desplazamientos (offsets) del 25%, 50% o 75%, ampliando las posibilidades de diseño ergonómico y estético.

![Detalle de los módulos Keybit](https://www.techpowerup.com/img/et20Hv8UE5IeqQGv.jpg)