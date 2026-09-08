---
layout: post
title:  "Todo sobre virtualización en Proxmox"
date:   2024-10-27 19:00:00 +0000
tags: guía, tutorial, proxmox, virtualización, qemu, kvm
---

> Si realmente querés dominar el mundo de la virtualización, no te pierdas ni una palabra de esta completa guía, que además de la teoría, respaldará cosas con experiencia y pruebas de laboratorio.

Al crear una máquina virtual, los administradores de sistemas pueden acceder a un sinfín de opciones para lograr la mejor performance, estabilidad y seguridad.
En esta guía vas a aprender las bases para tener buen dominio de la virtualización, no sólo a través de la interfaz web que ofrece Proxmox, sino también mediante potentes comandos por terminal.

![creacion-de-una-vm]({{ base.url }}/assets/posts/todo-sobre-virtualizacion-en-proxmox/creacion-de-vm.png)

Cómo se puede apreciar en la imágen, existen varias pestañas. Hice un índice para explicar cada una en profundidad. Al final de cada página, tendrás un link que te lleva al post siguiente, tranquilo/a.

Este tutorial ofrecerá de ejemplo la instalación de **Windows 11 24H2**, porque es relativamente "complicado" de instalar con las debidas opciones y lograr el rendimiento máximo en cuánto almacenamiento, red y pantalla virtual.

Igualmente, no por querer instalar Windows 11 24H2 descuidaremos algún apartado de este tutorial, puesto que voy a cubrir **todo** lo que ofrece la interfaz de Proxmox (y más, mediante comandos por consola).

# Convenciones

Estas convenciones son para que puedas interpretar mejor, cuándo leas una palabra en un formato distinto del que venías leyendo.

1. `Texto en tipografía de "programador"`: Utilizo este tipo de estilo cuándo estoy escribiendo archivos de configuración u otro tipo de código.
2. ***Texto en negrita y cursiva***: Cuándo hablo de servicios, software, directorios o archivos.
3. **TEXTO EN MAYÚSCULAS**: Cuándo estoy haciendo referencia a una sección de la página. Generalmente un título que puede verse dentro de una captura de pantalla, determina "una sección".
4. **Texto en negrita**: Para indicar campos que pueden interactuar con el usuario. En la imágen del inicio del post, podrían ser **Node**, **VM ID**, **Resource Pool**, etc.
5. > Texto tipo cita: Para indicar notas (estilo "voz en off") del autor que está redactando el post.

# Diccionario

A continuación brindo un diccionario de "cosas sencillas" que debés saber conceptualmente para que no te sea tan difícil la comprensión de cosas mayores.

1. **nodo** quiere decir "servidor". Podemos decirle "servidor" a cualquier dispositivo brinde servicios, tales como redundancia (backups), sitios webs, bases de datos, aplicaciones, etc.
2. Cuándo hablamos de **clúster** o **pool**, nos referimos a un grupo de servidores, CPUs, almacenamiento, etc; que sirven para un mismo propósito en común.
3. Un **LXC** permite colocar una distribución Linux dentro de un "contenedor", casi como una VM. Esto permite aislar la máquina host del contenedor, como si fueran dos dispositivos distintos.
4. **Máquina host** se le dice al dispositivo dónde se está ejecutando algún tipo de virtualización, como un LXC o VM.
5. Cuándo digo **dispositivo**, suelo indicar no sólo PCs sino también laptops y SoCs en general, siempre y cuándo brinden la posibilidad de que le "metamos mano" (como por ejemplo, instalar un sistema operativo de nuestro gusto).

Utilizaré títulos para explicar cada opción de cada pestaña, y colocaré la opción que utilizaremos justo debajo de ese título, para los más apurados.

# Índice

> ¿No sabés como comenzar con Proxmox? Podés comenzar con este tutorial, dónde vemos sobre cómo instalar y "poner a punto" el sistema operativo: [Proxmox desde cero](#).

- [Inicio](#)
- [General]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-general %})
- [OS]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-os %})
- [System]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-system %})
- [Disks]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-disks %})
- [CPU]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-cpu %})
- [Memory]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-memory %})
- [Network](% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-network %)
- [Confirm]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-confirm %})
