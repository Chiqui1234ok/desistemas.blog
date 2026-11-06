---
layout: post
title:  "Disks • Todo sobre virtualización en Proxmox"
date:   2024-10-27 19:00:01 +0000
tags: guía, tutorial, proxmox, virtualización, qemu, kvm
hide: true
---

La pestaña de discos nos permite añadir almacenamiento realizando emulación de bus (canal por dónde pasan los datos) IDE, SATA, SCSI o directamente acudir a los drivers VirtIO, que exprimirán al máximo las capacidades reales de nuestro almacenamiento.

> Los drivers VirtIO (que existen para almacenamiento, red y gráficos) están optimizados para manejar hardware real en máquinas virtuales. Emular almacenamiento, red y gráficos puede sobre-cargar innecesariamente al CPU.

Si por ejemplo creás un disco con el protocolo SCSI, tenés un límite teórico de 150MB/s que puede ser superado por no solo SSDs SATA 3, sino también por discos mecánicos de alta calidad. Para que tengas de referencia, mi WD Caviar Red 14TB sobrepasa cómodamente los 200MB/s en lectura/escritura **secuencial**.

Además, si querés usar [caché de almacenamiento en ZFS]({% post_url 2024-01-28-todo-sobre-zfs-en-proxmox %}), podés aumentar el rendimiento de cualquier disco mediante el almacenamiento inteligente en RAM (RAM Disk). Utilizar emulaciones de buses nunca es recomendado, salvo casos dónde el sistema operativo es muy viejo y no tiene soporte para controladores VirtIO (o estar con flojera, y en un ambiente de pruebas).

Veamos la ventana de Proxmox, para comenzar a explicar:

![opciones de discos](/assets/posts/todo-sobre-virtualizacion-en-proxmox/opciones-de-discos.png)

# Bus/Device

- Seleccionamos: VirtIO Block

Acá podemos elegir el bus del disco a crear para nuestra VM. Utilizar IDE, SATA o SCSI es pedirle al software de virtualización (Qemu) que emule un controlador específico, y no sólo que estás posiblemente limitando el potencial de tu disco físico, sino también que estás utilizando ciclos de CPU para realizar esa emulación en tiempo real, y prescindiendo de las optimizaciones del controlador VirtIO.

> Yo por ejemplo utilicé IDE en una máquina con Windows XP SP3. 
> En teoría, VirtIO 0.1.132 es la última versión con soporte para XP, pero no lo detectó el instalador, y necesitaba ver una cosita de XP rápido, así que armé la virtual con IDE (que igualmente sobra para tener buen rendimiento en este SO)

En nuestro caso, como ya colocamos el disco ISO de controladores VirtIO, vamos a elegir la opción **VirtIO Block**.

# SCSI Controller

Esta opción ya está explicada en la página [General]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox-pestana-general %}).

# Storage

Esto sirve para indicar en qué almacenamiento, previamente añadido en Proxmox ([acá explico como hacerlo](#)), guardaremos nuestra imágen de disco.

> Una imágen de disco es un archivo que la VM usará del mismo modo que un almacenamiento real.

# Disk Size

El tamaño de disco, medido en GiB (Gibibytes). 1GiB = 1,07374GB. Lo mínimo para Windows 11 + Office + Quitar apps innecesarias de la Microsoft Store + Deshabilitar Windows Update, son 64GB.

Si querés un Windows "más funcional", vas a precisar al menos 128GiB. Estos tamaños que te estoy diciendo es suponiendo que la carpeta personal del/los usuario(s) están montadas en otro disco.

# Format

El formato recomendado en Proxmox es `qcow2`, está la opcion `vmdk` (VMWare) también, pero no por eso quiere decir que será completamente compatible con software de VMWare.

> En mi experiencia, si tenés que mudar la máquina virtual a VMWare ESXi 6.x o 7.x, vas a requerir convertir el disco con el software `vmdktools`, para que la máquina virtual pueda iniciar en aquél hipervisor.

# Cache

Acá hay muchas opciones más que interesantes. Mediante esta opción, podremos mejorar el rendimiento o la resiliencia de los datos. Cabe aclarar que estas opciones aún no las probé, explicaré según la documentación.

Como nota al pie, puedo decir que ahora tengo una imágen de disco en un SSD SATA 3 y una prueba de CrystalDiskMark arrojó 5GB/s en lectura secuencial. Ésto es una magia de ZFS, sistema dónde está almacenado la imágen de disco. ZFS por default, cachea en RAM Disk y por eso puede parecer que el consumo de RAM en Proxmox es elevado (ZFS liberará memoria en RAM si una máquina virtual o LXC la está necesitando).

- Direct Sync:
- Write through: