---
layout: post
title:  "Arreglar servicio SAMBA \"stopped\" en el arranque • TrueNAS Scale"
date:   2025-11-25 21:00:00 -0300
image: "/assets/posts/arreglar-samba-stopped-en-truenas/portada.webp"
categories: [homelabing, truenas]
tags: truenas, scale, nas, problema, samba, samba stopped, arranque, inicio
---

# Preámbulo

![alt text]({{ base.url }}/assets/posts/arreglar-samba-stopped-en-truenas/samba-stopped-truenas-scale.webp)

En una instalación limpia de TrueNAS Scale Community Edition es muy común encontrarse con que el servicio SAMBA se activó en la interfaz web para que inicie junto al sistema operativo, pero esto nunca sucede.

Existen dos soluciones posibles:

# Solución 1

1. Dirigirse a la interfaz web e iniciar sesión como administrador.
2. Ir a System > Shell.

![alt text]({{ base.url }}/assets/posts/arreglar-samba-stopped-en-truenas/ir-a-la-shell-de-linux.webp)

3. Escribir en la shell `sudo -s`, para elevar privilegios. Preguntará la contraseña de root, la cuál debe escribirse correctamente y presionar ENTER para avanzar al próximo paso.

4. A continuación, se escribe el comando para habilitar el servicio de SAMBA en el arranque:

```bash
systemctl enable smbd
```

# Solución 2

1. Dirigirse a la interfaz web e iniciar sesión como administrador.
2. Ir a System > Services.
3. Activar el slider del servicio "SMB" en la columna "Start Automatically".

![Activar el slider del servicio SMB]({{ base.url }}/assets/posts/arreglar-samba-stopped-en-truenas/activate-smb-service.webp)

# Epílogo

A partir de ahora, al reiniciar TrueNAS el servicio SAMBA estará habilitado 🥳