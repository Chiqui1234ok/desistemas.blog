---
layout: post
title:  "Averigüar el init del sistema • Linux"
date:   2025-02-26 19:00:01 -0300
categories: [linux]
tags: linux, init, systemd, sysvinit, tutorial
---

# Preámbulo

Las distribuciones Linux tienen un amplio repertorio de opciones para los sistemas init / daemon, y mediante esta pieza de software se lanzan programas de forma ordenada durante el final del [proceso de booteo](#).

# Cómo averiguar el init del sistema

Luego de que el bootloader selecciona el ramdisk y lo carga, el proceso de booteo llega a la etapa final con el init.

Si bien se puede ver qué init se está ejecutando con ***ps*** y añadiendo unas opciones a éste, no todas las distribuciones poseen la versión completa de este programa.

La solución más sencilla es averiguar a qué apunta **/sbin/init**:

```bash
ls -l /sbin/init
```

Esto debería arrojar un resultado como el siguiente, indicando que hay un enlace a ***systemd***.

```bash
lrwxrwxrwx 1 root root 20 Dec  1 10:28 /sbin/init -> /lib/systemd/systemd
```

Sin embargo, en otros sistemas operativos puede suceder que el "init" no apunte a nada, porque es el ejecutable mismo (y no un link). Esto sucede en OpenWRT, por ejemplo, y no se conseguirá averigüar lo deseado dentro de **/sbin**.
Sin embargo, las posibilidades de que sea un init basado en "rc" son altas. Esto puede averiguarse con el comando:

```bash
ls -l /etc | grep 'rc'
```

Esto mostrará los directorios que incluyan "rc" en la carpeta **etc** (dónde se guardan las configuraciones de todo el software de Linux). En el caso de realizar este comando en OpenWRT, la salida será:

```bash
drwxr-xr-x    2 root     root            85 Sep 23 09:34 rc.button
-rwxr-xr-x    1 root     root          3552 Sep 23 09:34 rc.common
drwxr-xr-x    1 root     root          1024 Feb 24 23:07 rc.d
-rw-r--r--    1 root     root           132 Sep 23 09:34 rc.local
```

De esta forma, se confirma que el sistema utiliza un iniciador basado en RC.

# Epílogo

La conclusión es que ahora el administrador de sistemas podrá, frente a una máquina que utilice una distribución basada en Linux, averiguar su daemon / init de forma fácil y rápida.