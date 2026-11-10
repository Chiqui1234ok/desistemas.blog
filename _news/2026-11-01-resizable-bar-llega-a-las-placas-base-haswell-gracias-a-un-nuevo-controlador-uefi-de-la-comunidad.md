---
layout: post
title: "Resizable BAR llega a las placas base Haswell gracias a un nuevo controlador UEFI de la comunidad"
description: "Un nuevo controlador de código abierto, reBART, permite habilitar Resizable BAR en plataformas Intel de la serie 8, revitalizando hardware antiguo."
image: https://tpucdn.com/img/nw7rKfRGHl5Ucby2_thm.jpg
date: 2026-11-01 16:09:34 -0300
categories: [hardware, gaming]
tags: intel, haswell, resizable bar, rebar, placa base, uefi, rebart
---

Los usuarios de plataformas Intel Haswell cuentan ahora con una vía para ejecutar Resizable BAR en placas base de la serie 8. Según ha informado [Haze en X](https://x.com/Haze2K1/status/2116869037594423516), el desarrollador conocido como roschank ha lanzado [reBART](https://github.com/roschank/reBART), un controlador UEFI de código abierto compatible con placas Z87, H87, Q87, B85, Q85 y H81.

Desde el año 2020, se había señalado que las CPU Intel desde la arquitectura Haswell admiten Resizable BAR, aunque la implementación dependía de actualizaciones de firmware por parte de los fabricantes de placas base, las cuales nunca llegaron para la serie 8. El desarrollador identificó que el código de la plataforma Intel de la serie 8 omite por completo el mapeo de memoria por encima de los 4 GB, una función que sí gestionan los firmwares de las series 7 y 9. Debido a este vacío técnico común en todos los fabricantes consultados, la opción de "Above 4G Decoding" presente en algunos BIOS resultaba ineficaz.

## Funcionamiento de reBART

El controlador reBART permite que la placa base realice el arranque de forma convencional para intervenir justo antes de que se cargue el sistema operativo. En ese momento, desplaza la ventana de memoria de la GPU por encima de la línea de los 4 GB y redirige la visualización de arranque a la nueva ubicación. A diferencia de [ReBarUEFI](https://www.techpowerup.com/318868/rebaruefi-is-a-boot-time-module-that-enables-resizable-bar-on-some-older-platforms), esta solución no requiere el parcheo de módulos, aunque sigue siendo necesario aplicar un parche DSDT.

Las versiones más recientes han incorporado soporte experimental para tarjetas Intel Arc y configuraciones de múltiples GPU. Este avance es significativo, dado que en su lanzamiento, Intel recomendó a los usuarios de tarjetas Arc evitar plataformas que carecieran de ReBAR. Según informa [un usuario](https://github.com/xCuri0/ReBarUEFI/issues/11#issuecomment-5888095068), tanto una Arc A750 como una Arc B580 funcionan con un tamaño de BAR ilimitado en una placa Gigabyte GA-Z87M-D3H bajo el sistema operativo Ubuntu.

## Consideraciones de riesgo

Es importante señalar que este procedimiento implica el flasheo de un BIOS modificado. Se han reportado dificultades técnicas, como en el caso de [un propietario de una ASUS Z87-Plus](https://winraid.level1techs.com/t/offer-rebart-resiz-bar-module-for-intel-8-series-mbs/118708) que no logró que la placa arrancara tras aplicar el parche DSDT. Por el momento, el desarrollador no ha publicado datos oficiales sobre las mejoras de rendimiento obtenidas mediante este método.

![GPU en placa base](https://tpucdn.com/img/N5v1lAcIpRA9An7M_thm.jpg)