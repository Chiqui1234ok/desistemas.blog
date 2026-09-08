---
layout: post
title:  "Instalar Cloudflared • OpenWRT"
description: "Si ya tenés OpenWRT y querés evitar gastos en hosting a la hora de publicar sitios webs, podés vincular un dominio a tu router sin necesidad de IP Pública. Y si tenés IP Pública pero no querés mostrarla ni tener más puertos abiertos aparte del 80 y 443, Cloudflare ya hace esto por vos 😁"
image: "/assets/posts/instalar-cloudflared-en-openwrt/portada.webp"
date:   2025-02-24 13:00:00 -0300
categories: [homelabing]
tags: openwrt, tunel, cloudflared, router, virtual, cloudflare, openwrt
---

# Preámbulo

En este tutorial, se utilizará la aplicación ***cloudflared*** para crear un túnel seguro desde un router OpenWRT hasta Cloudflare.

> Si no tenés OpenWRT instalado en tu Proxmox, [acá hay un tutorial]({% post_url openwrt/2025-04-17-instalar-router-openwrt-en-vm-proxmox %}) completísimo. Paso a paso y con imágenes.

Esto permite exponer servicios a internet a pesar de no tener acceso al router del ISP y, por ende, no poder abrir puertos en él.

> También es posible descargar "Cloudflare WARP", un cliente que permite entrar a la VPN del router. Igualmente, esto no es necesario para montar servicios en la nube y no entra en lo que es el objetivo del tutorial.

Además, oculta la IP pública del router OpenWRT porque se utiliza a Cloudflare como "middle man", lo cuál añade una capa de seguridad.

Las aplicaciones web bajo este método tendrán un certificado SSL/TSL sin necesidad de pasos o costos extra.

Este blog se hosteaba con este mismo stack de red: OpenWRT + Cloudflare Tunnel.

# Descargar Cloudflared

La versión a descargar depende del hardware dónde se ejecuta OpenWRT. En el caso del tutorial, el software está instalado en una máquina virtual x86_64 y se descargará para esa arquitectura, en la versión binaria.

![La versión a descargar desde el sitio oficial es x86_64, en el caso del tutorial]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/version-de-descarga.webp)

[Link de descarga oficial](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/#linux).

El comando para descargar el archivo y moverlo a **/usr/bin/** es el siguiente:

```bash
wget -O /usr/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/downlo
ad/cloudflared-linux-amd64
```

Al almacenar este programa en **/usr/bin**, estará disponible al escribir su nombre, sin necesidad de anteponer la ruta hasta el programa.

Por defecto esta aplicación no tendrá permisos de ejecución, así que se procede con:

```bash
chmod +x /usr/bin/cloudflared
```

# Verificar la instalación

Para asegurarse que esté todo bien, se ejecuta:

```bash
cloudflared version
```

Si arroja un error, probablemente no se haya descargado correctamente o falte alguna dependencia, pero este tutorial se está haciendo en una instalación fresca de OpenWRT y todo funciona bien.

La versión es:

```bash
cloudflared version 2025.2.0 (built 2025-02-05-1042 UTC)
```

Ahora se debe realizar el registro de la cuenta en cloudflare.

# Registro en Cloudflare

El registro se realiza desde [este link](https://dash.cloudflare.com/sign-up).

Se debe especificar un email válido, y para la contraseña se solicita al menos:

- 8 caracteres
- 1 número
- 1 caracter especial (como por ejemplo: **$**, **!**, **@**, **%**, **&**)
- Sin espacios al principio ni final

![Registro en Cloudflare]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/registro-en-cloudflare.webp)

Se comprueba ser un humano y luego toca hacer clic en el botón **Sign Up**.

# Cloudflare Zero Trust

Ahora hay que dirigirse a [Zero Trust](https://one.dash.cloudflare.com/). Allí, preguntará que cuenta usar. Se selecciona la que se quiere utilizar para el futuro tunneling.

![Seleccionar cuenta para realizar el tunneling]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/seleccionar-cuenta-para-tunneling.webp)

> Si, la dirección de correo está tachada porque en este caso, es mi email personal.

En el paso siguiente, Cloudflare preguntará por un nombre de equipo (URL para permitir conexiones con Cloudflare WARP). Bajo este nombre luego se podrán crear usuarios, para habilitar dispositivos y permisos para la utilización del túnel.

![Nombre de equipo para Cloudflare]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/cloudflare-team.webp)

El plan gratuito sobrará para el homelab o pruebas que estés realizando. Es compatible con ruteos y soporta hasta 50 usuarios, siendo más que generoso.

![Listado de planes de Cloudflare Zero Trust]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/planes-cloudflare-zero-trust.webp)

Se selecciona el Plan gratuito, y se colocan los datos de la tarjeta y ubicación (si, incluso en el plan gratuito solicita estos datos). Se recomienda utilizar una tarjeta de crédito que luego se pueda pausar, para evitar cobros sin preguntar.

Luego de colocar los datos en el formulario, la página permite finalizar con el pago.

# Ver el nombre del equipo

![Ver nombre del equipo]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/ver-nombre-del-equipo.webp)

Desde [Cloudflare Zero Trust](https://one.dash.cloudflare.com/) > **Settings** > **Custom Pages** se verá el nombre del equipo, que puede ser editado desde ese mismo menú.

# Conectar OpenWRT y Cloudflare

En la terminal de OpenWRT, se inicia sesión ejecutando:

```bash
cloudflared tunnel login
```

Esta acción hará que la terminal muestre un link, el cuál se debe pegar en el navegador (el link cambia todo el tiempo, debés copiar el propio):

![Ruta de login en Cloudflare, para autorizar el OpenWRT]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/cloudflare-tunnel-login-url.webp)

Una vez se haya cargado la página mediante el link, se debe seleccionar la cuenta de Cloudflare deseada para crear el tunel hasta OpenWRT:

Al seleccionar la cuenta, se abrirá una ventana que dice: "To finish configuring Tunnel for your zone, click Authorize below.". Se hace clic en el botón "Authorize", y se observa la ventana del éxito.

![Ventana de tunel exitoso]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/ventana-success-cloudflare.webp)

# Conexión del tunel

Mientras se realizaban las configuraciones en la web, la terminal de OpenWRT hizo lo suyo y nos notifica:

```bash
You have successfully logged in.
If you wish to copy your credentials to a server, they have been saved to:
/root/.cloudflared/cert.pem
```

Sólo resta crear la carpeta de configuración y su certificado, para luego activar el túnel:

1. Crear **desistemas** en la carpeta **/etc**, para guardar las configuraciones relacionadas a este túnel:

```bash
mkdir /etc/desistemas
```

2. Se debe copiar **/root/.cloudflared/cert.pem** a **/etc/desistemas/**:

```bash
mv /root/.cloudflared/cert.pem /etc/desistemas/
```

3. Activar el tunel, indicando la ruta del certificado con la variable ***TUNNEL_ORIGIN_CERT***.

```bash
TUNNEL_ORIGIN_CERT=/etc/desistemas/cert.pem cloudflared tunnel create desistemas
```

# Éxito

La creación del túnel es exitosa, con el siguiente mensaje:

```bash
Tunnel credentials written to /root/.cloudflared/94c1f778-b49f-4a37-b4f8-91529045b3eb.json. cloudflared chose this file based on where your origin certificate was found. Keep this file secret. To revoke these credentials, delete the tunnel.

Created tunnel desistemas with id 94c1f778-b49f-4a37-b4f8-91529045b3eb
```

**Se debe anotar:**
1. La ruta del json (**/root/.cloudflared/94c1f778-b49f-4a37-b4f8-91529045b3eb.json**).
2. El ID que aparece luego de "Created tunnel desistemas with id".

En este caso es **/root/.cloudflared/94c1f778-b49f-4a37-b4f8-91529045b3eb.json** e ID **94c1f778-b49f-4a37-b4f8-91529045b3eb**. En tu caso estos dos datos serán diferentes.

# Crear archivo de configuración

Se debe crear el archivo de configuración **/etc/desistemas/config.yml**:

```bash
vi /etc/desistemas/config.yml
```

Una vez dentro de ***vi***, se presiona **I** en el teclado y se pega el siguiente contenido, reemplazando `94c1f778-b49f-4a37-b4f8-91529045b3eb` por el ID que se anotó anteriormente.

```yml
tunnel: 94c1f778-b49f-4a37-b4f8-91529045b3eb
credentials-file: /etc/desistemas/94c1f778-b49f-4a37-b4f8-91529045b3eb.json
warp-routing: 
 enabled: false
```

Luego, se apreta **ESC** en el teclado, se escribe ":wq" y se presiona ENTER. Esto guardará el archivo y saldrá de Vi.

# Crear procesos para el init

En OpenWRT 23.05.5, surgirá el siguiente error al querer iniciar el tunel con `cloudflared tunnel run desistemas`:

```bash
WRN The user running cloudflared process has a GID (group ID) that is not within ping_group_range. You might need to add that user to a group within that range, or instead update the range to encompass a group the user is already in by modifying /proc/sys/net/ipv4/ping_group_range. Otherwise cloudflared will not be able to ping this network error="Group ID 0 is not between ping group 1 to 0"
WRN ICMP proxy feature is disabled error="cannot create ICMPv4 proxy: Group ID 0 is not between ping group 1 to 0 nor ICMPv6 proxy: socket: permission denied"
```

Para permitir el ping desde cloudflare, se debe ejecutar:

```bash
vi /etc/sysctl.d/99-fix-buffer-and-ping.conf
```

A continuación, se presiona **I** en el teclado, para entrar en modo "insert". Tipear lo siguiente:

```bash
net.core.rmem_max=2500000
net.ipv4.ping_group_range=0 2147483647
```

Para guardar y salir, se debe apretar la tecla **ESC** (para salir del modo "insert") y luego escribir sin comillas: ":wq!".

Bien, ya se guardó el archivo y se salió de "vi". Para que el init aplique los cambios, se ejecuta:

```bash
sysctl -p /etc/sysctl.d/99-fix-buffer-and-ping.conf
```

# Ejecutar cloudflared

Finalmente, se debe ejecutar en OpenWRT:

```bash
TUNNEL_ORIGIN_CERT=/etc/inforce/cert.pem cloudflared tunnel run desistemas
```

# Comprobar tunel

Dirigirse a la web [Cloudflare Zero Trust](https://one.dash.cloudflare.com/) y luego Network > Tunnels.

![Comprobar túnel]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/comprobar-tunel.webp)

El túnel se puede ver creado y en estado "HEALTHY" (saludable), en la tabla como la mostrada en la imágen de arriba.

# Migrar la configuración local del túnel a Cloudflare

En este mismo listado de Túneles, se debe realizar clic en las opciones del túnel en cuestión, en el icono que se encuentra a la derecha:

![Opciones del túnel]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/opciones-del-tunel.webp)

Luego, opción **Configure**.

La nueva página dejará el botón "Start Migration", al cuál se le hace clic para comenzar con el proceso que permitirá realizar la configuración desde Cloudflare, en vez desde OpenWRT.

La migración consiste de 4 pasos, se deben confirmar todos ellos sin crear hostnames ni nada por el estilo, ya que la interfaz y el proceso puede buguearse.

# Instalación del servicio

El comando `cloudflared service install` instalaría un servicio que no es totalmente compatible con ***procd***, el init de OpenWRT ([averigüa qué es el init y como descubrir el que usa cada SO Linux]({% post_url linux/2025-02-27-averigua-el-init-de-linux %})). Las razones son:

1. No soporta la opción "enable", por ende el servicio no se registra para auto-iniciar.
2. OpenWRT posee una versión reducida del comando ***ps*** que no soporta añadirle opciones, por ende no funcionaría el comando `/etc/init.d/cloudflared stop`.
3. Antes que llamar al servicio "cloudflared", es mejor llamar al servicio "desistemas", haciendo referencia al túnel creado en la interfaz de Cloudflare anteriormente.

## Crear el servicio

```bash
vi /etc/init.d/desistemas
```

Se presiona la tecla **I** en el teclado, y luego se pega el siguiente script:

```bash
#!/bin/sh /etc/rc.common

START=22
STOP=22
USE_PROCD=1

name="desistemas"
cert_file="/etc/$name/cert.pem"
config_file="/etc/$name/config.yml"
pid_file="/var/run/$name.pid"
stdout_log="/var/log/$name.log"
stderr_log="/var/log/$name.err"

start_service() {
    echo "Starting $name"
    procd_open_instance
    procd_set_param command /usr/bin/cloudflared --pidfile $pid_file --autoupdate-freq 24h0m0s --config $config_file tunnel run
    procd_set_param env TUNNEL_ORIGIN_CERT=$cert_file
    procd_set_param pidfile $pid_file
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_set_param respawn
    procd_close_instance

    sleep 1

    if ps | grep "$name" | grep -v grep > /dev/null; then
        echo "$name started successfully."
    else
        echo "$name had an error and isn't running. Check $stderr_log for details."
    fi
}

stop_service() {
    if [ -f "$pid_file" ]; then
        kill $(cat "$pid_file")
        rm "$pid_file"
        echo "$name stopped."
    else
        echo "$name is not running."
    fi
}

reload_service() {
    stop_service
    start_service
}
```

Luego, se apreta **ESC** en el teclado, se escribe ":wq" y se presiona ENTER. Esto guardará el archivo y saldrá de Vi.

## Activar el servicio

El archivo ya está creado, pero aún no está marcado para iniciar con el boot. En primer lugar, se le deben dar permisos de ejecución:

```bash
chmod +x /etc/init.d/inforce
```

Y se activa el servicio para el próximo booteo de la siguiente manera:

```bash
/etc/init.d/desistemas enable
```

## Comprobación del servicio

La opción `enable` creará el acceso directo en la carpeta **/etc/rc.d**. Esta carpeta es la encargada de lanzar los servicios durante el proceso de booteo. Se puede verificar ésto mediante la instrucción:

```bash
ls /etc/rc.d | grep S22
```

La salida será: **S22desistemas**.

## Iniciar el servicio

No es necesario reiniciar OpenWRT para que el túnel funcione. El siguiente comando dejará al servicio funcionando:

```bash
/etc/init.d/desistemas start
```

## Reiniciar el servicio (opcional)

En caso de necesidad, el reinicio se puede efectuar con:

```bash
/etc/init.d/desistemas reload
```

Y al ejecutar el comando ***ps***, veremos que el servicio fue iniciado sin problemas:

```bash
ps | grep desistemas | grep -v grep
```

![Cloudflared ya está ejecutándose, según el comando "ps"]({{ base.url }}/assets/posts/instalar-cloudflared-en-openwrt/cloudflared-ps.webp)

# Epílogo

Este tutorial enseña como crear el túnel entre un router OpenWRT y Cloudflare. En el siguiente post se enseña a exponer los servicios. [Clic acá para seguir leyendo]({% post_url cloudflare/2025-03-01-exponer-servicios-en-la-nube-con-public-hostnames %}).