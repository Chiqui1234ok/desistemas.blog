---
layout: post
title:  "Controlador de dominio en Linux • Samba AD-DC"
date:   2025-09-27 21:30:00 -0300
categories: [homelabing, samba]
tags: homelabing, samba, it, linux, guia, active directory, domain controller, linux, samba-ad-dc
highlight: true
---

# Preámbulo

Por limitaciones presupuestarias o preferencia propia, se termina utilizando Linux en los servidores de un negocio determinado. Aunque el software que conforma un [Controlador de dominio](https://es.wikipedia.org/wiki/Controlador_de_dominio) y [Active Directory](https://es.wikipedia.org/wiki/Active_Directory) fueron creados por Microsoft, los desarrolladores de SAMBA hacen un gran trabajo para mantener sistemas Linux y Windows comunicados mediante el mismo protocolo, recurriendo en muchos casos a ingeniería inversa.

Hace ya unos años que, según la experiencia de quién les escribe, esta implementación funciona muy bien y se puede configurar tal cuál como si se estuviera en un sistema Windows, aunque cueste creer.

Esta guía enseñará lo básico y fundamental para tener un servidor corriendo en óptimas condiciones. Además, en un próximo post se registrará un equipo con Windows 11 IoT Enterprise 2024 en el controlador de dominio por dos vías:
- En la instalación del propio sistema operativo en el equipo.
- En un sistema ya instalado hace pocos días.

# Configuración básica del software del servidor

Esta guía se realiza sobre un Debian 12.11 recién instalado y sin ningún tipo de escritorio/interfaz gráfica. 
Además del usuario "root" super-usuario, se creó "sistemas" sin privilegios elevados.
Durante el proceso de instalación del mismo sistema operativo se decidió incorporar el "SSH Server", para poder interactuar con el servidor de forma remota.

Las particiones se configuraron así:
- 100 MB EFI
- 4 GB RAÍZ (ext4)
- 4 GB /home (ext4)

No será necesario trabajar con LVM.

# Hardware del servidor

Se creó una máquina virtual con las siguientes características:
- 1 vCPU (1 núcleo) (tipo: HOST)
- 2GB de RAM DDR4
- 8GB de almacenamiento VirtIO Block
- 1 adaptador de red tipo bridge

# Instalación

Una vez encendido nuestro servidor y habiendonos logueado como sistemas, podremos realizar todos los pasos para tener todo corriendo lo antes posible.

> Antes de realizar estos pasos, se debe tipear en la terminal `su -` y colocar la contraseña de root, para poder trabajar como super usuario.

1. Actualización de paquetería:

```
apt update
```

2. Instalación de samba:

```
apt-get install samba smbclient samba-common-bin -y
```

# Autenticación

1. Darle contraseña el usuario "sistemas" en SAMBA:

```
smbpasswd -a sistemas
```

Solicitará la contraseña y su confirmación. Al tipear lo mismo en ambos casos, nos notificará que el usuario "sistemas" se añadió a Samba.

![Notificación de Samba al agregar un usuario]({{ base.url }}/assets/posts/controlador-de-dominio-en-linux/usuario-anadido-a-samba.png)

2. Ahora será posible loguearse en el servidor con el usuario "sistemas", de la siguiente forma:

```
smbclient -L localhost -U sistemas
```

Como se muestra en la imágen a continuación, luego de este comando Samba pedirá la contraseña del usuario "sistemas", que debe ser idéntica a la configurada anteriormente. Luego de tipearla y presionar ENTER, se mostrarán los Shares disponibles para ese usuario.

![Ingreso a SAMBA exitoso]({{ base.url }}/assets/posts/controlador-de-dominio-en-linux/ingreso-a-samba.png)

También se notifica que SMB1 está desactivado, lo cuál es el comportamiento deseado (es un protocolo muy viejo e inseguro).

# Configuración del servidor SAMBA

1. "Eliminar" el archivo de configuración de Samba:

Para lograr que Samba se convierta en un servidor Active Directory (AD) y Controlador de dominio (DC, en inglés), primero se debe sacar el archivo de configuración existente de Samba, para que se auto-genere después. 

```
mv /etc/samba/smb.conf /etc/samba/smb.conf.backup
```

2. Ejecutar el asistente de configuración

Antes de ejecutar el comando, paso a explicar cómo responder a las preguntas que hace `samba-tool`:

- Realm 👉 Nombre completo del dominio en formato DNS (en mayúsculas suele ser la convención). Ejemplo: "DESISTEMAS.LOCAL".
- Domain 👉 Es el nombre corto de dominio, también llamado "NetBIOS domain name". Es la forma antigua usada por Windows antes de que existiera Active Directory, es decir, se utiliza por compatibilidad y también define el nombre del Grupo de trabajo. Ejemplo: "DESISTEMAS".
- Server Role (dc, member, standalone) 👉 Se responde "dc", puesto que se quiere configurar un "domain controller".
- DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) 👉 Indica cómo se deben resolver los nombres de dominio. Si tenemos un servidor DNS propio o un router que resuelva, es seguro indicar "SAMBA_INTERNAL".
- DNS forwarder IP address (write 'none' to disable forwarding) 👉 Se indica la IP del router que resuelve DNS o un servidor de DNS propio, en caso de que el interno del DC no pueda resolver.
- Administrator password 👉 La contraseña del usuario "Administrator".
- Retype password 👉 La confirmación de esa contraseña.

Ahora sabiendo qué responder, se debe tipear en la terminal, respondiendo las 7 preguntas según lo que se explicó arriba:

```
samba-tool domain provision
```

# Reiniciar y verificar el Domain Controller

1. Reinciar el servicio Samba:

```
systemctl restart smbd
```

2. Revisar la configuración del servidor:

```
testparm
```

Este comando confirmará que la configuración está bien y define el rol como:

![Rol del servidor]({{ base.url }}/assets/posts/controlador-de-dominio-en-linux/rol-del-servidor.png)

# Conclusión

Con esta configuración ya es posible conectarse al Controlador de dominio con cualquier Windows 7, 10 y 11. Pronto estará disponible la guía para incorporar máquinas bajo el dominio de este servidor.

Esto ya fue probado en Windows 11:

![alt text]({{ base.url }}/assets/posts/controlador-de-dominio-en-linux/win-11-ya-bajo-el-controlador-de-dominio.png)

---

¡Gracias por leer la guía! ¡Ojalá les sea de gran utilidad!