---
layout: post
title: "Intento de revivir SkyOC: un mod de BIOS busca habilitar el overclocking BCLK en CPUs Intel bloqueadas"
description: "Un entusiasta busca recuperar la tecnología SkyOC mediante una modificación de BIOS para overclockear procesadores Intel no-K vía BCLK."
image: https://www.techpowerup.com/img/MPLHYFEoHkIB2UsK.jpg
date: 2026-11-16 21:03:01 -0300
categories: [hardware]
tags: intel, asrock, overclocking, bios, skyoc, bclk, z390
---

En 2015, ASRock introdujo [SkyOC](https://www.techpowerup.com/218376/asrock-unveils-sky-oc-technology), una funcionalidad que permitía a los usuarios realizar overclocking en procesadores Intel de la serie no-K (bloqueados) mediante el ajuste del BCLK (Base Clock). Este método de modificación de BIOS podría estar regresando de manera no oficial gracias al trabajo de descompilación realizado por el creador español [Hardware 360°](https://x.com/360_Hardware/status/2122284914380841367).

A través de su cuenta en X, el desarrollador informó sobre la creación de un BIOS modificado para su placa base ASUS ROG Maximus XI Extreme Z390, utilizando herramientas de inteligencia artificial para asistir en el proceso. La modificación busca portar la característica SkyOC desde las placas base de ASRock de aquella época, empleando firmware obtenido de periodos anteriores y posteriores a la retirada de dicha función por parte del fabricante. Históricamente, Intel mostró su desaprobación ante el overclocking BCLK en CPUs de arquitectura Skylake mediante el uso de SkyOC.

## El funcionamiento técnico de SkyOC

El objetivo fundamental de este BIOS modificado es permitir que los procesadores Intel no-K se sometan a overclocking mediante BCLK sin desestabilizar el resto de los componentes del sistema. Habitualmente, el incremento del BCLK eleva las frecuencias de toda la placa base, afectando negativamente a la memoria RAM, los buses PCIe y otros periféricos. Para mitigar esto, Intel implementó un límite de seguridad: si el sistema detecta un BCLK superior a 103 MHz (frente a los 100 MHz estándar), el procesador se apaga automáticamente.

La tecnología SkyOC lograba eludir esta restricción enviando al procesador una lectura falsa del BCLK. Esta práctica llevó a que Intel solicitara a ASRock la eliminación de la función a principios de 2016 mediante una actualización de microcódigo. Aunque Hardware 360° afirma haber implementado SkyOC en su placa base mediante estas modificaciones, todavía no se han publicado resultados técnicos definitivos que confirmen el éxito de la operación.

![Imagen de hardware](https://www.techpowerup.com/img/yU34f7Svp0QuKhJC.jpg)