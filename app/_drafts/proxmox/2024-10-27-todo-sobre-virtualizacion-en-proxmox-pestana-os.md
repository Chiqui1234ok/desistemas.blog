---
layout: post
title:  "OS • Todo sobre virtualización en Proxmox"
date:   2024-10-27 19:00:01 +0000
tags: guía, tutorial, proxmox, virtualización, qemu, kvm
hide: true
---

![Opciones de sistema operativo](/assets/posts/todo-sobre-virtualizacion-en-proxmox/opciones-de-sistema-operativo.png)

Si estamos instalando sistemas que no sean GNU/Linux, una de las pestañas más importantes es la del sistema operativo. La razón es simplemente que, quitando las distribuciones que utilizan el kernel Linux, la mayoría de sistemas operativos no poseen controladores para hardware virtual, tales como:
- VirtIO para tener alta performance de tu almacenamiento
- SPICE para tener una decente experiencia gráfica
- Gestión de memoria y archivos de paginación inteligente
- Interfaz de red VirtIO, de 10Gbit