---
layout: post
title:  "¿Qué hardware necesito para un homelab Proxmox?"
date:   2024-12-31 00:00:00 +0000
tags: guía, hardware, homelab, proxmox, linux, amd, intel, servidor, server
---
# Preámbulo

A día de hoy, el hardware usado es bastante asequible. En el mercado podemos encontrar distintos tipos de dueños, pero por regla general podemos decir que si el vendedor accede a probar el hardware en frente de uno, o grabar un video detallado dónde se ve el número de serie y una prueba de estrés o benchmark, estamos en un buen camino.

# Qué solicitar en las pruebas de hardware usado

Nunca debemos aceptar comprar ningún componente usado sin unas pruebas mínimas, que pueden ser cargadas en un pendrive de 8GB.

A continuación, sugiero qué pruebas correr según la pieza de hardware:

## CPU

### Programas a utilizar

#### Prime95 ([TechPowerUp](https://www.techpowerup.com/download/prime95/), [Guru3D](https://www.guru3d.com/download/prime95-download/))

En cualquiera de estos dos links conseguirán la última versión.




Esto pasará la carga de la GPU al CPU, sobretodo con modelos superiores a RX 580 / RX 5500 XT / GTX 970 / GTX 1060 6GB.

### Funciones del programa

- [Prime95](https://www.techpowerup.com/download/prime95/): Es una herramienta que carga todos los núcleos del procesador, y notifica si algún núcleo falló en las tareas que le encarga el programa.
- Superposition Benchmark: es un benchmark para tarjetas gráficas, pero puede bajarse la resolución hasta 720p. Esto pasará la carga de la GPU al CPU, sobretodo con modelos superiores a RX 580 / RX 5500 XT / GTX 970 / GTX 1060 6GB. No me parece obligatorio, pero si e

### Procedimiento

..

### Casos de fallo

..

Se debe estresar por unos 10 / 15 minutos en Prime95 (modo: Small FTT). De esta forma se pone bajo estrés al procesador y todos sus componentes (buses, memoria caché, controlador de memoria, cantidad de núcleos).

También puede ser Superposition Benchmark a 720p que no utiliza el 100% de los núcleos del procesador, y por ende éste puede alcanzar frecuencias turbo máximas.

El procesador debería correr perfectamente en ambos escenarios. Si experimentás cuelgues, cierres de aplicaciones inesperadas o fallas en algún núcleo del CPU en Prime95, descartá la compra de inmediato.

## Motherboard

Se debería probar de manera similar que en el caso del CPU. Además:

- Comprobar que los zócalos PCI-Express funcionen, conectándole alguna placa y revisando que sea detectada por el sistema operativo.
- Asegurarse de que funcionen los slots de memoria.
- Revisar por completo los puertos USB, audio y ficha de red.

## Memoria RAM

Los fallos en memoria RAM no son tan evidentes, y los no tan experimentados pueden atribuirle fallos de la PC erróneamente a otras piezas, cuándo siempre fueron las memorias.

Para descartar fallos en memoria RAM, debe correrse la prueba completa (o al menos gran parte) de [MemTest86+](#).

## Placa de video

### Programas a utilizar

#### Superposition Benchmark ([Unigine](https://benchmark.unigine.com/superposition), [TechPowerUp](https://www.techpowerup.com/download/unigine-superposition/))

Es un benchmark para tarjetas gráficas, pero puede bajarse la resolución hasta 720p.

### Funciones del programa

#### Superposition Benchmark ([Unigine](https://benchmark.unigine.com/superposition), [TechPowerUp](https://www.techpowerup.com/download/unigine-superposition/))

Con una prueba completa de Superposition Benchmark, pero a 1080p Extreme, se cargará mucho a la GPU y podremos ver si hay artifacts, cuelgues, temperaturas muy elevadas o ruidos en los ventiladores.


![captura-de-superposition-benchmark](/assets/posts/que-hardware-necesito-para-un-homelab-proxmox/captura-superposition-benchmark.png)

### Procedimiento

...

### Casos de fallo


## Fuente de poder (PSU)

La compra de fuentes usadas es más polémico, porque son piezas que sufren altibajos de la red eléctrica y el usuario muchas veces descuida su limpieza. Sin embargo, si se encuentra alguna publicación con la fuente limpia, buen detalle y fotos, puede ser una oportunidad.

Para probar que la pieza funcione bien, se debe estresar al máximo el CPU y GPU, idealmente por 30 minutos y en un ambiente con una temperatura que no sea muy baja, puesto que debería simularse un "mal escenario" para la fuente de poder.

- CPU: Prime95 (modo: Small FTT)
- GPU: Furmark a la calidad máxima

Se debería hablar con el dueño para ver si tiene componentes que consuman lo suficiente para aplicar una carga considerable en la fuente (mayor al 50% de watts que anuncia la fuente, si hablamos de una fuente 80 Plus).
