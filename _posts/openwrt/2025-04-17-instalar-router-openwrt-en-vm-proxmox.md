---
layout: post
title:  "Instalar router OpenWRT en VM • Proxmox"
description: "Utilizando infraestructura que ya existe y opcionalmente, unas placas de red, es posible tener un router para homelab y/o producción de forma sencilla y con un consumo muy inferior a PfSense y OPNSense."
image: "/assets/posts/instalar-router-openwrt-en-vm-proxmox/portada.webp"
date:   2025-04-17 23:56:00 -0300
categories: [homelabing]
tags: guía, tutorial, proxmox, openwrt, vlan, router, dhcp, opnsense, pfsense, imagenes
---

# Preámbulo

OpenWRT es un sistema operativo que convierte un dispositivo en un router. Además, brinda características avanzadas que estaban solo disponibles en aparatos mucho más caros, como las VLANs, firewall y un Linux completo; Y permite estar en control de una red y sus dispositivos. Es ideal para crear VLANs, y así tener redes específicas para ciertas áreas / usos. También, con ciertas aplicaciones que pueden instalarse (y Docker externos) monitorear y graficar el tráfico de la red.

Permite aprender y practicar muchos conceptos sobre redes informáticas, a la vez de que es un software preparado para producción, y mucho más ligero que PfSense / OPNSense.

La instalación en este tutorial se explica en un entorno Proxmox, con una serie de comandos para instalar una máquina virtual Q35 y el sistema operativo dentro de una imágen de disco.
Por ejemplo, [acá hay un tutorial para la instalación en VirtualBox](https://gist.github.com/stokito/533e2c1d2bc7809ceed124da3ab48567).

Además, se recurre a OpenVSwitch, y no se usarán los Linux Bridges comunes. Lo segundo me dio problemas a la hora de montar un bridge virtual en un puerto real, algo clave para poder construir un router físico.

Habiendo aclarado esto, empecemos.

# Descargar imágen ISO

La imágen se debe descargar desde la [web oficial](https://downloads.openwrt.org/releases/23.05.5/targets/). Primero, se selecciona la arquitectura del CPU dónde se ejecutará el sistema operativo, comúnmente "x86".

![Arquitectura del CPU]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/arquitectura-del-cpu.webp)

A continuación, se muestran items como "64", "generic", "geode" y "legacy". Se selecciona "64", salvo que no tengas un procesador moderno. Una vez habiendo elegido la opción correcta, aparecerán distintos archivos. La [documentación](https://openwrt.org/docs/guide-user/installation/openwrt_x86#download_disk_images) explica cada una, pero te adelanto que la opción **generic-squashfs-combined-efi.img.gz** tiene las mejores características, según mi criterio. Estas características son:

- Persistencia de la raíz del SO: el SO no podrá ser modificado por nosotros ni posibles atacantes.
- Tiene una partición para archivos de configuración: podremos editar el comportamiento del dhcp, vlan y firewall.
- Su sistema de particiones incluye una EFI: es compatible con una VM basada en chipset Q35.
- Ofrece 100MB para aplicaciones extra: no necesitamos ninguna para tener un router funcional, pero la opción está.

# Subir la imágen a Proxmox

Copiamos el link de **generic-squashfs-combined-efi.img.gz** y vamos a nuestra terminal. Nos debemos dirigir al directorio dónde guardamos las imágenes ISO (dónde se guardan los instaladores de los sistemas operativos). Ese directorio debería ser **/var/lib/vz/template/iso**:

```bash
cd /var/lib/vz/template/iso
```

Una vez ahí, se ejecuta ***wget***, para descargar el archivo **generic-squashfs-combined-efi.img.gz**:

```bash
wget https://downloads.openwrt.org/releases/24.10.1/targets/x86/64/openwrt-24.10.1-x86-64-generic-squashfs-combined-efi.img.gz && \
```

Y se descomprime:

```bash
gunzip openwrt-*.img.gz
```

A modo de documentar, al finalizar el comando ***gunzip***, se mostrará este mensaje:

```
gzip: openwrt-24.10.1-x86-64-generic-squashfs-combined-efi.img.gz: decompression OK, trailing garbage ignored
```

La imágen de disco ahora se sitúa en **/var/lib/vz/template/iso/openwrt-24.10.1-x86-64-generic-squashfs-combined-efi.img**. Se utilizará esta ruta para instalar el sistema operativo en la máquina virtual.

# Crear dos adaptadores de red para pruebas

Seguramente ya tengas un bridge virtual llamado "vmbr0", pero hay que crear otros dos adaptadores para que el router pueda tener algo con qué jugar.

Para ello, primero se debe instalar ***open-vswitch***:

```
apt update && apt install openvswitch-common -y
```

Y en el archivo **/etc/network/interfaces**, crear dos adaptadores para pruebas:

```
auto vmbr9001
iface vmbr9001 inet manual
        ovs_type OVSBridge
# BRIDGE PARA PRUEBAS 1

auto vmbr9002
iface vmbr9002 inet manual
        ovs_type OVSBridge
# BRIDGE PARA PRUEBAS 2
```

Luego, reiniciar la red con:

```
systemctl restart networking
```

# Instalar la máquina con *qm*

Al ya tener la imágen, debemos instalarlo con un comando especial que convierta la imágen a algo que entienda ***qemu***. Como verás en el comando siguiente, voy a configurar una máquina ID 201 con un núcleo cpu, 256MB de RAM y un disco VirtIO.

> Para que tengas de referencia, mi OpenWRT con dos túneles Cloudflare (***cloudflared***) y alrededor de 10 VLANs consume sólo 170MB de RAM. El router maneja tráfico externo (ligero) y tiene conectado unos 12 dispositivos internamente, siendo uno de ellos un NAS, que maneja alrededor de 2GBit/s. Por ende, es correcto pensar que se estará muy bien con 256MB de RAM.

Se ordena la creación de la VM con el siguiente comando:

```
qm create 201 \
  --name OpenWRT-test \
  --memory 256 \
  --socket 1 \
  --cores 1 \
  --machine q35 \
  --bios ovmf \
  --efidisk0 disk_images:0,size=128K \
  --bootdisk virtio0 \
  --boot c \
  --onboot yes \
  --vga qxl \
  --net0 virtio=bc:24:11:26:f0:11,bridge=vmbr0,firewall=0 \
  --net1 virtio=bc:24:11:b8:ea:14,bridge=vmbr9001,firewall=0 \
  --net2 virtio=bc:24:11:57:7b:fc,bridge=vmbr9002,firewall=0 \
  --virtio0 disk_images:0,import-from=/var/lib/vz/template/iso/openwrt-24.10.1-x86-64-generic-squashfs-combined-efi.img,format=raw
```

Al ejecutar este comando, se creará una máquina virtual y se volcará la imágen de OpenWRT en el disco 0 de dicha VM.

# Ejecutar la máquina virtual

La máquina no iniciará sola, por lo que en la interfaz web de Proxmox deberá seleccionarse la VM 201 y, luego, apretar el botón "Start" de la esquina superior derecha.

![iniciar la vm en proxmox]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/iniciar-la-vm.webp)

Al entrar al item "Console", puede parecer que OpenWRT deja de cargar el sistema y se cuelga, así:

![Pareciera que OpenWRT se cuelga al iniciar, pero no]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/openwrt-se-cuelga-al-iniciar.webp)

Cuándo esto sucede, se debe seleccionar la consola con el mouse para hacer foco en la VM, y luego apretar la tecla ENTER. OpenWRT dará la bienvenida:

![Bienvenida de OpenWRT al iniciar la VM]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/openwrt-welcoming.webp)

# Configurar una contraseña

Es vital configurar una contraseña, para poder resguardar el router de manos ajenas. Para ello, se escribe y ejecuta el siguiente comando:

```bash
passwd root
```

Preguntará por la contraseña y su confirmación. Por motivos de seguridad, los caracteres tipeados no se muestran, pero la máquina los registra, así que se debe tipear sin preocupaciones. Al escribir la contraseña en las dos oportunidades (y de forma idéntica), el mensaje de éxito será:

```
passwd: password for root changed by root
```

# Ver los adaptadores de red

Para poder configurar el router, es necesario primero reconocer los adaptadores.

Se debe escribir el siguiente comando para obtener las tarjetas de red disponibles:

```bash
ip addr
```

La salida será:

![alt text]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/reconocer-los-adaptadores-de-red-con-ip-addr.webp)

El adaptador ***br-lan*** es un bridge virtual montado sobre ***eth0***. Esto está mal, porque el ***eth0*** se utilizará para la red WAN. El archivo de networking debe sufrir algunas modificaciones, para poder tener acceso a internet y empezar a routear cosas.

# Configurar IPs

Se debe editar el archivo de red mediante el software ***vi***:

---
*Si no sabés como usar **vi**, podés ver este sencillo video:*

<iframe width="560" height="315" src="https://www.youtube.com/embed/sBj-wB4Syl4?si=BWSPMOQYFEip5fQP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

---

```bash
vi /etc/config/network
```

El archivo se verá así:

![alt text]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/etc-config-network-default.webp)

Se debe editar para que ***br-lan*** utilice el puerto ***eth1***, y la WAN utilice el ***eth0***. Esto es porque el ***eth0*** está "mapeado" al bridge de proxmox que recibe internet, mientras que el ***eth1*** será utilizado por la LAN (la red interna dónde estarían los dispositivos en una red hogareña, carente de VLANs). Aunque esta configuración es sencilla, se realizará así para probar cosas y tener un punto dónde el router funciona bien.

Además, se eliminaron las características de IPv6, que no se usarán en redes hogareñas (ni la mayoría de profesionales), al menos por unos largos años. La edición del archivo queda así:

![alt text]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/edicion-de-network-inicial.webp)

Luego, se reinicia la red con:

```bash
/etc/init.d/network reload
```

![alt text]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/network-reload-1.webp)

# Epílogo

La nueva versión 24.10 consume unos 15MB más de RAM que la anterior (23.05.5), pero contiene los paquetes más seguros hasta la fecha, con todos sus parches de seguridad.

![consumo de recursos]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/consumo-de-recursos.webp)

Pronto se creará un nuevo post, para poder configurar el router completamente a nuestro gusto. Por ahora, si conectan máquinas virtuales o contenedores de Proxmox al adaptador "vmbr9001", tendrán IP e internet.

![Menú de conexión a bridge virtuales]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/utilizando-el-bridge-virtual-9001.webp)

## Realizá un snapshot

Para tomar "una foto" de como está ahora la máquina virtual, debés seleccionar la máquina virtual > Snapshots > Take snapshot.

![alt text]({{ base.url }}/assets/posts/instalar-router-openwrt-en-vm-proxmox/take-snapshot.webp)

Así, en caso de tener mala suerte con los cambios, siempre podés volver a este estado de la máquina virtual, cuándo funcionaba.

¡Saludos!