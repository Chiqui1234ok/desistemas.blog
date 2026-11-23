---
layout: post
title:  "PfSense • Guía de configuración en Proxmox"
date:   2024-12-02 21:00:00 +0000
tags: pfsense, firewall, router, proxmox, vlan, vlans
---

## Convenciones

- Cuando digo **PC**, **Nodo**, **Servidor** o **Hipervisor**, me refiero a lo mismo: el equipo con Proxmox que estamos preparando para instalar pfSense.

Parte de este post se basa en un trabajo de documentación y estabilización de un PfSense existente, que depende de OpenVSwitch en un entorno Proxmox 8.

## Introducción

Acá explicaré cómo podemos configurar un entorno de producción en pfSense, que también sirve para pruebas. Si bien no tengo tantas placas de red para dedicar un cable a cada red virtual, en esta guía envié dos troncales (una desde cada placa de red), y la explicación sirve para cualquier implementación:

- Un cable troncal que lleve todas las redes virtuales.
- Dos cables troncales (se reparten las VLAN), que es mi caso.
- Un cable por VLAN (lo mejor si tener 1 Gbit por red es prioritario).

Enseñaré cómo darle uso a las VLAN en equipos físicos y virtuales, siendo estas últimas unas facilitadoras para configurar el pfSense y probar la red.

## Instalación de `openvswitch-switch`

Ejecutamos los siguientes comandos, que instalarán `openvswitch-switch` y `openvswitch-common` (menos de 6 MB en disco):

```bash
apt update
apt install openvswitch-switch
```

## Identificar las WAN

En mi caso, sé que la interfaz **vmbr0** es la que le da IP a mi Proxmox, y podemos utilizarla como WAN en pfSense. Si tuvieras dos interfaces WAN, agregarás las dos a la VM de pfSense. Por el momento, solo identificalas y prosigamos; las agregaremos más adelante.

> 💡 **Nota:** Está la opción de juntar ambas WAN dentro de un OVS Bond para que sea un único dispositivo, pero creo que es mejor que ese manejo lo haga pfSense, como en una máquina real.

## Bridges y VLAN en Proxmox

Yo tengo dos placas de red: `enp3s0` (PCI-E inferior) y `enp4s0` (PCI-E superior). Crearé un bridge para cada una y montaré distintas VLAN en cada una.

Con esto quiero decir que, a partir de dos placas de red, tendré dos troncales configuradas así:

- `vmbr1000`:
  - VLAN 1: `sistemas_servidores` (Sistemas y servidores)
  - VLAN 2: `recepcion` (Recepción)
- `vmbr1001`:
  - VLAN 3: `profesionales` (Profesionales)
  - VLAN 4: `imp_wifi` (Impresoras y WiFi)

La idea es configurar una red relativamente sencilla que nos permita entender los bridges, el firewall y sus reglas, diagnosticar problemas de red y más.

Como habrás notado, no armé una VLAN para el sector administrativo, puesto que mi caso de prueba se trata de una clínica chiquita.

### Bridge a `enp4s0`

> 💡 **Nota:** Primero haré la configuración de `enp4s0`, porque parece que está invertido el orden en mi PC de laboratorio; es decir, la tarjeta `enp4s0` está arriba de la `enp3s0`, físicamente hablando.

Bastante fácil: indicamos el nombre de red `vmbr1000` y un comentario para saber de qué trata este bridge (porque seguramente en la merienda de ese mismo día te olvidás, pasa).

![Configuración del bridge vmbr1000 en Proxmox]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image.png)

No te olvides de añadir `enp4s0` en el campo **Bridge ports**; caso contrario, ¡tendrás VLAN pero solo para equipos virtuales! Justamente para que las VLAN vayan a equipos físicos, necesitamos montar el bridge en un dispositivo físico 😄.

### Bridge a `enp3s0`

Lo mismo, pero acomodando el **Name** a `vmbr1001` y el **Comment** en *LAN2 PfSense*.

### VLAN a `vmbr1000`

Recordemos que `enp4s0` = `vmbr1000`. Vamos al botón **Create** y seleccionamos la opción **OVS IntPort**.

> 💡 **¿Qué es un OVS IntPort?** Es como el grupo de puertos que puede utilizar una red virtual determinada. Soporta *n* cantidad de puertos. La cantidad de puertos por VLAN se configura en el switch administrable.

Debemos crear nuestra primera VLAN para el puente `vmbr1000`. A mí me gusta que coincida la cantidad de cifras entre VLAN y bridges, por lo cual procedo a crear la primera VLAN con **tag 1**:

![Creación de OVS IntPort vlan1000 con tag 1]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%201.png)

Hago lo mismo con el mismo adaptador (bridge), pero esta vez poniendo el **Name** en `vlan1001` y **VLAN Tag** en `2`.

### VLAN a `vmbr1001`

Lo mismo que en el apartado anterior, solo que ahora apuntamos al bridge **vmbr1001** y tanto el nombre como su tag seguirán incrementándose en una unidad. Es decir, si quiero crear dos VLAN más:

- **Name**: `vlan1002`, **OVS Bridge**: `vmbr1001`, **VLAN Tag**: `3`
- **Name**: `vlan1003`, **OVS Bridge**: `vmbr1001`, **VLAN Tag**: `4`

## Resultado: 2 VLAN por bridge

> ❓ **Tip:** Si quisieras enviar un cable independiente por cada VLAN con el fin de tener más ancho de banda, deberías crear un bridge por cada VLAN y asignarle un único **OVS IntPort** a cada bridge.

Luego de crear los 2 bridges y 4 VLAN totales, nuestro apartado **Network** en Proxmox quedaría así:

![Resumen de interfaces y VLAN creadas en Proxmox]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%202.png)

Apretamos el botón **Apply Configuration**, esperamos a que aplique todo y procedemos a instalar pfSense.

![Aplicar configuración de red en Proxmox]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%203.png)

## Instalar pfSense

Creamos la máquina virtual según [indica la documentación oficial](https://docs.netgate.com/pfsense/en/latest/recipes/virtualize-proxmox-ve.html), salvo que no debemos indicar ninguna interfaz de red en el asistente; las agregaremos a continuación.

Luego de seleccionar la VM (en mi caso, “pfsense” de ID 200), debemos darle al botón **Add** > **Network Device** para añadir el bridge WAN **vmbr0** y los dos adaptadores que se repartirán las VLAN (**vmbr1000** y **vmbr1001**).

![Agregar dispositivo de red a la VM en Proxmox]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%204.png)

A estos dos últimos bridges mencionados prefiero destildarles la opción **Firewall** a la hora de agregarlos, porque quiero que este tema lo maneje completamente pfSense, tanto para el tráfico de entrada como de salida.

### Máquina virtual creada

Quedará algo así, ya con la ISO cargada para instalar pfSense y los 3 adaptadores de red:

![Resumen de hardware de la VM de pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%205.png)

### Preparación de la BIOS UEFI

Para bootear correctamente la ISO en chipset Q35 y UEFI, debemos apretar en el teclado `ESC` apenas inicia la VM y vemos el logo de Proxmox. Esto nos llevará a la configuración de la BIOS: **Device Manager** > **Secure Boot Configuration** > **Attempt Secure Boot** y apretamos la barra espaciadora para desactivarlo. Presionamos `F10` para guardar y `ESC` hasta volver al menú principal, donde entramos a la opción **Continue** para proceder con el booteo.

### Instalación

![Pantalla de bienvenida del instalador de pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%206.png)

La bienvenida es ese documento: le damos **Accept** y luego a la opción **Install pfSense**, donde nos mostrará los adaptadores de red.

![Selección de interfaz WAN durante la instalación]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%207.png)

Para comprobar cuál es la WAN, podemos entrar a la pestaña **Hardware** de nuestra VM en Proxmox y revisar qué dirección MAC tiene la **vmbr0**.

> 💡 **Importante:** Conviene revisar las MAC, porque puede que no las muestre en el orden esperado. Tuve suerte en esta ocasión (es que el que escribe el tutorial nunca se equivoca y todo le funciona).

![Configuración de IP estática en la WAN]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%208.png)

Cuando elegimos nuestro adaptador de red, presionamos **OK** y luego tocamos la opción **Interface Mode** hasta que quede en modo **STATIC**. Ahí se habilita **IP Address** (del pfSense), **Default Gateway** y **DNS Server**. Al terminar de escribir todos esos datos, le damos a la opción **Continue**.

Toca configurar las interfaces LAN, pero le damos al botón **SKIP** y continuamos. Se intentará conectar a los servidores de Netgate en búsqueda de una licencia que no tenemos, así que nos dará la opción de instalar en modo **CE**, a lo que accedemos.

![Selección de instalación pfSense CE]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%209.png)

Luego de usar el botón **Install CE**, le damos a **Continue** y **OK** cuando pregunta si queremos instalar pfSense en modo *stripe* (en un solo disco y sin redundancia). Si pregunta la rama, instalamos la versión estable (nunca la *deprecated*, *short term support* ni *nightly*).

Al terminar, pedirá reiniciar. Dejamos que inicie y nos preguntará si queremos configurar las VLAN.

### Configuración de VLAN en pfSense

Al iniciar pfSense, en su terminal veremos un mensaje que pregunta si queremos configurar las VLAN, a lo que responderemos que sí con la tecla `y` y luego apretamos `Enter`.

Nos listará nuestras interfaces:

![Listado de interfaces de red en la consola de pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2010.png)

En mi caso:

- *vtnet1*: `vmbr1000` (`vlan1000` y `vlan1001`)
  - Entonces debe indicarse *vtnet1* con VLAN tag `1`, y luego *vtnet1* con VLAN tag `2`.
- *vtnet2*: `vmbr1001` (`vlan1002` y `vlan1003`)
  - Entonces debe indicarse *vtnet2* con VLAN tag `3`, y luego *vtnet2* con VLAN tag `4`.

Dejo el *output* de mi consola para que se entienda mejor qué escribí y cómo asigné los tags de las VLAN. Ejemplo con **vtnet2**:

```bash
# "vtnet2" y el tag 3 los puse yo
Enter the parent interface name for the new VLAN (or nothing if finished): vtnet2
Enter the VLAN tag (1-4094): 3
# "vtnet2" y el tag 4 los puse yo
Enter the parent interface name for the new VLAN (or nothing if finished): vtnet2
Enter the VLAN tag (1-4094): 4
# Esto que está arriba también lo hice para la vtnet1, con los tags 1 y 2
```

**Cuando termines de crear tus VLAN**, apretá `Enter` sin escribir nada y te mostrará el resumen. Debería quedar algo así:

```bash
VLAN interfaces:
vtnet1.1    VLAN tag 1, parent interface vtnet1
vtnet1.2    VLAN tag 2, parent interface vtnet1
vtnet2.3    VLAN tag 3, parent interface vtnet2
vtnet2.4    VLAN tag 4, parent interface vtnet2
```

Luego de informarnos sobre nuestra asignación, nos pregunta qué interfaz es la WAN. En mi caso, es **vtnet0**. Cuando pregunta por la LAN, indicamos una interfaz (en mi caso es **vtnet1**) y presionamos `Enter`. Luego hacemos lo mismo con la interfaz *vtnet2*, que se la asignamos a la opcional (es decir, cuando pregunta por la opcional, escribimos **vtnet2** y presionamos `Enter`).

Quedará así:

![Asignación de interfaces WAN, LAN y OPT1 en consola]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2011.png)

### Asignación de IP a la interfaz LAN

![Menú principal de consola de pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2012.png)

En la opción **2**, podremos indicar la IP de cada interfaz, por lo cual si pregunta si queremos utilizar DHCP, **respondemos que no**. Como queremos darle IP a la **LAN** (*vtnet1*, en mi caso), seleccionamos la opción `2`:

```bash
Available interfaces:
1 - WAN (vtnet0 - dhcp, dhcp6)
2 - LAN (vtnet1)
3 - OPT1 (vtnet2)
```

Preguntará por la IP: en mi caso quiero que la LAN sea **192.168.0.1** y la submáscara `255.255.255.0` (esto lo responderemos luego de colocar la IP y presionar `Enter`).

Hace una serie de preguntas; yo las respondí así (ya me encargaré de explicar por qué dice “Non-local gateway”):

![Configuración de IP de la interfaz LAN en consola]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2013.png)

Simplemente leemos lo que nos informa y nos devolverá al menú principal, donde nos dice que la IP de la LAN es **192.168.0.1**.

#### Paréntesis: Non-local gateway detected

Este mensaje aparece porque el gateway al que apunta la interfaz WAN en pfSense no está en la misma subred que la WAN.

> 💡 **Ejemplo:** Podría suceder que la IP obtenida en el pfSense sea `192.168.21.215` (que en mi caso está bien, porque estoy en la subred 21), pero el gateway configurado apunta a `192.168.0.254`.

Si surge este error, vamos a la opción 2 (**Set interface(s) IP address**). Nos preguntará por la interfaz que queremos editar, así que le indicamos el número que identifica a la WAN (en mi caso, es el número `1`).

Indicamos que no queremos configurarlo por DHCP, sino nosotros mismos. Voy a pegar todo el *output* de la consola; por favor prestá atención a mis respuestas teniendo en cuenta que mi gateway está en `192.168.21.254`, con una submáscara `255.255.255.0`:

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

## Conectarse a la LAN mediante una VM extra

Levantamos alguna máquina virtual que tenga asignado el mismo bridge de red que usamos para la LAN, en mi caso **vmbr1000**.

Como nos indica el menú principal de pfSense, la LAN está en **192.168.0.1/24** y el router está usando la **192.168.0.1**.

Desde esta VM nueva (con Linux o Windows), podemos abrir el navegador, ir a esa IP y conectarnos. Las credenciales por defecto son:

- **Usuario:** `admin`
- **Contraseña:** `pfsense`

Si nos vamos al menú **Interfaces** > **VLANs**, veremos esto:

| Interface | VLAN tag |
| --- | --- |
| vtnet1 (lan) | 1 |
| vtnet1 (lan) | 2 |
| vtnet2 (opt1) | 3 |
| vtnet2 (opt1) | 4 |

## Asignar VLAN a interfaces

> 💡 **Referencia:** Se explica la configuración muy bien en la [documentación oficial](https://docs.netgate.com/pfsense/en/latest/vlan/configuration.html#web-interface-vlan-configuration) y se complementa con la guía de acá.

En **Interfaces** > **Interface Assignments**, tenemos un ítem que dice **Available network ports** y, si lo abrimos, encontramos un menú desplegable con todas las VLAN. Debemos seleccionar todas las VLAN (una a una) y darle al botón **Add**. Al agregar todas, se debería ver como esto:

| Interface | Network port |
| --- | --- |
| WAN | *vtnet0* (3e:70:b7:14:39:94) |
| LAN | *vtnet1* (76:bf:7a:f8:36) |
| OPT1 | *vtnet2* (fa:59:84:e6:f4) |
| OPT2 | VLAN 1 on *vtnet1* - lan |
| OPT3 | VLAN 2 on *vtnet1* - lan |
| OPT4 | VLAN 3 on *vtnet2* - opt1 |
| OPT5 | VLAN 4 on *vtnet2* - opt1 |

Si está todo bien, le damos al botón **Save**.

## Editar configuración de una interfaz

En **Interfaces** > **Assignments** tenemos el listado de nuestra WAN, las dos LAN (que tienen 2 hijos cada una; es decir, manejan dos VLAN) y las 4 VLAN creadas.

El objetivo es entrar al nombre de cada interfaz y asignarle una etiqueta descriptiva. Yo dejaría **WAN**, **LAN** y **LAN2** como están, pero voy a entrar a VLAN1, VLAN2, VLAN3 y VLAN4 (que ya la cambié a **imp_wifi**, como se ve en la imagen).

![Listado de interfaces asignadas en la interfaz web de pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2014.png)

Fijate que te marqué las interfaces a las que debemos entrar y otorgarles un nombre adecuado.

Al entrar a la configuración de VLAN4 (que yo de apurado ya le cambié el nombre a **imp_wifi**), podemos ver estos campos de configuración, sumamente importantes:

![Configuración general y dirección IPv4 estática de la interfaz VLAN]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2015.png)

Es probable que la casilla **Enable interface** esté desactivada; debemos activarla para poder utilizar esta VLAN. Después, hay opciones clave para configurar:

- **IPv4 Configuration Type:** `Static IPv4`
- **IPv6 Configuration Type:** `None` (porque no utilizamos la versión 6 y además evitamos vectores innecesarios de ataque).
- **MTU:** Por defecto es `1500` (y recomendado). Podríamos aumentar esto a `9000` (*Jumbo frames*) si llegara a ser conveniente y todos los dispositivos de la red soportan ese tamaño de paquetes. Usualmente se deja en `1500` o vacío.
- **IPv4 Address:** El rango de direcciones que deseamos tener para esa VLAN. Al escribir `192.168.4.1/24`, estamos indicando que la submáscara es `255.255.255.0` y se podrán asignar IPs desde `192.168.4.2` hasta `192.168.4.254` (reservando `.1` para pfSense).

Luego de especificar estos datos, le damos al botón azul **Save**. La página se refrescará y, en la parte superior, aparecerá el botón verde **Apply Changes**.

## DHCP

En **Services** > **DHCP Server** (o configurando el backend *Kea DHCP* en **System** > **Advanced** > **Networking**) podemos habilitar el servidor DHCP en cada interfaz VLAN.

> 💡 **Recomendación:** Conviene no activar DHCP para la LAN base y moverse dentro de una VLAN, porque la LAN padre no la usaremos directamente para conectar clientes. La interfaz física sí deberá estar habilitada, porque es padre de dos redes virtuales y nos servirá para enviar la troncal hasta el switch (esta explicación aplica para `LAN`, `LAN2`, `LAN<n>`...).

Fijate que la opción **DNS Servers** está vacía y hay un *placeholder* en el campo que nos indica que, por defecto, está apuntando al mismo pfSense. Esto es conveniente porque podemos editar nuestros DNS en **System** > **General Setup** y se actualizarán automáticamente en todas las redes que apunten al pfSense.

Te invito a revisar toda la página, porque también hay opciones como **Domain Name** que pueden ser específicas para cada red.

También, más abajo en **System** > **Advanced** > **Networking**, debemos deshabilitar **Allow IPv6** y darle al botón **Save** situado en la parte inferior de la página.

## DNS Servers

En **System** > **General Setup** podemos asignar las IPs de los servidores DNS que queramos bajo el título **DNS Server Settings**. Al agregar las IPs, hacé clic en **Save** (al final de la página).

Podemos agregar los DNS de Cloudflare y Google:

- `1.1.1.1`
- `1.0.0.1`
- `8.8.8.8`
- `8.8.4.4`

## Deshabilitar Hardware Checksums con tarjetas VirtIO

Cuando usamos interfaces de red VirtIO en Proxmox, la descarga de suma de verificación por hardware (*Hardware Checksum Offloading*) debe estar desactivada. pfSense suele hacerlo por defecto, pero debemos corroborarlo porque, si llega a quedar activa, no pasará el tráfico correctamente por el firewall. Además, si notás que la interfaz web o las transferencias tienen *lag*, desactivar esta función también lo resolverá.

Nos dirigimos a **System** > **Advanced** > **Networking**, buscamos la sección **Network Interfaces** y marcamos (tildamos) la casilla **Disable hardware checksum offload**. Le damos al botón **Save** y reiniciamos el firewall desde **Diagnostics** > **Reboot**.

## Firewall

Esto que voy a explicar lo vi en el pfSense de Talcahuano y me pareció muy útil realizarlo así. Nos ahorra, por ejemplo, el error de principiante de tener los puertos `53` y `853` bloqueados, lo cual nos impide comunicarnos con los DNS y resolver nombres de dominio a pesar de tener todo el resto bien configurado (hay internet, hay gateway con DNS, ya podemos hacer ping a IPs, etc.).

Este *approach* viene bien cuando debemos darle más libertad que bloqueos a una red.

### Procedimiento

1. Primero creamos una regla para autorizar todos los protocolos (**importante:** esta regla debe quedar debajo de todas las demás):
   1. Tomaré de ejemplo la VLAN 1, que es la de Sistemas y Servidores.
   2. Nos dirigimos a **Firewall** > **Rules** > **SISTEMAS_SERVIDORES**.
   3. Elegimos las siguientes opciones. Después le damos al botón azul **Save**, que refrescará la página y mostrará el botón **Apply Changes** para hacer efectivos los cambios. Las opciones que debemos configurar para **sistemas_servidores** son:

      | Campo | Valor |
      | --- | --- |
      | **Action** | `Pass` |
      | **Disabled** | Desmarcado |
      | **Interface** | `SISTEMAS_SERVIDORES` |
      | **Address Family** | `IPv4` (por nada en el mundo utilizamos IPv6) |
      | **Protocol** | `Any` |
      | **Source** | `Any` |
      | **Invert match (Source)** | No marcado |
      | **Destination** | `Any` |
      | **Invert match (Destination)** | Desmarcado |
      | **Log** | Desmarcado |
      | **Description** | `Permitir la conexión en todos los protocolos y dispositivos` |

2. Creamos reglas para bloquear el acceso a otras VLAN y las dejamos habilitadas (o no) según la necesidad del negocio. Esto debe ubicarse **arriba** de la regla creada en el punto 1, ya que queremos que se evalúe primero. De esta forma, la regla permisiva del punto anterior quedará restringida por las reglas superiores.
3. Podemos restringir el acceso de la VLAN **sistemas_servidores** hacia **recepcion**. En el caso de la VLAN de sistemas, como es un entorno controlado y lo usarán los administradores, me interesa que **sí** sepan que se está bloqueando la conexión para que sea más fácil *debuggear* la red virtual. Para este caso, el valor de **Action** será `Reject`, para que el firewall informe al dispositivo que no podrá llegar a esa dirección IP. En cambio, la opción `Block` descarta los paquetes en silencio y hace que la máquina cliente se quede reintentando la conexión hasta agotar el tiempo de espera (*timeout*).

| Campo | Valor |
| --- | --- |
| **Action** | `Reject` |
| **Disabled** | Desmarcado |
| **Interface** | `SISTEMAS_SERVIDORES` |
| **Address Family** | `IPv4` (por nada en el mundo utilizamos IPv6) |
| **Protocol** | `Any` |
| **Source** | `SISTEMAS_SERVIDORES net` |
| **Invert match (Source)** | No marcado |
| **Destination** | `RECEPCION subnets` |
| **Invert match (Destination)** | Desmarcado |
| **Log** | Desmarcado |
| **Description** | `Bloquear tráfico desde Sistemas hacia Recepción` |

> 💡 **Diferencia entre `address` y `subnets`:**
> - **"RECEPCION address":** Se refiere a una única dirección IP específica (por ejemplo, la IP de la interfaz en pfSense).
> - **"RECEPCION subnets":** Representa toda la subred asociada (por ejemplo, `192.168.1.0/24`).

### Probar el bloqueo en el firewall

Para probar esto, podemos cambiar nuestra VM de prueba a la VLAN Tag 1, yendo al adaptador de red de la VM en Proxmox, editándolo haciendo doble clic y especificando **1** en el campo **VLAN Tag**, así:

![Asignación de VLAN Tag 1 en el adaptador de red de una VM en Proxmox]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2016.png)

Si nuestra máquina virtual está utilizando DHCP para obtener IP, recibirá una dirección automáticamente. Si eso no pasa, podés ejecutar `systemctl restart networking` en distribuciones Linux basadas en systemd, o `ipconfig /renew` en sistemas Microsoft Windows.

Yo ejecuté `ipconfig` en mi VM con Windows 10 y ya tenía IP asignada:

![Resultado de ipconfig en Windows 10 con IP de la VLAN 1]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2017.png)

Por defecto, en las redes 1 y 2 el router estará en **192.168.1.1** y **192.168.2.1**. Acá se ve cómo no puedo hacer ping hasta la red 2, pero sí dentro de la red 1:

![Prueba de ping bloqueado entre VLAN 1 y VLAN 2]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2018.png)

Si deshabilitáramos la regla y aplicáramos los cambios, inmediatamente volveríamos a tener respuesta de ping.

## pfSense no está dando internet

Sucede que si vamos a **Diagnostics** > **Ping**, podemos probar hacer una llamada a **google.com** desde la interfaz WAN:

![Diagnóstico de Ping desde la interfaz WAN en pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2019.png)

En mi caso, yo tengo internet en mi WAN (es decir, en el enlace que viene de afuera), pero cuando el **Source address** lo cambio a LAN, no tengo salida a internet. Probé dos cosas:

1. Hacer ping a una IP pública, como `1.1.1.1`: si responde, quiere decir que hay salida a internet.
2. Hacer ping a `google.com`: si responde, quiere decir que también funciona la resolución DNS.

En mi caso no tenía respuesta de nada 😂. Para arreglarlo, primero debemos identificar por qué no tenemos internet.

### Motivos por los cuales no tenés internet

Si ya hiciste un ping desde la interfaz **WAN**, como te enseñé arriba, y no hay *100% packet loss*:

1. **Falta una regla en el firewall:** Puede ser que no tengas una regla en esa interfaz que permita realizar conexiones hacia internet. Podés descartar esto creando una regla para la interfaz que necesitás arreglar con *Source*, *Destination* y *Protocol* en **Any**.
2. **Faltan los servidores DNS:** Se configuran en **System** > **General Setup** bajo el título **DNS Server Settings**. Es importante también marcar la opción *Allow DNS server list to be overridden by DHCP/PPP on WAN or remote OpenVPN server* si tu proveedor te entrega los DNS dinámicamente.
3. **Puertos DNS bloqueados:** Puede que tengas internet y DNS fuera del firewall, pero no abriste los puertos `53` y `853` en las reglas de la interfaz y por eso los clientes no pueden comunicarse con los servidores de nombres.
4. **Gateway asignado en una interfaz LAN/VLAN:** El campo *IPv4 Upstream gateway* tiene que estar en **None** para las interfaces internas (LAN / VLAN). Si le asignás un gateway a una LAN, pfSense la interpreta como una segunda interfaz WAN, lo que rompe el enrutamiento interno y las reglas automáticas de NAT saliente.

Realmente esos son los 4 casos más comunes. Si no es nada de esto en tu caso, puede que precises revisar la configuración de tus tarjetas de red o reinstalar la VM.

## Diagnosticar problemas de Gateway

Puede suceder que el gateway en uso (principal / *default*) esté funcionando muy mal, a tal punto que se pierda la conexión. También pasa que, entre que nos notifican y entramos a revisar el problema, ya se haya estabilizado solo. Es por esto que, para cerciorarnos de si fue un problema de gateway, debemos ir al menú **System** > **System Logs** > **Gateways**. Los registros están ordenados del más viejo al más nuevo (al final), así que si scrolleamos hasta abajo de todo veremos los últimos eventos:

![Logs de estado y pérdida de paquetes del Gateway en pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2020.png)

En este caso, se ve claro que hay una pérdida de paquetes bastante grande. Un valor mayor a 2-3 % se considera una pérdida importante, sobre todo a nivel router (no estamos hablando de un *endpoint* específico).

Esto nos sirve para averiguar rápidamente si el corte vino del enlace externo o de la red interna. En este caso, fue del gateway.

## Cambiar gateway default

En el menú **System** > **Routing** > **Gateways** podremos ver los enlaces que se encargan de darnos internet. Podemos cambiar la ruta de enlace por defecto en la parte inferior de la página, como se ve acá:

![Selección de Default Gateway en System > Routing > Gateways]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2021.png)

En nuestro caso, estaba en `WANGW`; lo moví a la segunda WAN (`WAN2GW`) y le di al botón **Save**. Esto refresca la página y debemos cliquear en **Apply Changes** (botón verde que se mostrará en la zona superior).

## Error: `ARP request: can't find matching address`

En una ocasión edité mis dos OVS bridges y reasigné las placas físicas según correspondía en la opción *Slaves/Ports*. Tras ese cambio, pfSense empezó a arrojar este error de forma constante en consola:

![Error ARP request can't find matching address en consola de pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2022.png)

Probé una restauración y no se resolvió. La solución definitiva, luego de intentar varias alternativas (restaurar backup, modificar MAC address, restaurar de fábrica), fue instalar una VM nueva de pfSense desde cero e importarle el backup de configuración.

## Backup

Para realizar un backup completo, nos dirigimos al menú **Diagnostics** > **Backup & Restore**. Debemos marcar las casillas tal cual se muestra en la captura:

![Opciones de descarga de backup en Diagnostics > Backup & Restore]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2023.png)

Probablemente te interese incluir también los datos de analíticas (**RRD data**), que guardan el historial de:

- **Uso de la CPU**
- **Consumo de memoria**
- **Uso del disco**
- **Tráfico de red en las interfaces**
- **Conexiones activas**

Eso lo dejo a tu criterio según cuánto espacio quieras que ocupe el archivo XML.

## Restaurar

En la parte inferior de la misma página (**Diagnostics** > **Backup & Restore**), podemos elegir nuestro archivo de respaldo y darle al botón **Restore Configuration**. En cuanto hagamos clic en dicho botón, se subirá el archivo y se reiniciará el firewall automáticamente:

![Sección Restore Configuration en pfSense]({{ base.url }}/assets/posts/pfsense-guia-de-configuracion-en-proxmox/image%2024.png)

En **Restore area** podremos seleccionar qué sección específica queremos restaurar según la configuración hallada en el archivo, aunque generalmente se deja en **All** para realizar una restauración completa.

---

¡Y listo! Con esta configuración ya tenés un entorno virtualizado con pfSense y Proxmox listo para segmentar redes mediante VLAN, administrar reglas de firewall y diagnosticar enlaces de forma ordenada.