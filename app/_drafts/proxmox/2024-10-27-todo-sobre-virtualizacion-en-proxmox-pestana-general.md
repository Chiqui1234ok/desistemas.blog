---
layout: post
title:  "General • Todo sobre virtualización en Proxmox"
date:   2024-10-27 19:00:01 +0000
tags: guía, tutorial, proxmox, virtualización, qemu, kvm
hide: true
---
![creacion-de-una-vm]({{ base.url }}/assets/posts/todo-sobre-virtualizacion-en-proxmox/creacion-de-vm.png)

Paso a explicar cada opción de esta primer pestaña.

# Node

Sirve para indicar en qué servidor (nodo) se creará la máquina virtual.

## Identificar tu nodo

Para saber el nombre de tu nodo, se puede hacer de dos maneras:

1. En la interfaz web


| **Campo**                |                                                                                                                                                           **Descripción**                                                                                                                                                           |                                                                                         **Ejemplo**                                                                                         |
| -------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Node**                 |                                                                                                                                     Selecciona el nodo en el que se ubicará la máquina virtual.                                                                                                                                     |                                                                                     `xfx` (en mi caso).                                                                                     |
| **VM ID**                |                                                                                                    Es el identificador único asignado automáticamente a cada máquina virtual. Podés cambiarlo, siempre y cuándo no se repita                                                                                                    | `200` (aconsejo que los LXC comiencen por ID 100 **y las VMs con ID 200**, puesto que Proxmox organiza primero los contenedores, incluso si el LXC tiene un número más grande que la VM). |
| **Name**                 |                                                                                           Nombre de la máquina virtual, el cual se utiliza para identificarla en la interfaz de usuario. Este nombre debe ser único dentro del clúster.                                                                                           |                                                              `windows-11-24h2` (será el nombre de la VM de nuestro ejemplo).                                                              |
| **Resource Pool**        | Permite asignar la VM a un grupo de recursos o "pool", que es útil para organizar y gestionar múltiples VMs dentro de un clúster o infraestructura. En entornos pequeños, se deja vacío porque habría que crear un pool primero, algo un poco "overkill" para pequeños ambientes empresariales, dónde sólo hay una máquina. |                                                                `pruebas` (un pool que agrupa todas las VMs de laboratorio).                                                                |
| **Start at boot**        |                                                                                                                                       Permite iniciar la VM junto a otros servicios de Proxmox.                                                                                                                                       |                                                                                              -                                                                                              |
| **Start/Shutdown order** |                                                                                        Define el orden en que las máquinas virtuales se inician o apagan en el nodo, útil para gestionar dependencias entre VMs en un entorno más complejo.                                                                                        |                                                                   `1` (arranca antes que máquinas virtuales con un `2`).                                                                   |
| **Startup delay**        |                                                                               Retraso en segundos antes de que la máquina virtual se inicie después de que el sistema haya comenzado. Esto es útil para dar tiempo a que otros servicios arranquen.                                                                               |                                                    `30` (espera 30 segundos después del arranque del sistema para iniciar la máquina).                                                    |
| **Shutdown timeout**     |                                                                                               El tiempo máximo en segundos que Proxmox esperará para que la máquina virtual se apague de manera ordenada antes de forzar su apagado.                                                                                               |                                                               `60` (espera 60 segundos antes de forzar el apagado de la VM).                                                               |
| **Tags**                 |                                                                                                  Etiquetas personalizadas que se pueden agregar a la máquina virtual para facilitar la organización y búsqueda dentro de Proxmox.                                                                                                  |                                            `production`, `critical` (etiquetas que ayudan a identificar VMs de producción o de alta prioridad).                                            |

[Ir a la siguiente pestaña del creador de VM]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-os %})
