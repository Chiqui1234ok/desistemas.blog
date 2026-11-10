---
layout: post
title: "Un nuevo controlador UEFI permite habilitar Resizable BAR en placas base Intel Haswell"
description: "Un desarrollador independiente lanza reBART, permitiendo que plataformas antiguas de la serie 8 de Intel aprovechen la tecnología Resizable BAR."
image: https://tpucdn.com/img/nw7rKfRGHl5Ucby2_thm.jpg
date: 2026-11-01 16:09:34 -0300
categories: [hardware, gaming]
tags: intel, haswell, rebar, uefi, motherboard, rebart
---

Los usuarios de procesadores Intel de la arquitectura Haswell disponen finalmente de un método para ejecutar Resizable BAR en placas base de la serie 8 de Intel. Según se ha informado a través de [Haze en X](https://x.com/Haze2K1/status/2116869037594423516), un desarrollador bajo el alias de roschank ha publicado [reBART](https://github.com/roschank/reBART), un controlador UEFI de código abierto compatible con placas Z87, H87, Q87, B85, Q85 y H81.

Aunque se había reportado anteriormente que los procesadores Intel desde la arquitectura Haswell soportan Resizable BAR, la implementación dependía de actualizaciones de firmware por parte de los fabricantes de placas base, las cuales nunca llegaron para la serie 8. El desarrollador identificó que el código de la plataforma de la serie 8 de Intel omite el mapeo de memoria por encima de los 4 GB, una función que sí gestionan los firmwares de las series 7 y 9. Debido a este vacío estructural heredado por la mayoría de los fabricantes, la opción de "Above 4G Decoding" presente en algunos BIOS no cumple ninguna función real.

## Funcionamiento de reBART

El controlador reBART permite que la placa base inicie de forma normal y solo entra en acción justo antes de que el sistema operativo se cargue. En ese momento, desplaza la ventana de memoria de la GPU por encima de la línea de los 4 GB y redirige la visualización de arranque a la nueva ubicación. A diferencia de [ReBarUEFI](https://www.techpowerup.com/318868/rebaruefi-is-a-boot-time-module-that-enables-resizable-bar-on-some-older-platforms), este método no requiere el parcheo de módulos, aunque sigue siendo necesario realizar un parche DSDT.

Las versiones más recientes han incorporado soporte experimental para tarjetas Intel Arc y configuraciones de múltiples GPUs. Esto resulta relevante dado que, en el pasado, la propia Intel recomendó a los usuarios de tarjetas Arc evitar la marca si carecían de soporte para ReBAR. Un usuario ha reportado el funcionamiento exitoso de modelos Arc A750 y Arc B580 con un tamaño de BAR ilimitado en una placa Gigabyte GA-Z87M-D3H bajo el sistema operativo Ubuntu.

## Riesgos y consideraciones técnicas

Es importante señalar que este procedimiento requiere el flasheo de un BIOS modificado. Se han reportado casos de riesgo, como el de un usuario de una placa ASUS Z87-Plus que no logró iniciar el sistema tras aplicar el parche DSDT. Hasta la fecha, el desarrollador no ha proporcionado métricas oficiales sobre la mejora de rendimiento obtenida mediante este método.

![Placa base y componentes](https://tpucdn.com/img/N5v1lAcIpRA9An7M_thm.jpg)