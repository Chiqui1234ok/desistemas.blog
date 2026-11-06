---
layout: post
title:  "Bitwarden gratis (selfhosted) en Linux • Vaultwarden"
date:   2025-09-21 12:49:00 +0000
tags: guía, tutorial, docker, bitwarden, vaultwarden, linux, contenedor
---
# Preámbulo

Tener contraseñas almacenadas en el navegador web es un riesgo. Las vulnerabilidades que se pueden explotar mediante JavaScript o plug-ins es alarmante, y ningún navegador se salva.

Ahora decidí depositar mi confianza en un cliente + servidor que, con el pasar de los años, demostró su robustez.

Usé la versión paga a nivel empresarial, y ahora toca resguardar un poco más la situación en casa.

En este tutorial se va a utilizar el cliente oficial de Bitwarden Desktop v2025.8.2. Se instalará la última versión del servidor Vaultwarden (1.34.3).

El tutorial se basa en Debian 12.7, los comandos deberían funcionar en cualquier distribución basada en Debian y el gestor de paquetes ***apt***.

# Instalar Docker

1. Iniciar sesión en Linux con algún usuario que permita elevar permisos de super usuario.
2. Elevar permisos de sudo con `sudo su`. Si no reconoce el comando, también se pueden elevar privilegios con `su -`.
3. Actualizar el repositorio de paquetes:
```
apt update
```

4. Instalar dos aplicaciones:
```
apt install ca-certificates curl -y
```

5. Crear la carpeta **keyrings** con permisos 755:
```
install -m 0755 -d /etc/apt/keyrings
```

6. Descargar la key de Docker, para incorporarlo a los repositorios de ***apt*** en breves:
```
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
```

7. Dar permisos de lectura a todos los usuarios para la clave **docker.asc**:
```
chmod a+r /etc/apt/keyrings/docker.asc
```

8. Añadir la key y repositorio al **sources.list**:
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
```

9. Actualizar el repositorio de paquetes para tomar el cambio:
```
apt update
```

10. Instalar Docker:
```
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

Ahora será posible seguir con la instalación de Vaultwarden, que se distribuye de forma más cómoda vía Docker.

# Instalar Vaultwarden (servidor)

1. Se crea una carpeta para Vaultwarden en **/opt**:
```
mkdir /opt/vaultwarden && cd /opt/vaultwarden
```

2. Se crea la carpeta dónde se guardarán los datos de Vaultwarden:
```
mkdir data
```

3. Se crea el archivo de configuración Docker:
```
touch docker-compose.yml
```

4. Se le pega este contenido al archivo **docker-compose.yml**, ejecutando `nano docker-compose.yml` y escribiendo lo siguiente:
```
services:
    vaultwarden:
        container_name: vaultwarden
        image: vaultwarden/server:1.34.3
        ports:
            - "80:80"
        volumes:
            - ./data:/data
```
5. Al terminar de tipear o pegar el contenido sobre el archivo **docker-compose.yml**, se presiona la combinación de teclas CTRL + X. Preguntará si se desea guardar el archivo, cosa que es deseada, por ende se presiona la tecla "Y" para luego apretar la tecla "ENTER".

# Comprobar que esté todo bien

Para iniciar el servidor se debe estar en la carpeta **/opt/vaultwarden**:
```
cd /opt/vaultwarden
```

Y luego ejecutar el contenedor con:
```
docker compose up -d
```

Se puede observar que el contenedor imprime texto por pantalla haciendo:

```
docker logs vaultwarden
```

Cuya salida es:

```
/--------------------------------------------------------------------\
|                        Starting Vaultwarden                        |
|                           Version 1.34.3                           |
|--------------------------------------------------------------------|
| This is an *unofficial* Bitwarden implementation, DO NOT use the   |
| official channels to report bugs/features, regardless of client.   |
| Send usage/configuration questions or feature requests to:         |
|   https://github.com/dani-garcia/vaultwarden/discussions or        |
|   https://vaultwarden.discourse.group/                             |
| Report suspected bugs/issues in the software itself at:            |
|   https://github.com/dani-garcia/vaultwarden/issues/new            |
\--------------------------------------------------------------------/
```

# Dirigirse a la aplicación web de Vaultwarden

Para averiguar la IP del equipo dónde se ejecuta el Vaultwarden "dockerizado", se puede ejecutar:

```
hostname -I
```

Esto listará varias IP. Las que comienzan con "172" son redes internas de Docker, por lo cuál se intuye que `10.0.0.124` es la correcta. En tu caso puede variar, y comenzar con los números "192.168".
172.17.0.1 172.18.0.1 10.0.0.124 fd4c:3741:5a82:0:be24:11ff:febc:b13c

# Utilizar HTTPS con la aplicación



# Instalar Bitwarden (cliente)

Este tutorial se enfocará en el cliente "Desktop v2025.8.2", que se consigue scrolleando un poco en el link de [GitHub Bitwarden Releases](https://github.com/bitwarden/clients/releases).
