---
layout: post
title:  "Switch TP-Link SG3428 • Guía de configuración por consola"
date:   2024-11-10 21:00:00 +0000
categories: tp-link switch
tags: switch administrable, switch capa 2, vlan, vlans
---

# Conexión por consola

Debemos tener un cable micro USB (conectado en el switch) a USB (conectado en la PC).

![Hay switches que tienen sólo un conector RJ-45 para acceder a la consola. Otros, ofrecen más conexiones, como la mini o micro USB.]({{ base.url}}/assets/posts/switch-tp-link-sg3428-guia-de-configuracion-por-consola/images.jpg)

Hay switches que tienen sólo un conector RJ-45 para acceder a la consola. Otros, ofrecen más conexiones, como la mini o micro USB.

Ya teniendo **Putty** instalado en la PC, lo abrimos y configuramos el menú **Connection** > **Serial** de la siguiente forma:

| **Clave** | **Valor** | **Explicación** |
| --- | --- | --- |
| Bits per second | 38400 (4,8KB/s) | Bits enviados por segundo. Deben coincidir entre Putty y el dispositivo. |
| Data bits | 8 | Con 8 bits se pueden representar todos los caracteres ASCII, en un único paquete de datos. |
| Stop bits | 1 | Cuántos bits se utilizan al final de un paquete de datos para indicar su fin |
| Parity | None | No se realiza una comprobación de paridad. |
| Flow control | None | Método para manejar los casos dónde los datos llegan más rápido al dispositivo de lo que el dispositivo soporta. Como coinciden entre Putty y el switch, no debemos utilizar ningún Flow Control. |

También debemos dirigirnos al menú **Terminal** > **Keyboard**, y marcar el toggle *The Function keys and keypad* con la opción **VT100+**.

![image.png]({{ base.url}}/assets/posts/switch-tp-link-sg3428-guia-de-configuracion-por-consola/image.png)

Y después vamos a **Session** y dejamos la opción **Serial** marcada, y le damos al botón **Open**:

![image.png]({{ base.url}}/assets/posts/switch-tp-link-sg3428-guia-de-configuracion-por-consola/image%201.png)

Al presionar **ENTER** puede que se abra una terminal en negro, así que apretamos **ENTER** nuevamente y nos pedirá las credenciales. Por default, es el usuario y contraseña **admin**.

En cuánto iniciamos nos pedirá cambiar la contraseña, escribimos **Y** para responder positivamente e indicamos nuestra nueva contraseña.

# La terminal

Una vez que estamos dentro, tenemos un menú simple:

```bash
TL-SG3428 >
  broadcast       - Write message to all users logged in,at most 256 characters
  enable          - Enter Privileged EXEC Mode
  exit            - Exit current mode
  history         - Display command history
```

Por ahora explicaré la opción **enable**, que nos envía al modo privilegiado con un montón de funciones que si valen la pena mostrar 😄 Estando en la terminal, escribimos **enable** y **ENTER**.

<aside>
    <div class="container">
        <p>
💡

Tené en cuenta que todas las acciones que explicaré más adelante, son accesibles si entraste en la opción **enable**.

</p>
    </div>
</aside>

# Re-inicializar switch

Para resetear el switch de fábrica, tendremos que realizar:

```bash
enable
reset
```

Ésto producirá el reinicio del switch, que estará en menos de un minuto de nuevo operativo.

# Guardar cambios

Para guardar cambios realizados en el switch, debemos copiar la configuración temporal a la permanente. Esto se logra de la siguiente manera:

```bash
enable
copy running-config startup-config
```

# Reiniciar

Si por alguna razón necesitás reiniciar (apagarlo y volverlo a encender) el switch, podés correr:

```bash
# Desde el menú principal, no desde el modo
# privilegiado que se entra haciendo 'enable'.
# Si estás en dicho menú privilegiado, escribí
# 'exit' y luego 👇
reboot
```

# Corroborar IP de interfaces VLAN

Para saber la IP de una VLAN, basta con entrar al menú privilegiado y de configuración. Para ello, escribimos `enable` y luego `configure`. Podemos consultar la VLAN deseada con `vlan <ID de la VLAN que querés saber su IP>`.

Este último comando nos dejará dentro de la VLAN, a la cuál podemos consultarle una serie de comandos. Podemos ejecutar `show ip interface` para tener una información como ésta:

```bash
show ip interface
VLAN1 is up, line protocol is up
Primary IP address is 192.168.101.252/24
Broadcast address is 255.255.255.255
Address determined by setup command
Description is not set
MTU is 1500 bytes
ICMP redirects are never sent
ICMP unreachables are never sent
ICMP mask replies are never sent
DHCP Option 12 is not set
DHCP Option 60 is not set

```

# Configurar IP, DHCP y descripción de interfaz VLAN

Es importante remarcar que una **interfaz** es el medio por el cuál la **VLAN** se transporta.

- La interfaz maneja su descripción, leases ARP (gratuitous-arp) e IP, entre sus funciones más importantes.
- La VLAN maneja su ID y su nombre.

<aside>
    <div class="container">
        <p>
👀

Si estás conectado a una VLAN y cambiás a una IP con otra subred, deberías poner tu equipo en esa subred. Ejemplo: si el switch está en 192.168.0.2, y cambiás la dirección de la interfaz a 10.10.10.2.

</p>
    </div>
</aside>

Para realizar las configuraciones que sugiere el título, podemos escribir lo siguiente:

```bash
enable
configure
interface vlan <ID de VLAN a la que querés darle una nueva IP>

# Con el comando "ip", configuramos la dirección IP y la máscara de red
# ip address <dirección deseada> <máscara de subred>
ip address 10.10.20.1 255.255.255.0

# Habilitamos DHCP en la interfaz
ip address-alloc dhcp

# También le podemos dar una descripción a la interfaz
description <la descripción de dicha interfaz>
```

# Configurar VLANs

Podemos escribir `vlan id` , siendo id un número entero, y entramos directamente en la configuración de esta VLAN. En caso de que no exista ese ID, creará una red virtual con dicho ID.

<aside>
    <div class="container">
        <p>
💡

La VLAN 1 no puede modificarse, si deshabilitarse con 

</p>
    </div>
</aside>

Para configurar este apartado, luego de iniciar sesión tipeamos `enable` y `configure`.

Te muestro mi terminal, para que veas los comandos que podemos ejecutar:

```bash
enable
configure
TL-SG3428(config)#vlan 2 # entro a la VLAN 2
TL-SG3428(config-vlan)# **?**
 1 name                - Name of the VLAN
 2 private-vlan        - Configure private VLAN
 3 vlan                - VLAN commands
 4 clear               - Reset functions
 5 end                 - Return to Privileged EXEC Mode
 6 exit                - Exit current mode
 7 history             - Display command history
 8 no                  - Negate command
 9 show                - Display system information
```

## name

Permite colocar un nombre para la VLAN, sin caracteres especiales ni espacios. Ejemplo `name servidores` .

## private-vlan

Esto nos permitirá crear sub-VLANs. Por ejemplo, si el sector administrativo está en dos habitaciones, podríamos crear dos sub-VLANs “Side A” y “Side B”. De éste concepto nace:

- **VLAN Primaria**:
    - Es la VLAN principal que actúa como contenedor para todas las sub-VLANs privadas.
    - Conecta las sub-VLANs privadas con dispositivos o servicios compartidos (por ejemplo, un gateway o servidor).
- **VLANs Secundarias**:
Estas son las sub-VLANs privadas que se asignan a los dispositivos. Pueden ser de dos tipos:
    - **Isolated (Aislada)**: Los dispositivos en esta VLAN no pueden comunicarse entre sí, pero sí pueden comunicarse con la VLAN primaria.
    - **Community (Comunitaria)**: Los dispositivos dentro de esta VLAN pueden comunicarse entre ellos y con la VLAN primaria, pero no con otras VLANs secundarias.

…

# Asignar puerto a VLAN

Si queremos asignar puertos a una red virtual, debemos escribir los siguientes comandos:

```bash
enable
configure
# 1. Entramos al puerto que queremos configurar
interface gigabitEthernet 1/0/<número de puerto que querés configurar>
# 2. Marcamos al puerto como disponible para nuestra VLAN. Es 'untagged'
# porque queremos que vaya el tráfico para nuestras PCs. No es troncal
switchport general allowed vlan <ID de VLAN deseada> untagged
```

## ¿Por qué se usa la notación `interface gigabitEthernet 1/0/24` para referirse al puerto 24 del switch?

Esto es porque es algo que se heredó de los switches modulares, que permiten añadir tarjetas para tener mayor cantidad de puertos.

Si un switch modular tiene dos módulos y nos queremos referir al puerto 8 del módulo dos, la notación sería **2/0/8**. El **0** representa el sub-módulo.

Un sub-módulo puede dividirse por tipos de VLAN, tipos de conectores o velocidad en conectores.

Si bien todo ésto no se utiliza en el switch TL-SG3428, es una notación heredada de los switches más avanzados, y así se usa.

# Asignar puerto troncal

Es similar a darle un puerto a una VLAN.

```bash
enable
configure
# Seleccionamos el puerto deseado para usar como troncal
interface gigabitEthernet 1/0/<puerto deseado>
# Lo habilitamos para las VLANs que queramos, en mi caso entre 1 y 4
switchport general allowed vlan 1,2,3,4 tagged
```

# Ver datos de los puertos

Con el siguiente comando podrás ver la configuración de cada puerto, incluso los SFP+.

```bash
show interface switchport
```

# Reservar IP a un dispositivo con ARP

Este protocolo se utiliza para resolver una dirección IP en una dirección MAC, y de esa forma puede manejar los paquetes. Si bien este switch soporta ARP dinámico (va creando sus relaciones entre IPs y MACs) también admite nuestra intervención para poder reservar una IP para algún dispositivo de nuestro interés.

```bash
enable
configure
# arp <ip deseada> <mac> <type>
arp 192.168.0.200 A6:51:B8:DF:AB:44 arpa
```

| **Sección del comando** | **Descripción** | **Valor válido** |
| --- | --- | --- |
| **IP** | Cualquiera IPv4 | 192.168.0.100 |
| **MAC** | La dirección MAC del dispositivo | A6:51:B8:DF:AB:44 |
| **Type** | Debe ser “arpa”, indicando que es IPv4 | arpa |

Luego de darle **ENTER** a nuestro comando (ejemplo `arp 192.168.0.200 A6:51:B8:DF:AB:44 arpa`), en caso de éxito no arroja ningún mensaje. Si falla, si lo hace.

# Firmwares

Para poder ver los firmwares ya cargados en el switch, podemos utilizar:

```bash
enable
show image-info
Image Info:
Current Startup Image      - Exist & OK
  Image Name               - image1.bin
  Flash Version            - 1.3.0
  Software Version         - 2.0.9

Next Startup Image         - Exist & OK
  Image Name               - image1.bin
  Flash Version            - 1.3.0
  Software Version         - 2.0.9

Backup Image               - Exist & OK
  Image Name               - image2.bin
  Flash Version            - 1.3.0
  Software Version         - 2.0.3
```

# Cambiar imágen de Boot

En caso de que quieras configurar la `image2.bin` como la próxima imágen de arranque, podés escribir:

```bash
enable
configure
boot application filename image2 startup
```

Esto haría que `Next startup Image` sea `image2.bin` , y lo podemos chequear ejecutando de nuevo `show image-info`.

# Ver configuración de backup

Si queremos chequear el archivo de configuración de respaldo, podemos simplemente ejecutar:

```bash
enable
show backup-config
```

!! Esto nos dará un detalle de la configuración respaldada, que luego podemos realizar backup por TFTP.

# Backup de la configuración (TFTP)

El backup ideal es fuera del switch, y para ello debemos configurar un TFTP Server.

1. Descargamos **Open TFTP Server**. Al instalar, dejamos todo por defecto así se instala en `C:\OpenTFTPServer\` .
2. Utilizamos este archivo de configuración, suponiendo que mi equipo dónde tengo el firmware está en la IP `192.168.101.1` y el switch en la `192.168.101.252`. En `C:\OpenTFTPServer\OpenTFTPServerMT.ini` debemos dejar sólo este contenido:

```bash
[HOME]
BaseDirectory=C:\OpenTFTPServer
ServerIP=192.168.101.1
TFTPSERVERPORT=69

[Security]
WriteSecurity=1
ReadSecurity=1
IPAddressRange=192.168.101.252-192.168.101.252
```

1. Ahora en el switch, realizamos el backup con los datos de IP del servidor.

```bash
copy tftp backup-config 192.168.101.1 filename config
```

# Actualizar firmware

Tengo el puerto TFTP bloqueado. Falta probar.

Es importante tener la última versión, por motivos de seguridad. Además, cada versión de software brinda soporte a nuevas versiones de Omada, arreglos a bugs, mejoras en performance, etc.

Este proceso involucra un programa extra y varios pasos:

1. Revisar qué versión es nuestro switch, físicamente en la etiqueta que tiene pegada en alguno de sus lados.

![image.png]({{ base.url}}/assets/posts/switch-tp-link-sg3428-guia-de-configuracion-por-consola/image%202.png)

1. Sabiendo que es V2.0 (al menos en mi caso), busco en Google “TL-SG3428 V2.0 firmware”.
2. Descargué la versión 2.0.11 de [acá](https://www.tp-link.com/ar/support/download/tl-sg3428/v2/#Firmware) (insisto en que revises la versión de su TL-SG3428, y la región de la BIOS sea Argentina).
3. Descargamos **Open TFTP Server**. Al instalar, dejamos todo por defecto así se instala en `C:\OpenTFTPServer\` .
4. Utilizamos este archivo de configuración, suponiendo que mi equipo dónde tengo el firmware está en la IP `192.168.101.1` y el switch en la `192.168.101.252`. En `C:\OpenTFTPServer\OpenTFTPServerMT.ini` debemos dejar sólo este contenido:

```bash
[HOME]
BaseDirectory=C:\OpenTFTPServer
ServerIP=192.168.101.1
TFTPSERVERPORT=69

[Security]
WriteSecurity=0
ReadSecurity=1
IPAddressRange=192.168.101.252-192.168.101.252
```

1. Ahora descomprimimos el archivo de firmware descargado de TL-SG3428. Movemos el archivo de extensión .bin hasta `C:\OpenTFTPServer\firmware.bin` (si, con nombre `firmware.bin` así es más fácil identificarlo).

<aside>
    <div class="container">
        <p>
💡

Veremos que el archivo comprimido descargado de TP-Link, tiene una guía para actualizarlo desde la web, pero lo haremos por Consola porque la web podríamos apagarla al estar en producción.

</p>
    </div>
</aside>

1. Ejecutamos en el switch el comando `enable` para entrar al modo privilegiado, luego `firmware upgrade tftp 192.168.101.1 filename firmware.bin`. Recordá que la IP de mi PC es `192.168.101.1`, adaptalo a tu caso.
2. Al finalizar la transferencia, preguntará si queremos bootear con esta nueva imágen. Respondemos con **Y** y listo.

# Configure • Hostname

Para darle un nombre al switch, simplemente:

```bash
enable
configure
hostname <nuevo-nombre>
```

Si lo hicimos bien, veremos que también cambiará el hostname en la consola.

![image.png]({{ base.url}}/assets/posts/switch-tp-link-sg3428-guia-de-configuracion-por-consola/image%203.png)

.