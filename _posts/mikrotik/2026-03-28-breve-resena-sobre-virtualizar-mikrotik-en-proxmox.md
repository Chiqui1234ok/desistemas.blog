---
layout: post
title:  "Breve reseña sobre virtualizar MikroTik • Proxmox"
date:   2026-03-28 12:32:00 +0300
tags: mikrotik, reseña, review, proxmox, bridges, vmbr, sin internet, sin red, no red
---

# Preámbulo

Este post está escrito para responder un problema puntual. De esos que uno puede pasarse días preguntandole a una IA, yendo en círculos y volviendose loco por no poder resolver. Si querés configurar un troncal en un MikroTik Router OS virtualizado sin éxito, este es tu post.

# Setup de pruebas

Para reproducir este error, utilicé el siguiente setup:

- SO: Proxmox VE 8.4.17
- Kernel: 6.8.12-20-pve #1 SMP PREEMPT_DYNAMIC PMX 6.8.12-20 (2026-03-13T08:15Z) x86_64 GNU/Linux
- NIC1: Intel I218V
    - **lspci** Intel Corporation Ethernet Connection (2) I218-V (rev 05)
- NIC2 (no se usó): Qualcomm Atheros Killer E2200
    - **lspci** Qualcomm Atheros Killer E220x (rev 10)
- Varias NICs virtuales, creadas como bridges VLAN aware. Se hicieron pruebas creando bridges OVS-Switch y nativos de Linux
- Se implementaron VLANs en la pestaña "Interfaces" del MikroTik Router OS y, también, se eligió comenzar de cero y probar realizando todo en pestaña "Bridges" (especificando puertos).

Todos estos bridges fueron pasados a la virtual en órden, fácilmente identificables por su MAC.

![Lista de los bridges pasados a la VM]({{ site.url }}/assets/posts/breve-resena-sobre-virtualizar-mikrotik-en-proxmox/bridges-mikrotik-vm.png)

# Problema

Al agregar más de un flujo de red en alguna interfaz del MikroTik (que depende de un bridge Proxmox), toda la comunicación que debería ir por ese bridge se pierde.

# ¿Solución?

Como indiqué, probé muchas cosas sin éxito. Si alguien pudo solucionarlo, lo invito a que me envíe un mensaje a [Discord](https://discord.gg/KbH9D4XbHX) para charlarlo.