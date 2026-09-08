---
layout: post
title:  "Montar directorio compartido en LXC, cuándo inicia el servidor SAMBA"
date:   2025-01-01 12:49:00 +0000
tags: guía, tutorial, linux, lxc, contenedor
---
# Preámbulo

Dentro de un hipervisor, puede haber máquinas virtuales y contenedores. En la configuración explicada en este tutorial, se está en presencia de:

1) Una máquina virtual con TrueNAS Scale 24.
2) Varios LXC que utilizan datos almacenados en TrueNAS.

El problema es que la VM deberá cargar por completo su sistema, y hasta entonces no estará disponible para compartir los datos que administra. En cambio, los LXC "bootean" instantáneamente y por esta razón no se puede realizar un montaje de las comparticiones SAMBA directamente en `/etc/fstab`. Se debe optar por un montaje con unos segundos de delay, para que el TrueNAS esté 100% operativo.

En caso de no utilizar este método, el montaje no funcionará y, si existe un proceso dentro del contenedor que depende de esta carpeta compartida, podría fallar su inicio o tener [comportamientos no deseados](#modificación-del-servicio-del-lxc).

# Procedimiento

## Obtener ID de usuario "root" (UID)

Para obtener el ID del usuario *root*, ejecutamos:

```bash
cat /etc/subuid | grep root
```

Se verán los IDs que puede delegar el usuario "root" a mapeos de procesos y usuarios:

```js
root:100000:65536
```

Ésto indica que los IDs para este usuario se reservan desde 100.000, y unos 65.536 espacios más. Por ende, el ID **100.010** es válido porque pertenece al rango. Este número debe ser anotado, se usará más adelante.

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

1. Crear la carpeta `/root/cifs` y el archivo en `/root/cifs/credenciales`, con el usuario y contraseña del share SAMBA.

```bash
username=<usuario del share SAMBA>
password=<contraseña del share SAMBA>
```

2. Configurar permisos correctos, para que sea sólo visible por el usuario y grupo "root":

```
chmod 660 /root/cifs/credenciales
```

3. Se crea el servicio `/etc/systemd/system/montar-delay`.

4. En este archivo se copia y pega el siguiente template:

```bash
[Unit]
Description=Montar blockchain
After=network.target

[Service]
ExecStartPre=/bin/sleep 120
TimeoutStartSec=180
ExecStart=mount -t cifs //<ip del servidor>/<carpeta a obtener> /mnt/<carpeta dónde se monta el share smb en el host> -o credentials=/root/cifs/litecoin,uid=100010,gid=100010,iocharset=utf8
ExecStop=/bin/litecoin-cli -conf=/root/.litecoin/litecoin.conf stop

[Install]
WantedBy=multi-user.target
```

El delay de 230 segundos es un tiempo muy adecuado para que se inicie el servidor SAMBA.

> Si tu aplicación requiere iniciarse lo antes posible y no podés quitar la dependencia de este TrueNAS virtualizado, deberás ajustar más este delay de 230 segundos.

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

# Modificación del servicio del LXC

Este delay tiene sentido cuándo, por ejemplo, el servicio que sincroniza una base de datos externa con una copia local, no puede encontrar dicha copia local. Esto sucede porque cuándo inicia el contenedor, no hay nada montado por culpa de que el servidor SAMBA aún no está completamente iniciado.

Por ende, no solo se debe efectuar el delay en el host, para montar la carpeta compartida en el momento correcto, sino que también se deben demorar los servicios que dependen de este share.

Para lograr ésto, se edita el servicio que depende de este montaje. Los servicios en la mayoría de sistemas derivados de Debian / Ubuntu utilizan systemd, un gestor de daemons que ubica sus servicios en `/etc/systemd/system/`.

1. Se ingresa a dicha carpeta:

```
cd /etc/systemd/system
```

2. Se realiza un listado de archivos, para averiguar el nombre del servicio a editar

```
ls
```

3. Se edita el archivo con `nano` (o `vi` si no está `nano` disponible)

```
nano <nombre del servicio>
```

Por ejemplo:

```
nano litecoind.service
```

4. Se indica un delay en el archivo, en la sección **[Service]**

Este retraso se añade con la siguiente línea, siendo "130" el tiempo en segundos:

```
ExecStartPre=/bin/sleep 130
```

Además, `systemd` puede interpretar que el servicio falló su inicio porque el timeout por defecto es de 90 segundos. Para cambiar este comportamiento en este servicio, se añade una línea para darle más paciencia (180 segundos):

```
TimeoutStartSec=180
```

Es ideal añadir estas línea justo debajo de **[Service]**, quedando así:

```
[Unit]
Description=Litecoind Service
After=network.target

[Service]
ExecStartPre=/bin/sleep 120
TimeoutStartSec=180
ExecStart=/bin/litecoind -conf=/root/.litecoin/litecoin.conf
ExecStop=/bin/litecoin-cli -conf=/root/.litecoin/litecoin.conf stop

[Install]
WantedBy=multi-user.target
```

# Conclusión

1. El montaje lo hace el host: luego el directorio se monta en el contenedor con los permisos correctos (UID/GID del host).

2. LXC no privilegiado usa un mapeo predeterminado: El root del contenedor (UID 0) está mapeado automáticamente a un UID **no privilegiado** del host (100010), que ya tiene acceso al directorio.

3. No hay superusuario en el LXC: El usuario "root" del contenedor solo tiene permisos equivalentes al UID 100010 en el host, no permisos de root completo. No puede hacer nada fuera de lo permitido por ese UID (sigue careciendo de privilegios).