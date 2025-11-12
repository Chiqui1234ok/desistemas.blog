---
layout: post
title:  "Montar Samba share en LXC"
date:   2025-01-01 12:49:00 +0000
tags: guía, tutorial, linux, lxc, contenedor
---

# Preámbulo

Los contenedores LXC son muy buenos por su rendimiento "bare-metal" y bajo consumo de almacenamiento y memoria.
Utilizan un usuario root, pero que no tiene privilegios de superusuario. Ésto hace que no se puedan ejecutar comandos como `mount`, que requiere permisos de superusuario.
Por esta razón, comandos como el siguiente no se podrán ejecutar en un contenedor no privilegiado:

```bash
mount -t cifs //<ip del servidor>/<carpeta que querés obtener> /mnt/<carpeta que querés obtener> -o username=<mi usuario>
```

Por ello, en este tutorial se enseñará como montar la carpeta compartida desde un servidor SAMBA hasta el host que ejecuta el LXC. Posteriormente se indicará como montar esa carpeta en el contenedor.

Si se posee un servidor SAMBA en forma de máquina virtual junto al LXC, por default no puede iniciar **antes** que el contenedor. Para estos casos, se enseñará una alternativa: [Realizar el montaje con delay]({% post_url 2025-01-01-montar-directorio-compartido-en-lxc-cuando-inicia-el-servidor-samba %}).

# Procedimiento

Si se tiene un servidor SAMBA que siempre está disponible cuándo el host y su LXC enciendan, este método será ideal y más rápido de implementar.

## Obtener ID de usuario "root" (UID)

Para obtener el ID del usuario *root*, ejecutamos:

```bash
cat /etc/subuid | grep root
```

Se verán los IDs que puede delegar el usuario "root" a mapeos de procesos y usuarios:

```js
root:100000:65536
```

Ésto indica que los IDs para este usuario se reservan desde 100.000, y unos 65.536 espacios más. Por ende, el ID **100.010** es válido porque pertenece al rango. Nos anotamos ese número.

> Si el print de tu comando `cat` es distinto, acomodá tu ejemplo según corresponda.

⚠️ Se debe revisar que el ID de usuario 100.010 no lo esté usando otro proceso. Ésto se comprueba con los comandos `ps -u 100010` (procesos con ese ID de usuario), `ss -p | grep 100010` (conexiones de red con ese ID de usuario) y `lsof -u 100010` (archivos abiertos con ese ID de usuario).

# Obtener ID de grupo (GID)

Se procede a buscar el rango de IDs para grupo root, que usualmente es idéntico al del usuario (UID):

```bash
cat /etc/subgid | grep root
```

El output es:

```js
root:100000:65536
```

Se utilizará el GID 100.010.

# Montar share en el host

1. Crear un archivo en `/root/cifs/credenciales` con el usuario y contraseña del share SAMBA, como usuario root.

```bash
username=<usuario del share SAMBA>
password=<contraseña del share SAMBA>
```

2. Configurar permisos correctos, para que sea sólo visible por el usuario y grupo "root":

```
chmod 660 /root/cifs/credenciales
```

3. Se inserta la siguiente línea en `/etc/fstab`, editando con los datos necesarios:

```
//<ip del servidor>/<carpeta a obtener> /mnt/<carpeta dónde se monta el share smb en el host> cifs credentials=/root/cifs/credenciales,uid=100010,gid=100010,iocharset=utf8
```

4. Se prueba a montar el nuevo `/etc/fstab`:

```bash
mount -a
```

No deberían haber errores, y se debería poder realizar `ls /mnt/<carpeta dónde se monta el share smb en el host>` para ver el contenido del share.

# Montaje de carpeta en el LXC

⚠️ Siguiendo con el ejemplo, este es el primer punto de montaje del LXC, por eso se utilizará el argumento `-mp0`. En caso de que ya haya un punto de montaje 0, se debe utilizar un argumento como `-mp1`, `-mp2` o `-mpN`.

Sin necesidad de tener el contenedor apagado, se realiza el seteo:

```
pct set <ID del LXC> -mp0 /mnt/<carpeta dónde se montó en el host>,mp=/mnt/<carpeta dónde se quiere montar en el LXC>
```

> Los puntos de montaje siempre deben realizarse en la carpeta `/mnt`

Se debería ver la carpeta en la interfaz web de proxmox, así:

![punto de montaje en LXC](/assets/posts/montar-samba-share-en-lxc/mount-point-lxc.png)

Se debe comprobar el punto de montaje dentro del contenedor, realizando un comando `ls` de la carpeta montada.

# Conclusión

1. El montaje lo hace el host: luego el directorio se monta en el contenedor con los permisos correctos (UID/GID del host).

2. LXC no privilegiado usa un mapeo predeterminado: El root del contenedor (UID 0) está mapeado automáticamente a un UID **no privilegiado** del host (100010), que ya tiene acceso al directorio.

3. No hay superusuario en el LXC: El usuario "root" del contenedor solo tiene permisos equivalentes al UID 100010 en el host, no permisos de root completo. No puede hacer nada fuera de lo permitido por ese UID (sigue careciendo de privilegios).