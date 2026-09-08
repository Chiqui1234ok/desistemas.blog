---
layout: post
title:  "\"SR-IOV\" en LXC • Compartir GPU entre contenedores"
date:   2025-03-16 17:26:00 -0300
categories: [hardware, highlight]
tags: guía, tutorial, linux, lxc, contenedor, sr-iov, nvidia, rtx, decoding, encoding, jellyfin, hardware
image: /assets/posts/sr-iov-en-lxc/msi-rtx-3070-ventus-3x.webp
---

# Preámbulo

Poder compartir una misma tarjeta gráfica era tarea imposible hace un tiempo, porque Nvidia bloqueó la tecnología que lo hacía posible en su gama mainstream / gamer. En el caso de AMD, también está bloqueado.
Sin embargo, este post presenta una solución dónde el driver se instala en la máquina host (Linux), y así podrá repartirse el poder de cómputo entre distintos contenedores LXC, que hoy se pueden crear de forma fácil mediante la UI de Proxmox.

Para el caso del tutorial, se utilizará una RTX 3070 8GB con la distribución Proxmox 8 (basada en Debian 12).

![MSI RTX 3070 Ventus 3X]({{ base.url }}/assets/posts/sr-iov-en-lxc/msi-rtx-3070-ventus-3x.webp)

Comencemos.

# Descargar drivers de Nvidia

La mejor opción es descargar los drivers oficiales e instalarlos en el host.

> Nunca habías leído que el driver de la web oficial es la mejor opción, pero en estos tiempos, no está nada mal y funciona de maravillas con la solución acá presentada.

En este caso, descargar e instalar manualmente el driver da una mayor estabilidad, puesto que se compilan los módulos DKMS para el kernel en cuestión y, además, no se auto-actualiza y por ende evita romper cosas. Al momento de actualizar el kernel Linux, se auto-ejecutará la compilación de los módulos DKMS del driver Nvidia, por lo que hay poco que temer.

La página de Nvidia es esta, y deben especificarse los detalles de la placa de video a configurar.

![Selección de driver]({{ base.url }}/assets/posts/sr-iov-en-lxc/seleccion-de-driver.webp)

Al hacer clic en el botón "Find", la nueva página indicará detalles del driver más reciente. A día de hoy, el último driver es el 570.124.04 (lanzado el día 2025-02-27). Se aprieta el botón "View" y, en la nueva página, se copia el link del botón "Download".

Hay que dirigirse a la línea de comandos del servidor, dónde se ejecutarán los LXC. Allí, se procede a descargar con:

```bash
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/580.95.05/NVIDIA-Linux-x86_64-580.95.05.run
```

# Utilizar paquetes de Proxmox sin subscripción (opcional)

Este tutorial utiliza los paquetes de Proxmox sin subscripción, hacé esto si usás el SO de forma gratuita:

```bash
echo "deb http://download.proxmox.com/debian/ceph-reef bookworm no-subscription" > /etc/apt/sources.list.d/ceph.list
```

Y también: 

```bash
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-enterprise.list
```

# Actualizar completamente el sistema operativo

Puesto que no se planea actualizar los drivers ni el SO por un buen tiempo, es bueno asegurarse la última versión de ambos dos, realizando:

```bash
apt update && apt upgrade && apt dist-upgrade
```

# Bloquear Nouveau

Se debe crear un archivo para bloquear el driver open-source de Nvidia. Caso contrario, la instalación fallará.

```bash
nano /etc/modprobe.d/nvidia-installer-disable-nouveau.conf
```

En este archivo, se deben pegar las siguientes dos líneas:

```bash
blacklist nouveau
options nouveau modeset=0
```

Luego se guarda y sale del programa con CTRL+X, luego tecla Y y luego tecla ENTER.

A continuación, se reinicia el equipo con:

```bash
reboot
```

# Instalar dependencias

Una vez el equipo haya encendido y el usuario root esté logueado, se procede a instalar el software para compilar los módulos del driver:

```bash
apt install gcc make build-essential dkms pve-headers-$(uname -r) -y
```

# Instalar el driver

1. Se le otorgan permisos de ejecución

```bash
chmod +x NVIDIA-Linux-x86_64-570.124.04.run
```

2. Se ejecuta el instalador

```bash
./NVIDIA-Linux-x86_64-570.124.04.run
```

3. Se selecciona la opción "NVIDIA Propietary".

4. Se espera que compile los módulos del kernel.

> Este proceso tardó 3 minutos en un [Celeron G3930](https://www.intel.com/content/www/us/en/products/sku/97452/intel-celeron-processor-g3930-2m-cache-2-90-ghz/specifications.html) + SSD SATA, si está tardando más en tu caso y con una computadora mejor, en primer lugar deberías revisar la instalación física de la placa de video.

5. El driver mostrará un WARNING, que no es peligroso porque Proxmox no tiene ***X*** / ***Xorg*** instalado por defecto, y tampoco será necesario dentro del futuro LXC. A este paso se prosigue con el botón "OK" y, a continuación, dejo el error para fines documentales:

```
WARNING: nvidia-installer was forced to guess the X library path '/usr/lib' and X module path '/usr/lib/xorg/modules'; these paths were not queryable
           from the system.  If X fails to find the NVIDIA X driver module, please install the `pkg-config` utility and the X.Org SDK/development       
           package for your distribution and reinstall the driver.
```

6. También notificará que no se pudieron instalar las bibliotecas de 32 bit, que tampoco son requeridas. Se presiona el botón "OK" y a continuación se muestra el mensaje de error para fines de documentación:

```
Unable to find a suitable destination to install 32-bit compatibility libraries. Your system may not be set up for 32-bit compatibility.     
           32-bit compatibility files will not be installed; if you wish to install them, re-run the installation and set a valid directory with the    
           --compat32-libdir option.
```

7. Preguntará si se quiere permitir la re-compilación del driver en caso de la instalación de un kernel nuevo. Esto es conveniente en la mayoría de casos, así que se responde "Yes". Este proceso tardó menos de un minuto.

8. Preguntará si se desea ejecutar ***nvidia-xconfig***, a lo que se responde negativamente.

9. Se responde con el botón "OK" y se finaliza la instalación. Nuevamente se ignora el mensaje acerca de Xorg, ya que Proxmox no lo posee.

# Garantizar el inicio del driver

Se edita el archivo de módulos:

```bash
nano /etc/modules-load.d/modules.conf
```

Se añade el siguiente contenido al final:

```bash
nvidia
nvidia_uvm
```

Luego se guarda y sale del programa con CTRL+X, luego tecla Y y luego tecla ENTER.

Una vez fuera de ***nano***, se actualiza el ***initramfs***:

```bash
update-initramfs -u
```

# Facilitar el acceso al driver para los LXC

Se deben crear unos archivos que sirven de interfaz para que los LXC se comuniquen con el driver correctamente:

```bash
nano /etc/udev/rules.d/70-nvidia.rules
```

Y se pega el siguiente contenido:

```bash
KERNEL=="nvidia", RUN+="/bin/bash -c '/usr/bin/nvidia-smi -L && /bin/chmod 666 /dev/nvidia*'"
KERNEL=="nvidia_uvm", RUN+="/bin/bash -c '/usr/bin/nvidia-modprobe -c0 -u && /bin/chmod 0666 /dev/nvidia-uvm*'"
```

Luego se guarda y sale del programa con CTRL+X, luego tecla Y y luego tecla ENTER. Este nuevo archivo aplicará los permisos necesarios para que los LXC no privilegiados puedan acceder a las funciones del driver Nvidia, cada vez que se inicia la computadora.

Para aplicar cambios, se reinicia la PC:

```bash
reboot
```

# nvidia-smi

Una vez la PC esté iniciada, se ejecuta ***nvidia-smi*** para probar que el driver esté instalado y detecte la GPU. Gracias a **nvidia-smi**, tendremos información acerca de nuestra tarjeta gráfica:

```
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.124.04             Driver Version: 570.124.04     CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 3070        Off |   00000000:01:00.0 Off |                  N/A |
| 30%   48C    P0             36W /  220W |       1MiB /   8192MiB |      4%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
                                                                                         
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+
```

> Es importante mencionar que casi 40W de consumo en idle NO es normal. Se debe ir a la BIOS del motherboard y revisar como habilitar los "C States" y ahorros de energía, para permitir menor consumo en reposo. No pude probar ésto al momento de hacer el tutorial, pero una RTX 2060 en Idle con estas políticas de ahorro de energía, se situaba en 9W mientras no hacía nada. Imagino que una 3070 no superaría 20W, a lo mucho. Se agradece si lo prueban e informan 😁

La ejecución con éxito del comando ***nvidia-smi*** es importante, puesto que indica que la placa se instaló correctamente.

# Creación del LXC

Se debe crear un contenedor LXC con el ID 110 y la última versión de Debian. Luego de crear el contenedor (pero sin iniciarlo), se deben buscar los archivos que ahora tiene permisos más amplios, gracias a **70-nvidia.rules**.

```bash
ls -l /dev/nvidia*
```

La salida es:

```
ls -l /dev/nvidia*
crw-rw-rw- 1 root root 195,   0 Mar 17 18:27 /dev/nvidia0
crw-rw-rw- 1 root root 195, 255 Mar 17 18:27 /dev/nvidiactl
crw-rw-rw- 1 root root 511,   0 Mar 17 18:27 /dev/nvidia-uvm
crw-rw-rw- 1 root root 511,   1 Mar 17 18:27 /dev/nvidia-uvm-tools

[...]
```

Se deben montar **/dev/nvidia0**, **/dev/nvidiactl**, **/dev/nvidia-uvm** y **/dev/nvidia-uvm-tools** en el LXC. Así, el contenedor podrá interactuar con la GPU.

> También se debe montar **/dev/nvidia-modeset**, si se muestra (corresponde a drivers y gpus más antiguas).

```bash
nano /etc/pve/lxc/110.conf
```

Y se añaden las siguientes líneas al final de su configuración, para montar las carpetas que se listaron anteriormente:

```bash
lxc.cgroup2.devices.allow: c 195:* rwm
lxc.cgroup2.devices.allow: c 243:* rwm
lxc.mount.entry: /dev/nvidia0 dev/nvidia0 none bind,optional,create=file
lxc.mount.entry: /dev/nvidiactl dev/nvidiactl none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file
lxc.mount.entry: /dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file
```

Si tu equipo mostró **/dev/nvidia-modeset**, debés añadir esta línea:

```bash
lxc.mount.entry: /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file
```

Luego se guarda y sale del programa con CTRL+X, luego tecla Y y luego tecla ENTER.

# Instalación del driver en LXC

Dentro del contenedor, se descarga el mismo driver que está en el host:

```bash
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/580.95.05/NVIDIA-Linux-x86_64-580.95.05.run
```

Al finalizar la descarga, se le dan permisos de ejecución:

```bash
chmod +x NVIDIA-Linux-x86_64-570.124.04.run
```

Ahora estamos en condiciones de iniciar el instalador, pero con el argumento "--no-kernel-module", ya que el LXC utiliza el kernel del host:

```bash
./NVIDIA-Linux-x86_64-570.124.04.run --no-kernel-module
```

## Pasos del instalador en el LXC

1. Se selecciona "NVIDIA Propietary".

2. Nos confirmará que estamos usando la opción "--no-kernel-module", a lo que se responde con el botón "OK".

3. Se selecciona "OK" cuándo arroja el WARNING de Xorg.

4. Se presiona "OK" cuándo indica que no se instalarán bibliotecas de 32 bits.

5. Notificará que no se detectó ni instalará "Nvidia Vulkan ICD", el cargador de la API Vulkan. Esto no es necesario para las tareas que se realizarán con la GPU, sin embargo, se deja el mensaje para fines documentativos y porque notifica como resolver ésto instalando un paquete de software:

```
This NVIDIA driver package includes Vulkan components, but no Vulkan ICD loader was detected on this system. The NVIDIA Vulkan ICD will not function without the loader. Most distributions package the Vulkan loader; try installing the "vulkan-loader", "vulkan-icd-loader", or "libvulkan1" package.
```

6. La instalación será rápida y consultará si se prefiere ejecutar ***nvidia-xconfig***, a lo que se responde con el botón "No", y luego se presiona "OK".

# Probar nvidia-smi en el contenedor

Al ejecutar ***nvidia-smi*** como root, se verá un resultado similar al que estaba en el host:

```
root@nvidia-test-1:~# nvidia-smi
Mon Mar 17 21:57:23 2025       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.124.04             Driver Version: 570.124.04     CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 3070        Off |   00000000:01:00.0 Off |                  N/A |
| 30%   49C    P0             37W /  220W |       1MiB /   8192MiB |      3%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
                                                                                         
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+
```

> Nota: Si bien se es usuario root en el contenedor LXC, no es el mismo usuario root con privilegios máximos en la PC host. El usuario root podrá hacer tareas de "super usuario" únicamente dentro del LXC, y tiene fuertes restricciones para acceder a archivos del sistema operativo Host. Por eso le dimos permisos más amplios a las carpetas de nvidia, dentro de **/dev**.

# Probar carga en la GPU con T-Rex

Para ver si funciona todo bien, se descarga "T-Rex miner". Así, se aplicará una carga pesada en la placa de video por unos minutos. Esto nos dejará ver la temperatura, carga, frecuencias, consumos, uso de VRAM, **estabilidad**, etc.

Es probable que la placa de video alcance altas temperaturas, de entre 80 y 90 grados. Esto, si se ejecuta por unos pocos minutos, no dañará la placa de video. En esta demostración solo ejecutaremos el minero alrededor de un minuto, para comprobar que la GPU se comporta adecuadamente.

> Ustedes pueden utilizar otro software para probar la implementación del driver en el LXC. En lo personal, considero que T-Rex miner es una forma súper rápida para salirse de dudas. Sin embargo, se requieren al menos 4GB de VRAM y quizá en 2026 ese requisito aumente a 6GB, así que no podrás ejecutar el software en placas de video de muy bajo presupuesto.

Se procede con la instalación y ejecución de T-Rex.

1. Crear la carpeta y entrar en ella:

```bash
mkdir trex && cd trex
```

2. Descargar el minero:

```bash
wget https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz
```

3. Descomprimir los archivos:

```bash
tar -xzf t-rex-0.26.8-linux.tar.gz
```

4. Se le da permisos a alguna criptomoneda que utilice poca VRAM. Por ejemplo, a día de hoy, ETC consume 3,84GB:

```bash
chmod +x ETC-woolypooly.sh
```

5. Se ejecuta el minero:

```bash
./ETC-woolypooly.sh
```

Una vez iniciado, el programa notificará la versión del driver de Nvidia y la placa de video presente:

```bash
20250317 22:39:20 T-Rex NVIDIA GPU miner v0.26.8  -  [Linux]
20250317 22:39:20 r.104788c2d052
20250317 22:39:20 
20250317 22:39:20 
20250317 22:39:20 NVIDIA Driver v570.124.04
20250317 22:39:20 
20250317 22:39:20 + GPU #0: [00:01.0|2484] GeForce RTX 3070, 7851 MB
```

Al dejar ejecutando el programa alrededor de un minuto, se verá una salida similar a esta:

```bash
-----------------------20250317 22:40:22 -----------------------
Mining at pool.woolypooly.com:35000 [5.188.238.29], diff: 4.00 G
GPU #0: RTX 3070 - 53.64 MH/s, [T:86C, P:215W, F:97%, E:249kH/W]
Shares/min: 0
Uptime: 1 min 2 secs | Algo: etchash | Driver: 570.124.04 | T-Rex 0.26.8

Mining at pool.woolypooly.com:35000 [5.188.238.29], diff: 4.00 G
GPU #0: RTX 3070 - 53.64 MH/s, [T:89C, P:202W, F:100%, E:251kH/W]
Shares/min: 0
Uptime: 1 min 32 secs | Algo: etchash | Driver: 570.124.04 | T-Rex 0.26.8
```

Se puede observar que la placa puede soportar la carga correctamente, ya que el minero informa su temperatura y consumo. No salió ningún error. Al utilizar drivers oficiales, la certeza de que esta implementación funciona es del 100%.

Se cancela el software con CTRL + C.

## Comparativa de rendimiento

El procedimiento descripto en "Probar carga de la GPU" se puso a prueba en el Linux host y, por suerte, se vio una performance idéntica. Esto es una buena noticia, puesto que el pasaje de GPU no tiene ningún impacto en rendimiento en este caso.

Por lo menos al realizar el pasaje de una GPU, no se probó el pasaje de varios dispositivos.

# Epílogo

Hoy, el administrador de sistemas aprendió a realizar una especie de "PCI-E passthrough", que tiene cero impacto en el rendimiento y permite compartir la tarjeta gráfica entre varios LXC que tienen la misma instalación y configuración de driver.

¡Nos vemos!