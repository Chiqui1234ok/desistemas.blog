---
layout: post
title:  "Como configurar múltiples permisos por usuario y grupo • Linux"
date:   2026-01-20 20:00:00 +0000
tags: configurar, permisos, acl, linux, getfacl, setfacl
---

# Preámbulo

Los Access Control List (ACL) sirven para configurar permisos de lectura, escritura y ejecución. Esta guía enseña a trabajar con ACLs de tipo "posixacl", que es nativo en Linux y compatible tanto con el sistema de archivos ext4, xfs y zfs, siendo este último apenas más difícil por requerir configuración extra (este filesystem será tratado en los temas de la guía).

Gracias a SAMBA, pueden traducirse en tiempo real desde un cliente Windows hasta el servidor Linux, y viceversa. Esta arista poco trabajada en internet, también se explica en este tutorial.

# Obtener información del ACL vigente

