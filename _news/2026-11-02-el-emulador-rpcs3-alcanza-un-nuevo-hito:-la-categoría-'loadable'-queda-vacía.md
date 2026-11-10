---
layout: post
title: "El emulador RPCS3 alcanza un nuevo hito: la categoría 'Loadable' queda vacía"
description: "El emulador RPCS3 logra vaciar la categoría 'Loadable', marcando un avance clave en la compatibilidad de la biblioteca de PlayStation 3."
image: https://www.techpowerup.com/img/ZOtqdB3soU6oQx5Y.jpg
date: 2026-11-02 21:05:52 -0300
categories: [gaming, hardware]
tags: rpcs3, ps3, emulacion, gaming, hardware
---

El equipo de desarrollo de RPCS3 ha anunciado que su emulador de PlayStation 3 ha logrado vaciar por completo la categoría de compatibilidad denominada "Loadable". Según se informa en una [publicación en X](https://x.com/rpcs3/status/2116556484754473413), el título *Tom Clancy's H.A.W.X. 2* ha pasado a la categoría "Ingame" tras implementarse una corrección de precisión en la SPU realizada por el colaborador Yahfz.

Este título representaba el último elemento en la lista de "Loadable", una sección reservada para aquellos juegos que únicamente muestran una pantalla negra acompañada de un contador de fotogramas en la ventana del título. La solución técnica aplicada es de alta complejidad: RPCS3 ahora recrea el cargador de hilos de la SPU y los argumentos que el kernel LV2 de la PlayStation 3 deja en el Local Store al inicio de cada grupo de SPU, antes de que se cargue la imagen del código. Según los desarrolladores, este procedimiento evita la corrupción del cargador.

Es importante señalar que el estado "Ingame" indica que el juego logra ejecutarse, pero no garantiza una experiencia plenamente jugable. Los títulos en esta categoría aún pueden presentar errores gráficos graves o un rendimiento deficiente.

## Evolución de la compatibilidad de RPCS3

![Captura de pantalla de RPCS3](https://www.techpowerup.com/img/ZOtqdB3soU6oQx5Y.jpg)

Aunque el equipo de RPCS3 ya había logrado vaciar esta lista anteriormente a principios de 2023, la categoría se había vuelto a llenar con el tiempo. En informes de [compatibilidad de RPCS3](https://www.techpowerup.com/350834/rpcs3-emulator-now-plays-75-of-ps3-game-library-on-pc) publicados en julio, apenas el 0,06 % de la biblioteca se encontraba en el estado "Loadable".

![Interfaz de emulación](https://www.techpowerup.com/img/nMDfMrDEnzCjVh4f.jpg)

El progreso general del emulador es notable, con un incremento en la categoría "Playable" que ha pasado del 75 % al 80 % en los últimos meses. Por su parte, la categoría "Intro" mantiene aproximadamente 22 títulos, muchos de los cuales dependen de la tecnología PS Move, lo que representa el próximo desafío técnico para el proyecto.

![Progreso de compatibilidad](https://www.techpowerup.com/img/znPicCgXihENTYO1.jpg)