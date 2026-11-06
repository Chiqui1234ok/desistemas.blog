---
layout: post
title:  "Switch HP V1910-24G • Guía de configuración"
date:   2024-10-30 20:30:00 +0000
categories: hp switch
tags: switch administrable, switch capa 2, vlan, vlans
---

Esta guía de configuración es para el **HP V1910-24G JE006A**.

# Switch por default

Si el switch está reseteado de fábrica y no está conectado a ningún servidor DHCP y por ende no tiene IP, tendrá una IP auto-asignada que es **169.254.52.86** y la máscara de subred es 255.255.0.0.

Por ende, podemos configurar nuestra red para encontrar el switch. Estando conectados a él mediante cable, podemos utilizar una configuración como la siguiente:

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image.png)

Podemos ir a la IP del switch con las credenciales por default, que es el usuario **admin** y la contraseña vacía.

## Conexión por consola

Debemos tener un cable RJ-45 a DB9 (Puerto Serie). Si tenemos una PC relativamente moderna, también se precisa tener un adaptador DB9 a USB.

<aside>
💡

Si no tenés el driver ya instalado, Windows 10/11 debería instalarte uno automáticamente. Revisa el Administrador de dispositivos y al tener el dispositivo COM instalado, ya podés trabajar.

</aside>

El puerto serie **no** es plug&play, así que hay una posibilidad de que, con el DB9 conectado, haya que reiniciar la PC y probar de nuevo a conectarse con Putty.

![Hay switches que tienen sólo un conector RJ-45 para acceder a la consola. Otros, ofrecen más conexiones, como la mini o micro USB.]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/images.jpg)

Hay switches que tienen sólo un conector RJ-45 para acceder a la consola. Otros, ofrecen más conexiones, como la mini o micro USB.

Ya teniendo **Putty** instalado en la PC, lo configuramos así en el menú **Connection** > **Serial**:

| **Clave** | **Valor** | **Explicación** |
| --- | --- | --- |
| Bits per second | 38400 (4,8KB/s) | Bits enviados por segundo. Deben coincidir entre Putty y el dispositivo. |
| Data bits | 8 | Con 8 bits se pueden representar todos los caracteres ASCII, en un único paquete de datos. |
| Stop bits | 1 | Cuántos bits se utilizan al final de un paquete de datos para indicar su fin |
| Parity | None | No se realiza una comprobación de paridad. |
| Flow control | None | Método para manejar los casos dónde los datos llegan más rápido al dispositivo de lo que el dispositivo soporta. Como coinciden entre Putty y el switch, no debemos utilizar ningún Flow Control. |

También debemos dirigirnos al menú **Terminal** > **Keyboard**, y marcar el toggle *The Function keys and keypad* con la opción **VT100+**.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%201.png)

Y después vamos a **Session** y dejamos la opción **Serial** marcada, y le damos al botón **Open**:

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%202.png)

Al presionar **ENTER** nos pedirá login. Por default, es el usuario **admin** y contraseña vacía. Le damos **ENTER** para loguearnos.

## Ayuda de terminal

Podremos apretar la tecla **?** en nuestro teclado para tener una lista de los comandos básicos (restaurar de fábrica, especificar la IP de la VLAN 1, configurar contraseñas de usuarios, ping, información del dispositivo, actualizar el firmware, reiniciar y salir). Lo que no explico acá, está obviamente en el manual.

Es verdad que lo avanzado está en la interfaz web, pero por acá podremos realizar operaciones básicas y no por eso poco útiles. A continuación dejo algunas cosas que podemos hacer:

## 1. Nueva contraseña de administrador

Escribiendo el comando **password** y **ENTER**, nos dejará cambiar la contraseña luego de indicar el usuario que requerimos cambiarla. Acá un output de como se vería eso en la consola.

```bash
Change password for user: admin
Old password: ********
Enter new password: ********
Retype password: ********
The password has been successfully changed.
```

## 2. Restaurar de fábrica (inicializar) el switch

Esto se hace con el comando **initialize**.

<aside>
💡

O desde la interfaz web, en el menú **Device** > **Configuration** y luego el botón **initialize**.

</aside>

```bash
**initialize**
The startup configuration file will be deleted and the system will be rebooted.
Continue? [Y/N]:Y
Please wait...
#Apr 26 12:18:02:485 2000 HP V1910 Switch DEV/1/REBOOT:
 Reboot device by command.

#Apr 26 12:18:02:594 2000 HP V1910 Switch DEV/4/SYSTEM REBOOT:
 System is rebooting now.

Starting......
```

Se reiniciará y grabará en su ROM el firmware vírgen, para que podamos comenzar desde cero. Estará listo en menos de 2 minutos.

```bash
***********************************************************
*                                                         *
*        HP V1910-24G Switch BOOTROM, Version 155         *
*                                                         *
***********************************************************

Copyright (c) 2010-2012 Hewlett-Packard Development Company, L.P.

Creation Date       : Jun 18 2012
CPU L1 Cache        : 32KB
CPU Clock Speed     : 333MHz
Memory Size         : 128MB
Flash Size          : 128MB
CPLD Version        : 002
PCB Version         : Ver.B
Mac Address         : D07E281BBA60

Press Ctrl-B to enter Extended Boot menu...0
Starting to get the main application file--flash:/V1910-CMW520-R1111P02.bin!.....
.............................................................................
The main application file is self-decompressing................................
.............................................................................Done!
System is starting...
Startup configuration file does not exist.
User interface aux0 is available.

Press ENTER to get started.
```

Como indica el manual y esta documentación, nos podemos loguear con las credenciales por default, luego de presionar **ENTER**.

# Primer inicio de sesión

Al entrar a la IP del switch por HTTP, veremos un formulario de login. Iniciamos sesión con las credenciales por defecto y nos llevará al dashboard principal, dónde podemos ver el uso de CPU y memoria. Nos dirigimos a la opción **Wizard** de la barra lateral izquierda.

## Wizard

En el primer paso se nos pedirá el nombre del sistema, su ubicación física y la información de contacto del administrador de sistemas. Estos datos serán rellenados según el caso de cada uno. Yo por ejemplo, lo completé así:

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%203.png)

En el paso siguiente, elegimos la VLAN1 para administrar el sistema, y colocamos una asignación de IP manual con la IP que queremos para el switch (en mi caso, 192.168.21.222), la máscara de red y el dispositivo que nos da internet.

Le damos al botón **Next** y nos dará un resúmen de lo que hicimos. Lo chequeamos y si está bien, clic en el botón **Finish**. Nos dirigimos a la nueva IP del switch, y nos logueamos.

# Configuración de la fecha

Debemos ir a **Device** > **System Time** para configurar la hora, fecha y la zona horaria de forma adecuada. El switch tiene registros que deben tener fecha correcta.

Por ejemplo, en **Device** > **Syslog** tenemos los reportes de cada acción realizada en el switch, con fecha y hora.

[https://www.notion.so](https://www.notion.so)

# Configuración de las VLAN

<aside>
💡

Debemos tener en cuenta que es el firewall quién nos enviará las VLAN empaquetadas en (al menos) un cable troncal. Sin embargo, el switch debe tener creadas las mismas VLANs, de forma tal que sepa cómo redirigir el tráfico por los puertos disponibles.

</aside>

El HP V1910 es un switch que se basa en los puertos para manejar sus VLANs (port-based VLANs).

Los paquetes que tienen información de la VLAN, incluyen estos datos:

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%204.png)

- The 16-bit TPID field with a value of 0x8100 indicates that the frame is VLAN tagged.
- The 3-bit priority field indicates the 802.1p priority of the frame.
- The 1-bit CFI field specifies whether the MAC addresses are encapsulated in the standard format when packets are transmitted across different media. A value of 0 indicates that the MAC addresses are encapsulated in canonical format. A value of 1 indicates that the MAC addresses areencapsulated in a non-standard format. The value of the field is 0 by default.
- The 12-bit VLAN ID field identifies the VLAN the frame belongs to. The VLAN ID range is 0 to 4095. As 0 and 4095 are reserved, a VLAN ID actually ranges from 1 to 4094.

## Podemos configurar un puerto como:

- **Access**: pertenece a una VLAN y envía el tráfico sin el tag de VLAN (Untagged). Se utiliza cuándo el dispositivo que se conectará a ese puerto no reconoce paquetes con tag, usualmente laptops, PCs, hotspots WiFi, etc.
- **Trunk**: es el encargado de enviar y recibir tráfico desde y hasta cada VLAN. Este puerto está presente en dispositivos que puedan entender estos datos, para llevar la información al dispositivo específico (laptop, PCs, etc) que no entienden paquetes con tags. Sólo acepta paquetes que tengan un PVID.
- **Hybrid**: puede recibir y enviar tráfico de todas las VLANs sin tener tags. (falta explicar)

Para crear las VLAN, nos dirigimos a **Network** > **VLAN Interface** > Pestaña **Create**.

# Diseño teórico de las distintas VLANs

Podemos tener un diseño de VLANs como el siguiente:

- Subred 1 (VLAN 1): Sistemas y Servidores (Desde Puerto 1 hasta Puerto 8)
- Subred 2 (VLAN 2): Recepción (Desde Puerto 9 hasta el 12)
- Subred 3 (VLAN 3): Profesionales (Desde el Puerto 13 hasta el 16)
- Subred 4 (VLAN 4): WiFi e Impresoras (Desde el Puerto 17 hasta el 20)

**El resto de puertos los podemos dejar libres para la conexión con el router y la cascada hacia otros switch**.

<aside>
💡

Con “cascada” de switchs nos referimos a pasar una VLAN o troncal, desde un switch hasta otro mediante un cable de red.

</aside>

Por convención, se acostumbra utilizar el último puerto del switch para la conexión al router, pero ese puerto se irá corriendo hacia puertos de numeración más baja conforme se empiecen a utilizar puertos para realizar cascada. Ejemplo del proceso (el “cómo lo haríamos” si un día toca agregar cascadas):

- Tenemos el switch sin cascada con el Puerto 24 ocupado por la conexión hasta el router.
- Precisamos enviar las VLAN **Recepción** y **Profesionales**.
- Movemos el cable que va del router hasta el switch, del puerto 24 al 22.
- Ahora el Puerto 23 y 24 se podrán usar para la cascada de cada VLAN independiente.

# Eliminación de una VLAN

En el menú **Network** > **VLAN** podremos ver todo lo relacionado a las redes virtuales.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%205.png)

Debemos apretar el botón **Select** que se ubica a la derecha, para que muestre todas las VLAN. Al mostrar la única VLAN que tiene (VLAN 0001), le hacemos clic a ese item y luego al link **Remove**. 

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%206.png)

Eso nos llevará a este menú, dónde indicamos que queremos eliminar la red con ID 1, y apretamos el botón **Remove**.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%207.png)

¡Ja! Acabás de aprender cómo se elimina una VLAN, y también que no se puede eliminar la VLAN por default. 😂 ¡2x1!

# Modificar VLAN

Seguramente la descripción que tiene esta red (”VLAN 0001”) no te guste y tampoco es muy detallada que digamos. Si seguimos con mi diseño de VLAN básico, deberíamos llamarla “Sistemas y Servidores”. Para eso, vamos al link **Modify VLAN** que está debajo de la barra azúl (de ahora en más, la llamaré **barra auxiliar**) y procedemos:

- Elegimos una VLAN a modificar
- En el campo **Modify Description (optional)**, colocamos el nombre de "Sistemas y Servidores”.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%208.png)

Listo, le damos al botón **Apply** de la derecha, y tendremos el nombre cambiado.

# Crear una VLAN

Como dije antes, no usaremos este switch por si sólo para crear las VLAN (aunque en teoría se puede hacer **algo** de ese estilo, debo confirmar), sino que las manejamos desde el PfSense/OPNSense.

Sin embargo, el switch debe saber que VLANs se manejarán y sus IDs, para poder enviar los paquetes a dónde corresponde.

Debajo de la barra auxiliar, debemos ir a **Create**. Recordemos las VLANs que nos faltan:

- Subred 2 (VLAN 2): Recepción
- Subred 3 (VLAN 3): Profesionales
- Subred 4 (VLAN 4): WiFi e Impresoras

Daré el ejemplo con el ID 2 (VLAN de Recepción). Completamos el ID que nos pide y le damos al botón **Create**.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%209.png)

En la misma página, **luego de crear la VLAN**, podemos cambiar el campo **Description** por el nombre de nuestra VLAN, que sería **Recepcion**.

<aside>
💡

Las descripciones no pueden contener tildes ni caracteres raros cómo **$**, **%**, **&**, **^**, etc.

</aside>

¡Listo! Hagamos eso con las VLANs restantes, y sabiendo que **los IDs del switch deben coincidir con los IDs de VLAN que tenemos creados en el PfSense** (la descripción puede no coincidir, no hay problema puesto que eso es orientativo para nosotros).

Así me quedó a mi:

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2010.png)

# Asignar puertos físicos a cada VLAN

Tenemos las redes creadas, pero el switch está asignando todos los puertos a la red con tag 1. Esto puede verse desde **Network** > **VLAN** > **Port Detail**, y luego hacer clic en el botón **Select All** y mirando la tabla que está debajo.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2011.png)

**Para asignar puertos** vamos a **Modify Port**, justo debajo de la barra auxiliar azúl (casi al lado de **Port Detail**).

Recordemos una vez más los puertos que queremos asignar a cada VLAN:

- Subred 1 (VLAN 1): Sistemas y Servidores (Desde Puerto 1 hasta Puerto 8)
- Subred 2 (VLAN 2): Recepción (Desde Puerto 9 hasta el 12)
- Subred 3 (VLAN 3): Profesionales (Desde el Puerto 13 hasta el 16)
- Subred 4 (VLAN 4): WiFi e Impresoras (Desde el Puerto 17 hasta el 20)

Ya sabiendo que todos los puertos están asignados a la VLAN 1, podemos omitir su configuración (por ahora) e ir directamente a la VLAN 2. Tomándola de ejemplo, queremos asignar puertos **Untagged** (es decir, los que envían paquetes para que **cualquier dispositivo** **conectado a esa VLAN los entienda**).

<aside>
💡

Los puertos Tagged son paquetes que indican a qué VLAN pertenecen, pero éstos son manejados por switches y routers.

</aside>

Asignamos Puerto 9, 10, 11 y 12 (simplemente haciéndoles clic), e indicamos el ID **2**, así:

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2012.png)

Al apretar en el botón **Apply**, se abrirá una ventana que nos indica el estado de los seteos, y un botón de **Close** al terminar. La ventana nos dirá los puertos que está asignando a la VLAN ID 2.

```bash
Setting GigabitEthernet1/0/9...... - OK!
Setting GigabitEthernet1/0/11...... - OK!
Setting GigabitEthernet1/0/10...... - OK!
Setting GigabitEthernet1/0/12...... - OK!
```

Hacemos lo propio con la VLAN 3 y 4, y al terminar vamos al botón **Port Detail** nuevamente. Si seleccionamos un puerto al azar, podremos comprobar a qué tag está asignado (en nuestro caso, el tag id estaría entre el 1 y el 4). Si hago clic en el puerto 7 y 16, por ejemplo, tendríamos esta información:

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2013.png)

Vemos que está asignado correctamente a la VLAN que seteamos. ¡Bien!

<aside>
💡

Debajo de la imágen del switch, está el botón **Select All**. Este botón hará que se muestren todos los datos de los puertos, en la tabla de abajo.

</aside>

# Configurar puertos como troncales

Utilizaremos dos puertos para la **LAN** y **LAN2** en PfSense (equivalentes a vmbr1000 y vmbr1001). Estas dos troncales se asignan a los últimos puertos del switch, por convención.

Para ello, seleccionamos el último puerto (24) en el menú **Network** > **VLAN** > **Modify Port**, que será para la VLAN3 y 4. También debemos seleccionar el puerto 23, que será usado por la VLAN1 y 2.

En **Select Membership Type** seleccionamos la opción **Link Type**, que nos mostrará un menú desplegable; seleccionamos **Trunk** y aplicamos cambios con el botón **Apply**.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2014.png)

¡Bien! Ahora tendremos dos puertos troncales por dónde pasarán nuestras cuatro VLANs. El problema es que el switch no sabe aún qué redes circularán por esos puertos. Para eso, vamos al siguiente título.

# Indicar PVID a los puertos troncales

Tuve un problema, y es que en el título Marcar puertos como “tagged” sucedía que (antes) no podía hacer que el puerto 23 reciba tráfico de la VLAN 1 y lo interprete como tráfico taggeado. Esto en la práctica, haría que el switch no esté recibiendo el tráfico de esa red correctamente.

Esto se debe a que el PVID está configurado para la VLAN 1. 

<aside>
💡

El **PVID** es para decirle al switch a **dónde se dirige el tráfico que no tiene tag**. Para la implementación que estamos haciendo, no nos interesa que el tráfico sin tag pase a algún lugar. Los puertos 23 y 24 son exclusivos para manejar 4 VLANs y ya

</aside>

Para evitar problemas como los mencionados anteriormente, recomiendo colocar el PVID en un número por fuera de nuestra numeración, por ejemplo **4094**. A continuación, se marcan los pasos.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2015.png)

# Marcar puertos como “tagged”

Antes de asignar VLANs a las troncales, debemos darles la habilidad a los puertos para recibir tráfico con tags. Para eso, nos dirigimos a **Network** > **VLAN** > **Modify VLAN**, antes habiendo listado las VLANs en el menú **Select VLAN** y eligiendo alguna red (yo empezaría por la primera).

Para ésto, debemos seleccionar cada VLAN e indicar cuál será el puerto **tagged**.

Seleccionamos el casillero verde Tagged en la opción Select membership type, y luego el puerto 23 para el caso de la VLAN 1 y 2. Hacemos lo propio para la VLAN 3 y 4, pero pintando de verde el puerto 24.

<aside>
💡

En todos los casos, no te olvides de darle al botón **Apply** (paso 3 en la imágen de abajo)

</aside>

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2016.png)

# Asignar troncales a distintas VLAN

Voy a hacer el ejemplo con la VLAN3 y VLAN4. Nos dirigimos a **Network** > **VLAN** > **Modify Port** y seleccionamos el último puerto, porque le corresponde a la VLAN 3 y 4 (ya lo dijimos arriba).

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2017.png)

Acá seleccioné el puerto 24 (por eso está en color azúl), y más abajo en la opción **Enter VLAN IDs to which the port is to be assigned** usé los IDs correspondientes. En este caso era solo el 3 y 4.

<aside>
💡

Si tuviera que asignar más VLANs al puerto, por ejemplo VLAN 3 a 6, en el campo de texto de la opción **Enter VLAN IDs to which the port is to be assigned** podría haber puesto **3,4,5,6** ó **3-6**.

</aside>

Al revisar que los IDs estén correctos, le damos al botón **Apply** (este botón no aparece en la imágen, pero está justo debajo del campo dónde indicamos los IDs).

Yo acabo de dar el ejemplo con dos redes, si estás siguiendo mi ejemplo te tocaría hacer lo propio con las VLAN ID 1 y 2, para el puerto 23.

# Revisamos que esté todo bien

De nuevo vamos a **Network** > **VLAN** > **Port Detail** y seleccionamos los puertos 23 y 24, y vemos la magia:

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2018.png)

¡Perfecto! Porque:

- El puerto 23 recibirá tráfico de la VLAN 1 y 2
- El puerto 24 recibirá tráfico de la VLAN 3 y 4

# Guardado permanente de los cambios

Si la configuración del switch ya cumple con lo que necesitamos, podemos apretar el link **Save** situado en la barra auxiliar.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2019.png)

Esto hará los cambios **permanentes**, incluso luego de un reinicio del dispositivo. Tener en cuenta que:

- Guardar la configuración toma tiempo (< 10 segundos)
- Si más de un usuario está queriendo guardar la configuración, se tomará en cuenta al primero y al resto tendrán un mensaje estilo “Intentalo más tarde”

Nos indicará que finalizó, con un mensaje.

![image.png]({{ base.url }}/assets/posts/switch-l2-hp-v1910-24g-guia-de-configuracion/image%2020.png)

# Realizar un backup de la configuración

Si queremos guardar la configuración del switch en un archivo, toca ir a **Device** > **Configuration** > **Backup**. Allí tocamos el botón **Backup** que está al lado del texto Backup the configuration file with the extension ".cfg”.

# Restaurar backup desde un archivo de configuración

Nos dirigimos a **Device** > **Configuration** > **Restore**, hacemos clic en el botón para seleccionar un archivo y le indicamos nuestro archivo de configuración, guardado en nuestra PC. Después hacemos clic en **Apply** y esperamos que el switch termine de aplicar cambios.

Fin.