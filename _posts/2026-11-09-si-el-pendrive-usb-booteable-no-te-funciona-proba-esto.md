---
layout: post
title:  "Si el USB booteable con Rufus / Ventoy no te funciona, mirá esta solución • Disco con una pequeña partición"
description: "En este post se enseñan varios problemas y cómo se pueden solucionar con una sola receta: disco SATA directo al motherboard y una configuración especial en Ventoy"
date:   2026-11-09 20:53:00 -0300
categories: [hardware]
tags: pendrive, booteable, rufus, ventoy, disco usb, disco sata
---

# Introducción

![PC con motherboard Biostar TA790GX A3+, con problemas para instalar desde USB 3.0]({{ base.url }}/assets/posts/si-el-pendrive-usb-booteable-no-te-funciona-proba-esto/pc-biostar-ta790gx-a3.png)

Si se está en presencia de una máquina vieja como la de la foto (BIOS legacy) y se experimentan problemas como los siguientes, en este post se explica la solución:

1) Nunca carga el instalador del sistema operativo (común en Ventoy).

2) Parece instalarse Windows, pero al reiniciar pareciera que no hay bootloader y no carga el SO.

3) El instalador de Linux termina instalandose en el disco dónde está Ventoy, y no en el equipo destino (esto me sucedió con Xubuntu 16 y 18).

4) El medio USB con el instalador del SO no es detectado por la PC (más común con pendrives 3.0).

Estos comportamientos inesperados anteriormente son comunes cuándo dos o más de estas condiciones se combinan:

5) El disco de Ventoy tiene un tamaño superior a 32/64GB.

6) Rufus anuncia que el ISO que va a escribir podría arrojar un error de Secure Boot, a pesar de que la imágen se descargó de un sitio web oficial / confiable y se está seleccionando MBR sin Secure Boot.

7) La PC destino es BIOS legacy y no UEFI.

8) El equipo detecta sólo pendrives USB 2.0 y la velocidad de instalación es lenta.

# Solución definitiva (una para todos)

Es importante utilizar un disco SATA, para eliminar cualquier problema introducido por el uso de USBs e incompatibilidad de la BIOS.

Por ejemplo, nuestro salvador es disco de notebook Samsung Spinpoint 250GB de 2,5".

![Samsung Spinpoint 250GB]({{ base.url }}/assets/posts/si-el-pendrive-usb-booteable-no-te-funciona-proba-esto/samsung-spinpoint-250gb.png)

Teniendo ya preparada la ISO que se desea utilizar en la PC destino que requiere instalación de sistema operativo, se deben seguir estos pocos pasos desde un equipo que ya tenga Windows o Linux instalado:

1) Descargar Ventoy para Windows/Linux desde [SourceForge](https://sourceforge.net/projects/ventoy/files/).

2) Conectar el disco SATA al equipo, mediante el mismo SATA o mediante un adaptador USB a SATA (si es más cómodo).

3) Descomprimir Ventoy (archivo **ventoy-[version].zip**).

4) Abrir Ventoy2Disk, dirigirse a la pestaña "Option" y dejar las opciones:
- Secure boot support: desmarcado.
- "Partition Style": MBR.

Se adjunta captura:

![ventoy-options]({{ base.url }}/assets/posts/si-el-pendrive-usb-booteable-no-te-funciona-proba-esto/ventoy-options.png)

> En caso de que Ventoy no vea el disco que se debe usar para colocar la ISO del instalador, se debe presionar también el item "Show all devices".

5) En la misma pestaña "Option", se debe hacer clic en "Partition Configuration". La capacidad usable debe ser de 32GB, para estar en un rango seguro extremadamente compatible. En el caso del tutorial, el disco de 250GB tiene 232GB en Windows, por ende se va a escribir en el campo "Preserve some space at the end of the disk" el número 200 y presionar el botón OK.

> Se utiliza el número 200, porque 232GB de fábrica menos 200GB de espacio al final del disco son 32GB **usables** exactos.

![Se redimensiona el disco de Ventoy a 32GB]({{ base.url }}/assets/posts/si-el-pendrive-usb-booteable-no-te-funciona-proba-esto/ventoy-redimensionar-a-32gb.png)

6) Se presiona el botón "Install" en la pantalla original de Ventoy, y se espera la instalación en el disco.

7) Se coloca la imágen ISO en la raíz del disco que acaba de recibir su instalación de Ventoy.

> En la prueba del tutorial se colocó sólo **una** imágen ISO.

8) Se conecta el disco en la máquina que requiere instalación de sistema operativo, se elije este nuevo disco conectado como booteo desde la BIOS y se espera al arranque de Ventoy (la BIOS suele mostrar el string "VTLoading...").

9) Una vez dentro de Ventoy, se selecciona la ISO del instalador... ¡y voilá! 💃

![Instalador de Windows iniciando (gif)]({{ base.url }}/assets/posts/si-el-pendrive-usb-booteable-no-te-funciona-proba-esto/instalador-de-windows.gif)

# Conclusión

La IA me había dicho que Ventoy no tenía memoria para cargar la ISO del disco, y por eso el instalador de Windows 10 nunca aparecía. Al menos en este caso (Phenom II X4, Biostar TA790GX A3+, 2 x 2GB Kingston HyperX), ese no era el problema.

La detección del pendrive 3.2 de cabecera fue imposible en este equipo. Usualmente para estos casos utilizo un disco USB 2.0, pero la velocidad se limita a 35~40MB/s.

Por otro lado usando Rufus como programa para hacer el medio booteable, la primer parte de instalación de Windows se realizaba de forma aparentemente correcta en el equipo destino, pero luego de que el instalador pedía el reinicio el equipo parecía no tener el bootloader correctamente instalado.

En el camino de querer acelerar la instalación de Windows en estos equipos aún competentes, me encontré con un problema y acá se expuso la solución.

¡Un saludo! Ojalá sea un post de utilidad.