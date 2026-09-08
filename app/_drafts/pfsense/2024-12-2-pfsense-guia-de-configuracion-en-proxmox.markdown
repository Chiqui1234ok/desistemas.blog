---
layout: post
title:  "PfSense • Guía de configuración en Proxmox"
date:   2024-12-2 21:00:00 +0000
tags: pfsense, firewall, router, proxmox, vlan, vlans
---

# Convenciones

- Cuándo digo **PC**, **Nodo**, **Servidor** o **Hipervisor**, me refiero a lo mismo: el equipo con Proxmox que estamos preparando para instalar PfSense.

# Introducción

Acá explicaré como podemos configurar un entorno de producción en PfSense, que también sirve para pruebas. Si bien no tengo tantas placas de red para dedicar un cable a cada red virtual, en esta guía envié dos troncales (una desde cada placa de red), y la explicación sirve para cualquier implementación:

- Un cable troncal que lleve todas las redes virtuales
- Dos cables troncales (se reparten las VLAN) (mi caso)
- Un cable por VLAN (lo mejor si tener 1Gbit por red es prioritario)

Enseñaré como darle uso a las VLANs en equipos físicos y virtuales, siendo éstas últimas unas facilitadoras para configurar el PfSense y probar la red.

# **Instalación de `openvswitch-switch`**

Realizamos el siguiente comando, que instalará `openvswitch-switch` y `openvswitch-common` (menos de 6MB en disco).

```bash
apt update
apt install openvswitch-switch
```

# Identificar las WAN

En mi caso, sé que la interfaz **vmbr0** es la que le da IP a mi Proxmox, y podemos utilizarla como WAN en PfSense. Si tuvieras dos interfaces WAN, agregarás las dos a la VM de PfSense. Por el momento, sólo identificalas y prosigamos. Las agregaremos más adelante.

<aside>
💡

Está la opción de juntar ambas WAN dentro de un OVS Bond, para que sea un único dispositivo. Pero creo que es mejor que ese manejo lo haga PfSense, como en una máquina real.

</aside>

# Bridges y VLAN en Proxmox

Yo tengo dos placas de red, `enp3s0` (PCI-E inferior) y `enp4s0` (PCI-E superior). Crearé un bridge para cada una y montaré distintas VLANs en cada una.

Con esto quiero decir que, a partir de dos placas de red, tendré dos troncales, configuradas así:

- `vmbr1000`:
    - VLAN1: sistemas_servidores (Sistemas y servidores)
    - VLAN2: recepcion (Recepción)
- `vmbr1001`:
    - VLAN3: profesionales (Profesionales)
    - VLAN4: imp_wifi (Impresoras y WiFi)

La idea es configurar una red relativamente sencilla que nos permita entender los bridges, el firewall y sus reglas, diagnosticar problemas de red, y más.

Como habrás notado, no armé una VLAN el sector administrativo, puesto que mi caso de prueba se trata de una clínica chiquita.

## Bridge a `enp4s0`

<aside>
💡

Primero haré la configuración de `enp4s0`, porque parece que está invertido el órden en mi PC de laboratorio, es decir la tarjeta `enp4s0` está arriba de la `enp3s0`, físicamente hablando.

</aside>

Bastante fácil, indicamos el nombre de red `vmbr1000` y un comentario para saber de qué trata este bridge (porque seguramente en la merienda de ese mismo día, te olvidás, pasa).

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image.png)

No te olvides de añadir `enp4s0` en el campo `Bridge ports`, caso contrario, ¡tendrás VLANs pero sólo para equipos virtuales! Justamente para que las VLANs vayan a equipos físicos, necesitamos montar el bridge en un dispositivo físico 😄

## Bridge a `enp3s0`

Lo mismo, pero acomodando el **Name** a `vmbr1001` y el **Comment** en *LAN2 PfSense*.

## VLAN a `vmbr1000`

Recordemos que `enp4s0` = `vmbr1000`. Vamos al botón **Create** y seleccionamos la opción **OVS IntPort**. 

<aside>
💡

Un **OVS IntPort** es como el grupo de puertos que puede utilizar una red virtual determinada. Soporta *n* cantidad de puertos. La cantidad de puertos por VLAN se configura en el switch administrable.

</aside>

Debemos crear nuestra primer VLAN para el Puente `vmbr1000`. A mi me gusta que coincida la cantidad de cifras entre VLANs y Bridges, por lo cuál procedo a crear la primer VLAN con **tag 1**.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%201.png)

Hago lo mismo, con el mismo adaptador (bridge) pero ésta vez poniendo el **Name** en *vlan1001* y **VLAN Tag** en *2*. 

## VLAN a `vmbr1001`

Lo mismo que en el título anterior, sólo que ahora apuntamos al bridge **vmbr1001** y tanto el nombre como su tag seguirán incrementándose en una unidad, es decir, si quiero crear dos VLANs más:

- **Name**: vlan1002, **OVS Bridge**: vmbr1001, **VLAN Tag**: 3
- **Name**: vlan1003, **OVS Bridge**: vmbr1001, **VLAN Tag**: 4

# Resultado: 2 VLANs por bridge

<aside>
❓

Si quisieras enviar un cable independiente por cada VLAN con el fin de tener más ancho de banda, deberías crear un bridge por cada VLAN y asignarle un único **OVS IntPort** a cada bridge.

</aside>

Luego de crear los 2 Bridges y 4 VLANs totales, nuestro **Network** en Proxmox quedaría así:

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%202.png)

Apretamos el botón **Apply Configuration**, esperamos que aplique todo y procedemos a instalar PfSense.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%203.png)

# Instalar PfSense

Creamos la máquina virtual según [indica la documentación](https://docs.netgate.com/pfsense/en/latest/recipes/virtualize-proxmox-ve.html), salvo que no debemos indicar ninguna interfaz de red. Las agregaremos a continuación.

Luego de seleccionar la VM (en mi caso, “pfsense” de ID 200), debemos darle al botón **Add** > **Network Device** para añadir el bridge WAN **vmbr0**, y los dos adaptadores que se repartirán las VLANs (**vmbr1000** y **vmbr1001**). 

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%204.png)

Estos dos últimos bridges mencionados prefiero destildarles la opción **Firewall** a la hora de agregarlos, porque quiero que este tema lo maneje completamente PfSense, tanto para las llamadas de entrada como de salida.

## Máquina virtual creada

Quedará algo así, ya con el ISO cargado para instalar PfSense y los 3 adaptadores de red.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%205.png)

## Preparación de la BIOS UEFI

Para bootear correctamente la ISO en chipset Q35 y UEFI, debemos apretar en el teclado ESC, apenas inicia la VM y vemos el logo de Proxmox. Ésto nos llevará a la configuración de la bios: **Device Manager** > **Secure Boot Configuration** > **Attemp Secure Boot** y apretamos la barra espaciadora para desactivarlo. F10 para guardar y ESC hasta volver al menú principal, dónde entramos a la opción **Continue** para proceder con el booteo.

## Instalación

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%206.png)

La bienvenida es ese documento, le damos **Accept** y luego la opción **Install PfSense**, dónde nos mostrará los adaptadores de red.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%207.png)

Para comprobar cuál es la WAN, podemos entrar a la pestaña **Hardware** de nuestra VM en Proxmox, y revisar que MAC tiene la **vmbr0**.

<aside>
💡

Es importante revisar las MACs, porque puede que no las muestre en el órden esperado. Tuve suerte en esta ocasión (es que el que escribe el tutorial, nunca se equivoca y todo le funciona).

</aside>

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%208.png)

Cuándo elegimos nuestro adaptador de red, presionamos **OK** y luego tocamos la opción **Interface Mode** hasta que quede en modo **STATIC**. Ahí se habilita **IP Address** (del PfSense), **Default Gateway** y **DNS Server**. Al terminar de escribir todos esos datos, le damos a la opción **Continue**.

Toca configurar las interfaces LAN, pero le damos al botón **SKIP** y Continuamos. Se intentará conectar a los servidores de Netgate en búsqueda de una licencia que no tenemos, así que nos dará la opción de instalar en modo **CE**, cosa que accedemos.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%209.png)

Luego de usar el botón **Install CE**, le damos a Continuar y **OK**, cuándo pregunta si queremos instalar PfSense en modo stripe (en un solo disco y sin redundancia). Si pregunta, instalamos la versión estable (nunca la deprecated, short term support ni nightly).

Al terminar, pedirá reiniciar. Dejamos que inicie, y nos preguntará si queremos configurar las VLANs.

## Configuración de VLANs en PfSense

Al iniciar PfSense, en su terminal veremos un mensaje que pregunta si queremos configurar las VLANs, a lo que responderemos que Si con la tecla **y**, luego apretamos el **Enter** del teclado.

Nos listará nuestras interfaces:

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2010.png)

En mi caso:

- vtnet1: `vmbr1000` (`vlan1000` y `vlan1001`)
    - Entonces debe indicarse vtnet1 y vlan tag 1, luego vtnet1 y vlan tag 2
- vtnet2: `vmbr1001` (`vlan1002` y `vlan1003`)
    - Entonces debe indicarse vtnet2 y vlan tag 3, luego vtnet2 y vlan tag 4

Dejo el output de mi consola para que se entienda mejor qué escribí y como asigné los tags de las VLANs. Ejemplo con **vtnet2**:

```bash
# "vtnet2" y el tag 3, lo puse yo
Enter the parent interface name for the new VLAN (or nothing if finished): vtnet2
Enter the VLAN tag (1-4094): 3
# "vtnet2" y el tag 4, lo puse yo
Enter the parent interface name for the new VLAN (or nothing if finished): vtnet2
Enter the VLAN tag (1-4094): 4
# Esto que está arriba, también lo hice para la vtnet1, con los tags 1 y 2
```

**Cuándo termines de crear tus VLANs**, apretá enter sin escribir nada y te mostrará el resúmen. Debería quedar algo así:

```bash
VLAN interfaces:
vtnet1.1    VLAN tag 1, parent interface vtnet1
vtnet1.2    VLAN tag 2, parent interface vtnet1
vtnet2.3    VLAN tag 3, parent interface vtnet2
vtnet2.4    VLAN tag 4, parent interface vtnet2
```

Luego de informarnos sobre nuestra asignación, nos pregunta qué interfaz es la WAN. En mi caso, la **vtnet0**. Cuándo pregunta por las LAN, indicamos una interfaz (en mi caso es **vtnet1**) y presionamos **Enter**. Luego hacemos lo mismo con la interfaz vtnet2, que se la asignamos a la opcional (es decir, cuándo pregunta por la opcional, escribimos **vtnet2** y **Enter**).

Quedará así:

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2011.png)

## Asignación de IP a la interfaz LAN

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2012.png)

En la opción 2, podremos indicar la IP de cada interfaz, por lo cuál si pregunta si queremos utilizar DHCP, **respondemos que no**. Como queremos darle IP a la **LAN** (vtnet1, en mi caso), seleccionamos la opción 2.

```bash
Available interfaces:
1 - WAN (vtnet0 - dhcp, dhcp6)
2 - LAN (vtnet1)
3 - OPT1 (vtnet2)
```

Preguntará por la IP, en mi caso quiero que la LAN sea **192.168.0.1** y la submáscara 255.255.255.0 (ésto lo responderemos luego de colocar IP y presionar **Enter**).

Hace una serie de preguntas, yo las respondí así (ya me encargaré el porqué dice “Non-local gateway”).

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2013.png)

Simplemente leemos lo que nos informa, y nos devolverá al menú principal, dónde nos dice que la IP de la LAN es **192.168.0.1**.

### Paréntesis: Non-local gateway detected

Este mensaje es porque el gateway al que apunta la interfaz WAN en PfSense no está en la misma subred que la WAN. 

<aside>
💡

Por ejemplo, podría suceder que la IP obtenida en el PfSense es 192.168.21.215 (que en mi caso está bien, porque estoy en la subred 21), pero la WAN está en 192.168.0.254.

</aside>

Si surge este error, vamos a la opción 2 “**Set interface(s) IP address**”. Nos preguntará por la interfaz que queremos editar, así que le indicamos el número que identifica a la WAN (en mi caso, es el número 1).

Indicamos que no queremos configurarlo por DHCP, sino nosotros mismos. Voy a pegar todo el output de la consola, por favor prestar atención a mis respuestas y teniendo en cuenta que mi Gateway está en 192.168.21.254, con una submáscara 255.255.255.0.

```bash
- LAN (vtnet1 - static)
- LAN2 (vtnet2)
- VLAN1 (vtnet1.1 - static)
- VLAN2 (vtnet1.2 - static, dhcp6)
- VLAN3 (vtnet2.3 - static, dhcp6)
- VLAN4 (vtnet2.4 - static, dhcp6)

Enter the number of the interface you wish to configure: 1
Configure IPv4 address WAN interface via DHCP? (y/n) n

Enter the new WAN IPv4 address. Press <ENTER> for none:
> 192.168.21.215

Subnet masks are entered as bit counts (as in CIDR notation) in pfSense.
e.g. 255.255.255.0 = 24
     255.255.0.0 = 16
     255.0.0.0 = 8

Enter the new WAN IPv4 subnet bit count (1 to 32):
> 24

For a WAN, enter the new WAN IPv4 upstream gateway address.
For a LAN, press <ENTER> for none:
> 192.168.21.254

Should this gateway be set as the default gateway? (y/n) y
Configure IPv6 address WAN interface via DHCP6? (y/n) n

Enter the new WAN IPv6 address. Press <ENTER> for none:
>

Do you want to enable the DHCP server on WAN? (y/n) n
Disabling IPv4 DHCPD...
Disabling IPv6 DHCPD...

Do you want to revert to HTTP as the webConfigurator protocol? (y/n) n

Please wait while the changes are saved to WAN...
Reloading filter...
Reloading routing configuration...

DHCPD...

The IPv4 WAN address has been set to 192.168.21.215/24

Press <ENTER> to continue.
```

# Conectarse a la LAN mediante VM extra

Levantamos alguna virtual que tenga asignado el mismo bridge de red que usamos para el LAN, en mi caso **vmbr1000**.

Como nos indica el menú principal de PfSense, la LAN está en **192.168.0.1/24**, y el router está usando la **192.168.0.1**.

Desde esta VM nueva (con Linux o Windows), podríamos dirigirnos a esa IP y conectarnos. Las credenciales por default son:

- Usuario: admin
- Contraseña: pfsense

Si nos vamos al menú **Interfaces** > **VLANs**, veremos ésto.

| Interface | VLAN tag |
| --- | --- |
| vtnet1 (lan) | 1 |
| vtnet1 (lan) | 2 |
| vtnet2 (opt1) | 3 |
| vtnet2 (opt1) | 4 |

# Asignar VLANs a interfaces

<aside>
💡

Se explica la configuración muy bien en la [documentación oficial](https://docs.netgate.com/pfsense/en/latest/vlan/configuration.html#web-interface-vlan-configuration) y se complementa con la de acá.

</aside>

En **Interfaces** > **Interface Assignments**, tenemos un ítem que dice **Available network ports**, y si abrimos encontramos un menú desplegable con todas las VLANs. Debemos seleccionar todas las VLAN (una a una) y darle al botón **Add**. Al agregar todas, se debería ver como ésto:

| **Interface** | **Network port** |
| --- | --- |
| WAN | vtnet0 (3e:70:b7:14:39:94) |
| LAN | vtnet1 (76:bf:7a:f8:36) |
| OPT1 | vtnet2 (fa:59:84:e6:f4) |
| OPT2 | VLAN 1 on vtnet1 - lan |
| OPT3 | VLAN 2 on vtnet1 - lan |
| OPT4 | VLAN 3 on vtnet2 - opt1 |
| OPT5 | VLAN 4 on vtnet2 - opt1 |

Si está todo bien, le damos al botón **Save**.

# Editar configuración de una interfaz

En **Interfaces** > **Assignments** tenemos el listado de nuestra WAN, las dos LAN (que tienen 2 hijos cada una, es decir, manejan dos VLANs) y las 4 VLAN creadas.

El objetivo es entrar al nombre de cada interfaz y asignarle un nombre. Yo **WAN**, **LAN** y **LAN2** las dejaría como están, pero voy a entrar a VLAN1, VLAN2, VLAN3 y VLAN4 (que ya la cambié a **imp_wifi**, como se ve en la imágen).

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2014.png)

Fijate que te marqué las interfaces a las que debemos entrar y otorgarles un nombre adecuado.

Al entrar a la configuración de VLAN4 (que yo de apurado le cambié el nombre a **imp_wifi**, ya), podemos ver estos campos de configuración, súmamente importantes.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2015.png)

Es probable que la casilla Enable interface está desactivada, debemos activarla para poder utilizar esta VLAN. Después, hay opciones clave para tocar:

- IPv4 Configuration Type: **Static IPv4**
- IPv6 Configuration Type: **None** porque no utilizamos la versión 6, además según Juan puede ser una puerta a ataques
- MTU: Por default es 1500 (y recomendado), podríamos aumentar esto a 9000 (Jumbo packets), si llegara a ser conveniente para su uso y todos los dispositivos soportan manejar ese tamaño de paquetes. Usualmente se deja en 1500 o vacío
- IPv4 Address: el rango de direcciones que deseamos tener para esa VLAN. Al escribir 192.168.4.1/24, estamos diciendo que la submáscara es 255.255.255.0 y se podrían tomar IPs desde 192.168.4.1 hasta 192.168.4.254

Luego de especificar estos datos, podemos darle al botón azúl **Save**. La página se refrescará y, en la parte superior, estará el botón verde **Apply Changes**.

# DHCP

En **System** > **Advanced** > **Networking** podemos iniciar el servicio *Kea DHCP* en cada interfaz.

<aside>
💡

Recomiendo no activar DHCP para la LAN, y cambiarse dentro de una VLAN porque la LAN no la usaremos más para conectarnos. La interfaz si deberá estar habilitada, porque es padre de dos redes virtuales y nos servirá para enviar la troncal hasta el switch (esta explicación aplica para LAN, LAN2, LAN<n>…

</aside>

Fijate que la opción DNS Servers está vacío, y hay un placeholder en un campo que nos indica que por default está apuntando al mismo PfSense. Ésto es conveniente, porque podemos editar nuestros DNS en **System** > **General Setup** y se cambiarán en todas las redes que apunten al PfSense.

Invito a ver la página, porque también hay opciones como Domain Name que pueden ser específicas a cada red.

También, más abajo, debemos deshabilitar Allow IPv6 y darle al botón **Save** que está situado en la parte inferior de la página.

# DNS Servers

En **System** > **General Setup** podemos asignar las IPs de los servidores DNS que querramos bajo el título **DNS Server Settings**. Al agregar las IPs, hacé clic en **Save** (al final de la página).

Podemos agregar los DNS de Cloudflare y Google:

- 1.1.1.1
- 1.0.0.1
- 8.8.8.8
- 8.8.4.4

# **Deshabilitar Hardware Checksums con tarjetas VirtIO**

Cuándo usamos interfaces de red VirtIO en Proxmox, la opción Hardware Checksum offloading debe estar deshabilitada. PfSense debería hacerlo por default, pero debemos corroborarlo porque si llega a estar habilitada no pasará el tráfico correctamente por el firewall. Además, si tenés un problema de que la interfaz web parece que tuviera lag, la deshabilitación de esta opción también lo resolverá.

Nos dirigimos a **System** > **Advanced** > **Networking**. Busca la sección **Networking Interfaces** y deshabilita la opción **Disable hardware checksum offload**. Dale al botón **Save** y reinicia el firewall desde **Diagnostics** > **Reboot**.

# Firewall

Esto que voy a explicar, lo vi en el PfSense de Talcahuano y me pareció muy útil realizarlo así. Esto nos ahorra, por ejemplo, el error de principiante de tener el puerto 53 y 853 bloqueados… lo cuál nos impide comunicarnos con los DNS y poder resolver nombres de dominio, a pesar de tener todo el resto bien configurado (hay internet, hay gateway con DNS, ya podemos hacer ping a IPs, etc).

Este *aproach* viene bien cuándo debemos darle más libertad que bloqueos a una red.

### Procedimiento

1. Primero creamos una regla para autorizar todos los protocolos (**importante**: esta regla debe quedar debajo de todas)
    1. Tomaré de ejemplo la VLAN1, que es la de Sistemas y Servidores.
    2. Nos dirijimos a **Firewall** > **Rules** > **SISTEMAS_SERVIDORES**.
    3. Elegimos las siguientes opciones. Después le damos al botón azúl **Save**, que refrescará la página y aparecerá el botón **Apply changes** para hacer efectivos los cambios. Las opciones que debemos configurar (yo estoy configurando esta regla para mi interfaz de **sistemas_servidores**):
    
    | **Campo** | **Valor** |
    | --- | --- |
    | **Action** | Pass |
    | **Disabled** | Desmarcado |
    | **Interface** | SISTEMAS_SERVIDORES |
    | **Address Family** | IPv4 (por nada en el mundo utilizamos IPv6) |
    | **Protocol** | Any |
    | **Source** | Any |
    | **Invert match (Source)** | No marcado |
    | **Destination** | Any |
    | **Invert match (Destination)** | Desmarcado |
    | **Log** | Desmarcado |
    | **Description** | Permitir la conexión en todos los protocolos y dispositivos |
2. Crear reglas para bloquear el acceso a otras VLANs, y dejar estas reglas habilitadas (o no) según necesidad del negocio. Esto debe hacerse arriba de la regla creada en el punto 1, ya que queremos que se tome en cuenta antes. Esto es porque la regla muy permisiva del punto anterior será restringida por las reglas que creamos arriba de ésta.
    1. Podemos restringir el acceso de la VLAN **sistemas_servidores** hacia **recepcion**. En el caso de la VLAN de sistemas, como es un entorno controlado y lo usarán los administradores del sistema, me interesa que **si** sepan que se está bloqueando la conexión, para que sea más fácil debuggear la red virtual. Para este caso, el valor de Action será **Reject**, para que el firewall informe al dispositivo que está queriendo llegar a una dirección IP, que no podrá hacerlo. En cambio, la opción **Block** hace que la máquina que quiere acceder a una dirección bloqueada, se quede reintentando la conexión sin poder alcanzarla.

| **Campo** | **Valor** |
| --- | --- |
| **Action** | Reject |
| **Disabled** | Desmarcado |
| **Interface** | SISTEMAS_SERVIDORES |
| **Address Family** | IPv4 (por nada en el mundo utilizamos IPv6) |
| **Protocol** | Any |
| **Source** | SISTEMAS_SERVIDORES net |
| **Invert match (Source)** | No marcado |
| **Destination** | RECEPCION subnets |
| **Invert match (Destination)** | Desmarcado |
| **Log** | Desmarcado |
| **Description** | Permitir la conexión en todos los protocolos y dispositivos |

<aside>
💡

**"RECEPCION address"**: Se refiere a una única dirección IP específica (ej. la IP de la interfaz).

**"RECEPCION subnets"**: Representa toda la subred asociada (ej. `192.168.1.0/24`).

</aside>

## Probar el bloqueo en el firewall

Para probar ésto, podemos cambiar nuestra VM a la VLAN Tag 1, yendo al switch/adaptador de red que tiene la VM, editarla haciendo doble clic, y especificar **1** en el campo **VLAN Tag**, así:

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2016.png)

Si nuestra máquina virtual está utilizando DHCP para obtener IP, obtendrá una dirección automáticamente. Si eso no pasa, podés ejecutar `systemctl restart networking` en Linux basados en systemd, o `ipconfig /renew` en sistemas Microsoft Windows.

Yo hice `ipconfig` en mi VM con Windows 10, y ya tenía IP:

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2017.png)

Por default, en la red 1 y 2 el router estará en **192.168.1.1** y **192.168.2.1**. Acá se ve como no puedo hacer ping hasta la red 2, pero si en la red 1.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2018.png)

Podríamos deshabilitar la regla, aplicar cambios e inmediatamente podríamos hacer ping.

# PfSense no está dando internet

Sucede que si vamos a **Diagnostics** > **Ping**, podemos probar de hacer una llamada a **google.com** desde la interfaz WAN.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2019.png)

En mi caso, yo tengo internet en mi WAN, es decir, en el enlace que viene de afuera. Pero cuándo el Source address lo cambio a LAN, no tengo más internet. Probé dos cosas:

1. Hacer ping a una IP, como 1.1.1.1: si pudiera hacer ping acá, quiere decir que tengo internet
2. Hacer ping a google.com: si pudiera hacer ping acá, quiere decir que tengo DNS

En mi caso no tengo nada 😂 Para arreglarlo primero debemos atacar el porqué no tenemos internet.

## Motivos por el cuál no tenés internet

Si ya hiciste un ping desde la interfaz **WAN**, como te enseñé arriba, y no hay 100% packet loss…

1. Puede ser que no tenga una regla en el firewall que permita realizar conexiones hacia internet. Podés descartar ésto teniendo una regla única para esa interfaz que necesitás arreglar, y que el source, destination y protocol estén en **Any**.
2. Te faltan los DNS, que se configuran en **System** > **General Setup** bajo el título **DNS Server Settings**. Es importante también marcar la opción Allow DNS server list to be overridden by DHCP/PPP on WAN or remote OpenVPN server.
3. Puede que tengas internet y DNS fuera del firewall, pero no abriste el puerto 53 y 853 y por eso no podés comunicarte con los servidores de dominio (que usan ese puerto).
4. Tenes un gateway asignado en una interfaz LAN/VLAN. Tiene que estar en **None** para el caso de las LAN / VLAN. Después veo de documentar el porqué.

Realmente esos son los 4 casos más comunes. Si no es nada de esto en tu caso, puede que precises una re-instalación de VM o revisar tus tarjetas de red.

# Diagnosticar problemas de Gateway

Puede suceder que el gateway en uso (principal / default) esté andando muy mal, a tal punto que se pierda conexión. Puede suceder que entre que nos notifican y entramos a revisar el problema, ya se haya solucionado solo. Es por ésto que, para cercionarnos si fue un problema de gateway, debemos ir al menú **System** > **System Logs** > **Gateways**. Los logs están de más viejo a más nuevo (al final), así que si scroleamos hasta abajo de todo veremos los últimos logs.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2020.png)

En este caso, se ve claro que hay una pérdida de paquetes bastante grande. Mayor a 2-3% se considera una pérdida importante, sobretodo a nivel router (no estamos hablando de un endpoint específico).

Esto nos sirve para ayudarnos a averiguar si el problema es del gateway o pudo haber sido de otra cosa. En este caso, fue del gateway.

# Cambiar gateway default

En el menú **System** > **Routing** > **Gateways** podremos ver los enlaces que se encargan de darnos internet. Podemos cambiar la ruta de enlace por defecto en la parte inferior de la página, como se ve acá:

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2021.png)

En nuestro caso, estaba en WANGW, La moví a la segunda WAN (WAN2GW) y le dí al botón **Save**. Esto va a refrescar la página y debemos cliquear en **Apply Changes** (botón verde que se mostrará en la zona superior de la página).

# ARP request: can´t find matching address

Edité mis dos OVS bridges y asigné las placas físicas según correspondía, en la opción Slaves/Ports. PfSense empezó a arrojar este error de forma constante.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2022.png)

Probé una restauración y no sucedió nada. La solución fue, luego de intentar varias cosas (restaurar backup, modificar MAC address, restaurar de fábrica), instalar una VM nueva con PfSense.

# Backup

Para realizar un backup completo, nos dirigimos al menú **Diagnostics** > **Backup & Restore**. Debemos marcar las casillas tal cuál las marco yo.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2023.png)

Probablemente te interese realizar backup de los datos de analíticas (RRD data), que incluyen:

- **Uso de la CPU**
- **Consumo de memoria**
- **Uso del disco**
- **Tráfico de red en las interfaces**
- **Conexiones activas**

Eso lo dejo a tu criterio.

# Restaurar

En la parte inferior de la página que encontramos en **Diagnostics** > **Backup & Restore**, podemos elegir nuestro archivo de backup y darle al botón **Restore configuration**. En cuánto hagamos clic en dicho botón, se subirá nuestro archivo y se reiniciará el firewall.

![image.png]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2024.png)

En **Restore area** podremos seleccionar qué queremos restaurar según la configuración hallada en el archivo, pero generalmente se desea realizar al completo.