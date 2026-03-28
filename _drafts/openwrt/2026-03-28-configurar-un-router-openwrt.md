---
layout: post
title:  "Cómo configurar un router (Interfaces, IP, VLANs, Bridges y Rutas) • OpenWRT"
date:   2025-03-14 12:32:00 +0300
tags: openwrt, configurar, web, rutas, interfaces, ip, vlan, routes, ruteo, paquetes, vlan
---

# Preámbulo

Casi un año para hacer la seguidilla del post sobre ["Instalación de router OpenWRT en VM • Proxmox"]({% post_url 2025-04-17-instalar-router-openwrt-en-vm-proxmox %}). Pasaron muchas cosas y, sobretodo, aprendizajes. Actualmente implementé MikroTik en la empresa dónde trabajo. Sin embargo, aunque [RouterOS es instalable en el hipervisor](https://community-scripts.org/scripts/mikrotik-routeros) mediante un script de *Proxmox VE Helper Scripts*, encontré dificultades a la hora de pasar troncales por bridges creados en Proxmox. Puedo pasar una VLAN por cada "vmbr**N**", pero en cuánto pasan dos flujos de red (VLAN + LAN o dos VLANs), la comunicación se rompe. 

Dejo este dato por si gustan probarlo y se encuentran que, a pesar de configurar todo bien, no tienen red.