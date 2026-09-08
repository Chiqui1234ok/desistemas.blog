---
layout: post
title:  "Creación de Odoo 18 / OpenERP • Docker"
date:   2024-12-22 19:00:00 +0000
tags: odoo 18, erp, docker, lxc
---

# Ficha técnica Contenedor LXC

- **Nombre**: LXC 5.0.2
- **Descripción**: Esta guía es para crear un contenedor, dónde correrá Docker con un sistema ERP
- **Apps instaladas**: `docker` (vía APT, [luego de añadirlo a los repositorios](https://docs.docker.com/engine/install/debian/)), `git` (vía APT), `python3` (vía APT). Instalé módulos Python: `pip install passlib psycopg2-binary`
- **Variables de entorno en LXC**: edité el archivo `/etc/environment` con las siguientes variables:

```bash
POSTGRES_USER=odoo
POSTGRES_PASSWORD=odoo
POSTGRES_DB=odoo-app
POSTGRES_PORT=5432
POSTGRES_HOST=db
```

Para actualizarlas en la misma sesión sin necesidad de reiniciar: `source /etc/environment`.

<aside>
👀

Cuidado si usás byobu, tiene un error y es que estas variables de entorno no las toma. Si ejecutás el docker desde byobu, tendrás problemas. Ejecutá esto desde una *shell* o *tty*.

Aviso por si estás en Laboratorio probando cosas…

</aside>

- **Utilidades**:
    - Armé un script Python para resetear contraseñas de la BD. Ver título “Cambiar contraseña de un usuario”

# Repositorio .git

Creé un repositorio en **GitHub** que podés clonar para tener todos los archivos necesarios para levantar el servicio **docker**, crear el servicio en **systemd**, tener ciertas utilidades que desarrollé y más. Nos vamos a la carpeta `/opt` y clonamos:

```bash
git clone https://github.com/Chiqui1234ok/odoo-18-docker.git
```

# Crear carpeta para Odoo

1. En la misma carpeta dónde está el archivo docker-compose.yml, se crea la carpeta **odoo_data**: `mkdir odoo_data`
2. Le damos permisos para que únicamente el usuario y grupo 101 accedan a esa carpeta. Este número es el del usuario `odoo` en el contenedor Docker. Básicamente hacemos un “mapeo” de las carpetas que ejecuta el servicio **odoo** en el docker-compose.yml: `chown 100:101 -R ./odoo_data` y `chown 100:101 -R ./etc` .

La carpeta **etc** debería estar junto a docker-compose.yml.

En caso de que no esté, por favor, creá la carpeta **etc** en el mismo lugar dónde está docker-compose.yml, y dentro creá el archivo `odoo.conf` con el siguiente contenido:

```bash
[options]
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo
# La línea de abajo es opcional, si no querés que se rellene el sistema con datos de prueba
# demo = {}
```

No te olvides de correr `chown 100:101 -R ./etc`, si **etc** no estaba y la acabás de crear.

# Crear carpeta para PostgreSQL

1. En la misma ubicación dónde está el archivo docker-compose.yml, se crea la carpeta **db_data**: `mkdir db_data`.
2. Le damos permisos al usuario y grupo 999, que corresponde al usuario **postgres** del servicio **db**: `chown 999:999 -R ./db_data` .

# Iniciar Odoo

Con `docker compose up -d` corremos el contenedor en modo “daemon” (segundo plano). Aún no accedemos a la interfaz web, antes debemos inicializar la base de datos.

## Inicializar la base de datos

```docker
docker exec -it odoo odoo --db_host=db --db_user=odoo --db_password=odoo -d odoo-app -i base --xmlrpc-port=8070
```

Este comando creará la DB con las credenciales de PostgreSQL, tablas y datos que necesita Odoo para funcionar. Ejecutamos este inicializador en un puerto distinto, si.

<aside>
💡

Si querés que **no** se creen datos demo al activar módulos, agregá el argumento `--without-demo=all` al final del comando de arriba (*docker exec -it*).

También podés agregar `demo = {}` en el archivo `odoo.conf`. Puede aparecer un mensaje al instalar módulos nuevos, que notifica que no creará datos de demostración.

</aside>

La inicialización de la base de datos es un proceso rápido. Al finalizar verás mensajes como éstos:

```bash
INFO odoo-app odoo.modules.loading: Module base loaded in 7.61s, 8156 queries (+8156 other)
INFO odoo-app odoo.modules.loading: 1 modules loaded in 7.61s, 8156 queries (+8156 extra)
INFO odoo-app odoo.modules.loading: updating modules list
INFO odoo-app odoo.addons.base.models.ir_module: ALLOW access to module.update_list on [] to user __system__ #1 via n/a
INFO odoo-app odoo.modules.loading: loading 12 modules...
INFO odoo-app odoo.modules.loading: 12 modules loaded in 0.21s, 0 queries (+0 extra)
INFO odoo-app odoo.modules.loading: Modules loaded.
INFO odoo-app odoo.modules.registry: Registry changed, signaling through the database
INFO odoo-app odoo.modules.registry: Registry loaded in 8.877s
```

Al leer que el registro se cargó (sabemos eso porque se lee *Registry loaded*), podemos hacer CTRL + C, para detener el proceso y comenzar a trabajar en la interfaz de Odoo.

# Entrar a la interfaz

Ya con el servicio `odoo` y `db` levantados, y el PostgreSQL inicializado con los datos que precisa **Odoo**, podemos ingresar a la interfaz con usuario y contraseña `admin`, URL: `<ip de tu lxc/vm>`.

Ésto del puerto está especificado en la siguiente parte del **docker-compose.yml**:

```bash
 odoo:
	  [...]
    ports:
      - "80:8069"
```

Indica el mapeo de la siguiente forma: “<puerto host>:<puerto docker>”.

Podemos cambiar el primer “80” al puerto que quisiéramos, como el **puerto 8069**.

Ésto es útil para cuándo necesitamos acceder directamente a la interfaz entrando por la IP del LXC/VM, o bien si el puerto 8069 ya está ocupado en el LXC/VM que tiene el Docker de **OpenERP**.

El puerto dentro de Docker no puede tocarse, porque es dónde **OpenERP** se sitúa por defecto y habría que cambiar archivos de configuración de Odoo. Además, no tiene sentido porque Docker sólo ejecutará dos servicios, y allí no hay conflicto de puertos.

<aside>
💡

Yo configuré ésto de forma tal que:

**Hipervisor** > **LXC** > **Docker** > 2 servicios (Odoo 18 + PostgreSQL).

</aside>

Los puertos utilizados dentro del Docker, no se pisan con los sistemas padres, siendo éstos el LXC y luego el Hipervisor.

# Ingresar a la base de datos

Si se precisa entrar a la base de datos, ejecutar este comando desde fuera del Docker.

```bash
docker exec -it db psql -U odoo -d odoo-app
```

## Explicación del comando

Básicamente se ingresa de forma interactiva (es decir, podremos escribir comandos) con el parámetro **-it**, al servicio **db**. En dicho servicio/contenedor se ejecuta el binario de PostgreSQL (psql) con el usuario *odoo* y la base de datos *odoo-app* 😄

# Consultar un usuario de la base de datos

Con el comando para ingresar a la BD (`docker exec -it db psql -U odoo -d odoo-app`), procedemos a realizar una consulta SQL para saber si existe el usuario.

Yo hice la consulta para el usuario **admin**.

```bash
SELECT * FROM res_users WHERE login = 'admin';
```

Esta consulta devolverá todos los datos del usuario `admin`.

# Cambiar contraseña de un usuario

Desde el sistema host (no dentro del Docker), ejecutamos el script: `python3 /opt/odoo/db-tools/update-password.py` .

Nos preguntará por el usuario al cuál queremos cambiarle la contraseña, y si no existe nos lo dirá.

Si existe, simplemente colocamos la contraseña una vez, apretamos **Enter** en el teclado y se actualizará automáticamente. Veremos algo así por consola:

```bash
$ python3 /opt/odoo/db-tools/update-password.py
Introduce el nombre del usuario (login) de Odoo: admin
Introduce la nueva contraseña:
# 👇 Nos indica que actualizó un registro, es decir, un usuario
UPDATE 1
# 👇 Nos indica que fue todo actualizado correctamente
Contraseña para el usuario 'admin' actualizada correctamente.
```

# Activar un usuario

¿No tenés Odoo conectado al servidor de emails? Bueno, los usuarios no podrán validar su cuenta desde el correo de invitación.

<aside>
💡

En mi caso no requerí ésto, pero como el hombre que hace el tutorial nunca se equivoca y siempre le anda, supuse que los mortales que se inician en Odoo podrían tener problemas (o una versión de Odoo nueva que endurezca esta política). Por las dudas, te creo esta sección. *Hombre precavido vale por dos* 😄

</aside>

Para corregir ésto desde PostgreSQL, debemos entrar al servicio `db` de docker con el comando:

```bash
docker exec -it db psql -U odoo -d odoo-app
```

Yo tenía que activar mi usuario *anabel@odontopraxis.com.ar*, así que en la consola de Postgre, realizo la búsqueda:

```bash
SELECT id, login, active FROM res_users WHERE login = 'anabel@odontopraxis.com.ar';
```

Y eso por suerte, me imprime el usuario:

```bash
 id |           login            | active
----+----------------------------+--------
  7 | anabel@odontopraxis.com.ar | f
```

Podemos cambiar la columna `active`, que está en false, por **t** (true) con:

```bash
UPDATE res_users SET active = true WHERE login = 'anabel@odontopraxis.com.ar';
```

---

Con todo lo explicado acá, podremos levantar la app y realizar tareas de mantenimiento básicas.