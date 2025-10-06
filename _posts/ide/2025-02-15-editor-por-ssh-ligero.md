---
layout: post
title:  "Editor por SSH ligero • Smartty (Windows)"
date:   2025-02-15 12:00:00 -0300
categories: [homelabing, highlight]
tags: guia, linux, editor de codigo, tty, ssh, windows app
description: "SmarTTY es ligero para el cliente y servidor, y tiene un pack de funciones que cubre la administración de ciertos sistemas más limitados, que no soportan VSCode. Además, incluye la herramienta de Telnet."
image: /assets/posts/editor-por-ssh-ligero/abrir-terminal.webp
---

# Preámbulo

En un mundo invadido por el bueno de Visual Studio Code, es realmente difícil recomendar algún programa nuevo que lo supere en resaltado de sintáxis, flexibilidad y personalización. Sin embargo, VSCode peca por ser "pesado" no sólo en el cliente que está basado en Electron, sino también en su implementación en el servidor.

Visual Studio Code instala un servidor en la máquina a la cuál el usuario se conecta, y pesa 448MB.

La terminal no dejará mentir:

![Visual Studio Code server pesa 448MB en un sistema de archivos ext4]({{ base_url }}/assets/posts/editor-por-ssh-ligero/peso-vscode-server.webp)

Hay sistemas que no pueden darse el lujo de almacenar semejante espacio, ni pueden tener las dependencias requeridas por el servidor. Este es el caso de **OpenWRT**, un sistema operativo que permite crear un router y firewall utilizando menos de 256MB en disco y funcional con apenas 128MB de RAM. Y este es tan sólo un ejemplo, puesto que otras distribuciones muy mínimas (como las creadas por Buildroot) no suelen tener compatibilidad con el VSCode Server.

También SSHFS puede ser una solución, pero al menos hace un tiempo no funcionaba tan bien (en Windows). Esto ahorra crear un punto de montaje, además.

La solución:

# Smar TTY (smartty)

[Descargar aplicación](https://sysprogs.com/SmarTTY/download/).

Este programa permite, en tan solo 26,1MB de RAM y un uso escaso de CPU, conectarse a una máquina remota con SSH Server instalado, una dependencia lógica y normal para cualquier servidor.

![Tanto SmarTTY como VSCode estaban conectados a una máquina remota, pero el primero consumiendo mucho menos]({{ base_url }}/assets/posts/editor-por-ssh-ligero/smartty-vs-vscode-consumo.webp)

Las funciones que lo hacen práctico para el administrador:

1. Guarda los datos de conexión.
   - Alias para el dispositivo.
   - Auto-configuración de una clave SSH para evitar almacenar la contraseña en texto plano.
   - Permite utilizar una clave SSH previamente creada por el administrador del sistema.
2. Múltiples pestañas para editar archivos.
3. Múltiples pestañas para interactuar con una CLI.
4. Copia archivos y carpetas entre la máquina remota y host.
5. Lanzar aplicaciones con GUI.
6. Buscador de conexiones.
7. Cliente Telnet.

# 1. Guarda los datos de conexión

![Crear conexión SSH]({{ base_url }}/assets/posts/editor-por-ssh-ligero/crear-conexion.webp)

Para crear una nueva conexión y guardarla, se realiza clic en el link **New SSH Connection...**, que abrirá una ventana con las siguientes opciones (se indican las relevantes):

- Host Name: nombre o IP de la máquina.
- User Name: usuario para loguearse en la máquina remota.
- Connection alias: apodo para la conexión.
- Password: contraseña para iniciar sesión
- Setup public key authentication: permitirá crear una clave pública para no guardar la contraseña en texto plano, y poder iniciar sesión la próxima vez sin necesidad de escribir la clave.
- Public key in Windows key store (associated with your user account): Recomendable, puesto que guarda la clave pública sólo para tu usuario de Windows, dentro del Gestor de Credenciales.
- Enable zlib compression: activa el algoritmo DEFLATE para la compresión / descompresión. Esta opción debería ser muy compatible con la mayoría de sistemas, aunque innecesario en redes Fast Ethernet o superiores.
- Transfer folders using: **On-the-fly TAR**. Acelera mucho la velocidad de transferencia de los archivos de la carpeta.
- Save this connection to connections list: permite guardar los datos ingresados en el formulario para próximos usos.

Una vez rellenado los campos de host, user y password, el botón **Connect** establecerá una conexión con el dispositivo remoto, y se podrá interactuar con él si los datos están bien.

---

El programa preguntará si se activa la "Smart terminal", cosa que no es necesaria, y se puede elegir la terminal convencional.

# 2. Múltiples pestañas para editar archivos.

![Abrir un archivo]({{ base_url }}/assets/posts/editor-por-ssh-ligero/abrir-archivos.webp)

Desde este botón, se abrirá una ventana blanca como la mostrada en la imágen, que permite navegar por todo el sistema de archivos al cuál el usuario logueado tiene acceso.

# 3. Múltiples pestañas para interactuar con una CLI.

A pesar de haber abierto un archivo, la terminal sigue activa, como se marca con el recuadro azúl. Además se puede abrir una nueva desde el botón "más" verde.

![Abrir una nueva terminal]({{ base_url }}/assets/posts/editor-por-ssh-ligero/abrir-terminal.webp)

# 4. Copia archivos y carpetas entre la máquina remota y host.

![Menú SCP]({{ base_url }}/assets/posts/editor-por-ssh-ligero/menu-scp.webp)

Desde el menú **SCP**, se podrán hacer todo tipo de cosas. Cada opción del menú **SCP** abrirá una ventana preguntando por la ruta destino y orígen, por ende no vale la pena sobre-explicar en este punto.

![Descargar un directorio]({{ base_url }}/assets/posts/editor-por-ssh-ligero/download-a-directory.webp)

Tendrá un botón para Descargar / Subir y Cancelar. En el caso del primer botón, una vez que se le haga clic mostrará el progreso hasta que termine.

Las opciones por default, que en este caso es "Use-on-the-fly TAR", está perfecto y acelerará el intercambio de archivos si el procesador es decente (en Español, si no está al 50% simplemente por estar sin hacer nada en Windows).

# 5. Lanzar aplicaciones con GUI.

Si, lanzar una aplicación con interfaz gráfica es posible. Simplemente se escribe el comando con el que se lanza la aplicación, y SmarTTY preguntará como se desea abrir. La opción recomendada siempre funciona.

![alt text]({{ base_url }}/assets/posts/editor-por-ssh-ligero/pregunta-server.webp)

Mirá bien la imágen, no es un montaje. ¡Es real! El scroll del programa, por ejemplo, es sin delay y perfecto. Todo funciona según lo planeado.

![alt text]({{ base_url }}/assets/posts/editor-por-ssh-ligero/synaptic-gui.webp)

# 6. Buscador de conexiones.

Cada vez que el programa se abra, mostrará las conexiones SSH guardadas. Además, desde el campo "Filter" permitirá buscar coincidencias en los nombres de las conexiones que se guardaron.

![El buscador permite filtrar por nombre de una conexión, por ejemplo: "LXC"]({{ base_url }}/assets/posts/editor-por-ssh-ligero/buscador-de-conexiones.webp)

# 7. Cliente Telnet.

> En cuánto Telnet, no tengo mucha idea. Si alguien puede arrojar luz en los comentarios sobre para qué más sirve, se lo agradezco. Por ahora enseño lo que sé.

Telnet permitirá comprobar puertos abiertos, si escribimos en el campo **Connect to** la IP y el puerto con la siguiente sintáxis:

```
<IP>:<PUERTO>
```

Luego se realiza clic en "Test connection now" para comprobar que el puerto en la computadora remota esté disponible.

![Comprobación de puerto]({{ base_url }}/assets/posts/editor-por-ssh-ligero/telnet-puerto.webp)

---

¡Eso es todo! Ojalá sea de utilidad. Por si acaso, el link para descargar esta [áca](https://sysprogs.com/SmarTTY/download/).