---
layout: post
title:  "Como exponer un servicio o app fácil (SSL) • Nginx"
description: "Si estás queriendo lanzar tu aplicación a producción sin necesidad de Docker y con certificados SSL, esta guía actualizada te va a servir enormemente."
image: "/assets/posts/como-exponer-un-servicio-o-app-con-nginx-facil-ssl/portada.webp"
date:   2025-11-26 16:45:00 -0300
categories: [homelabing]
tags: nginx, servicio, app, ssl, certificado
---

# Preámbulo

Bienvenido a un tutorial corto para una pieza de software que desborda en funciones. No se va a encontrar nada más potente que Nginx, que a día de hoy se utiliza para:
- Servidor web HTTP (soporta SSL/TLS): entrega contenido HTML, HTM, PHP, etc.
- Cachear contenido: se puede construir un CDN muy potente y para una infinidad de formatos de archivo.
- **Proxy inverso**: la solución para conectar un servicio que escucha en un puerto y redirigirlo a otro. Por ejemplo, una API en NodeJs / Python que está en el puerto 3000, pero que se desea montar en el puerto 80 de la ruta "api.desistemas.blog".
- Balanceador de carga: seleccionar servidores o recursos de forma inteligente para nivelar las peticiones de clientes entre todos los servidores.
- Servidor proxy TCP/UDP
- Servidor proxy de correo

En este post se va a enseñar a exponer una app / servicio en un puerto específico mediante **proxy inverso** (reverse proxy).

También se verá como obtener un certificado SSL gratis.

> La implementación se basa en las que hago regularmente en empresas. Siempre funciona como "el primer día", y sin arañar más recursos de los necesarios.

# Equipo del tutorial

- 1 núcleo Intel Brodwell
- 1GB de RAM
- 10GB SSD
- Debian 13.1
- Nginx 1.26.3
- Dominio: vite.desistemas.blog

# Apuntar correctamente los DNS

Para averiguar la IP del servidor hay dos opciones:
1. Revisar el dato en el panel de control del servidor, en el hosting que se contrató.
2. Consultar [api.ipify.org](https://api.ipify.org) desde la terminal:

```bash
curl https://api.ipify.org/
```

Cualquiera de estas dos opciones informará la IP.

Una vez se consigue este dato, se debe ir a la zona DNS del proveedor del dominio y crear un registro de tipo A.

> Los DNS tipo "A" son los que vinculan una dirección URL a una IPv4, como por ejemplo, *186.160.160.14*.

En la siguiente imágen, se muestra como realizar esto:

![alt text]({{ base.url }}/assets/posts/como-exponer-un-servicio-o-app-con-nginx-facil-ssl/apuntado-de-dns.webp)

De esta forma, se consigue que cuándo alguien busque "vite.desistemas.blog", el servidor DNS apunte a la IP del servidor que se está configurando. Así, el usuario llega al servidor nginx, que toma la solicitud y la pasa por el proxy inverso que se configurará más adelante.

> Esto también es clave para poder configurar el certificado SSL. Se verá más adelante.

# Comprobar la expansión de DNS

Se puede consultar el sitio web [DNS Checker](https://dnschecker.org) y escribir la URL que se está configurando (vite.desistemas.blog). En cuestión de segundos se verá que el dominio apunta correctamente a la IP del servidor.

![alt text]({{ base.url }}/assets/posts/como-exponer-un-servicio-o-app-con-nginx-facil-ssl/expansion-de-dns.webp)

Sólo falta [generar el certificado SSL](#generar-el-certificado-ssl) y la [configuración de Nginx](#configuración-de-nginx).

# Actualización de los repositorios

Para poder instalar algo, primero se deben ejecutar dos comandos:

1. Elevar permisos como usuario root:

```bash
su -
```

2. Actualizar los repositorios de paquetes (APT):

```bash
apt update
```

Ahora, será posible instalar el servidor Nginx.

# Instalación de Nginx

Con los permisos elevados, se ejecuta:

```bash
apt install nginx -y
```

Nginx deberá ser configurado **después** de [generar el certificado SSL](#generar-el-certificado-ssl).

# Generar el certificado SSL

## Instalación de las dependencias

Como usuario root debe ejecutarse el siguiente comando, que instalará "certbot" y el plugin para nginx:

```bash
apt install certbot python3-certbot-nginx -y
```

## Generar el certificado con Certbot

Este proceso es sencillo. Realizará unas breves preguntas y luego solicitará el certificado.
Para lograrlo, debe ejecutarse este comando como usuario root (para el caso del tutorial, se quiere solicitar un certificado para el nuevo sub-dominio "vite.desistemas.blog"):

```bash
certbot --nginx -d vite.desistemas.blog
```

Cuándo Certbot finaliza exitosamente, lo indicará de la siguiente manera:

```
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/vite.desistemas.blog/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/vite.desistemas.blog/privkey.pem
This certificate expires on 2026-02-14.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

Deploying certificate
Successfully deployed certificate for vite.desistemas.blog to /etc/nginx/sites-enabled/default
Congratulations! You have successfully enabled HTTPS on https://vite.desistemas.blog
```

> Es importante mencionar que se configura la renovación automática del certificado, por lo cuál no debería haber problema de certificado (TODO / EXPANDIR INFO).

## Las rutas dónde se guarda el certificado

Tal cuál indicó *certbot*, el certificado se guardó en:

```
/etc/letsencrypt/live/vite.desistemas.blog/fullchain.pem
```

Y la clave se almacenó en:

```
/etc/letsencrypt/live/vite.desistemas.blog/privkey.pem
```

Se debe tomar nota de estas rutas, porque deberán especificarse en la configuración de Nginx.

# Configuración de Nginx

Nginx es un motor HTTP que recibe peticiones de clientes y las procesa. Explicar el funcionamiento "detrás del telón" es importante para que el administrador del sistema entienda qué configura. A continuación, se enumera un caso de ejemplo para que se comprenda el funcionamiento:

1. Un cliente tipea "vite.desistemas.blog" en su navegador web.
2. El router de ese cliente recibe la petición, y consulta a un servidor DNS a qué servidor debe entrar
    - Por eso es importante [Apuntar correctamente los DNS](#apuntar-correctamente-los-dns), caso contrario, los usuarios no podrán saber a qué servidor apunta "vite.desistemas.blog".
3. El servidor DNS devuelve la IP del servidor HTTP.
4. El cliente consulta nuestro servidor con un HEADER HTTP. Entre los datos que envía en ese header, está la dirección URL.
5. El servidor recibe la dirección URL que se consultó mediante el HEADER y, si coincide con la URL configurada en Nginx, le entrega al cliente la página web o recurso que el administrador haya configurado para ese dominio.

Nginx, entonces, recibe peticiones que indican qué URL quiere mostrarse. Por ende, un mismo servidor puede atender consultas de dominios como desistemas.blog, vite.desistemas.blog, inforce.cloud, google.com, yahoo.com, etc; siempre y cuándo los servidores DNS del mundo sepan que todos esos dominios apuntan a un mismo servidor (y por ende, misma IP).

## Baja del sitio "default"

Certbot se configuró en el sitio default, pero se creará un nuevo "sitio" llamado **app**. Allí, residirá la configuración que hace posible que:

- Se redirija el tráfico HTTP a HTTPS.
- Se vincule el certificado y la clave, para activar SSL/TLS.
- Se cree un proxy inverso para conectar el puerto 443 al de la aplicación Vite que se desea exponer a internet.

Para que el sitio default no moleste, se procede a eliminar (como *root*) el vínculo simbólico que lo habilita:

```bash
rm /etc/nginx/sites-available/default
```

Es posible que la terminal consulte si se desea eliminar este enlace, a lo que se responde con la tecla **Y** y luego ENTER.

## Configuración del nuevo sitio a exponer

En la ruta **/etc/nginx/sites-available** se debe crear el archivo de configuración **app**.

```bash
touch /etc/nginx/sites-available/app
``` 

Y luego, se edita con `nano`:

```bash
nano /etc/nginx/sites-available/app
```

La configuración que se debe copiar y pegar es la siguiente. [Podés ver la breve explicación de cada línea importante acá](#explicación-del-archivo).

```bash
# Redirección de HTTP a HTTPS
server {
    listen 80;
    server_name vite.desistemas.blog;

    location / {
        return 301 https://$host$request_uri;
    }
}

# Proxy inverso en HTTPS
server {
    listen 443 ssl;
    server_name vite.desistemas.blog;

    # Certificados SSL
    ssl_certificate /etc/letsencrypt/live/vite.desistemas.blog/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/vite.desistemas.blog/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://localhost:5173;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Al terminar de editar este archivo, se presiona CTRL + O + ENTER para guardar el archivo, y CTRL + X para cerrar `nano`.

### Explicación del archivo

Dentro del primer objeto **server** es clave identificar varias líneas:

- server_name vite.desistemas.blog;
    - Esta línea indica que para los usuarios que busquen la dirección *vite.desistemas.blog*, nginx va a responder
- return 301 https://$host$request_uri;
    - Esto, dentro de `location /`, indica que las solicitudes serán redirigidas de forma permanente a la misma URL solicita por el cliente, pero en su versión segura HTTPS.

En el segundo objeto **server**, se escucha en el puerto 443, el que siempre se usa para la versión segura de los sitios web.

Se indica la ruta para el certificado SSL, que está comentado porque aún no se dio el alta del dominio (esto será hecho más adelante en este mismo tutorial).

Las líneas más importantes (además del detalle que *server_name* debería coincidir con el objeto **server** de más arriba) son:

- ssl_certificate
    - Si se observa el archivo `/etc/nginx/sites-available/default`, se observa que este parámetro tiene un archivo ".crt". Sin embargo, el archivo que genera *Certbot* es extensión "pem" y es totalmente válido.
- ssl_certificate_key
    - xxx
- proxy_pass http://localhost:5173;
    - Esto indica que al recibir solicitudes HTTPS a *vite.desistemas.blog*, nginx entregará lo que sea que esté en el puerto 5173 del servidor. En el caso del tutorial, es una aplicación escrita en Vue 3 (con el wrapper Vite).

## Habilitar la nueva configuración

Esto se hace de forma simple, realizando un enlace simbólico entre el archivo que se acaba de escribir y guardar hacia la carpeta **sites-enabled** de nginx:

```bash
ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/
```

## Comprobar el archivo `app`

Se comprueba la sintáxis del archivo de configuración con el comando:

```bash
nginx -t
```

Este comando informará que todo está bien:

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

> Como **nginx.conf** está incluyendo los archivos de **/etc/nginx/sites-enabled**, también está aclarando que el archivo **app** creado en este tutorial también está "ok"

## Reiniciar nginx

```bash
systemctl restart nginx
```

# Comprobar que el proxy funcione

*python3* está instalado por defecto. Se va a aprovechar para crear un pequeño servidor que responda un texto simple.

1. Se debe situar la terminal en la carpeta del usuario root:

```bash
cd ~
```

2. Se crea y abre el archivo **servidor_test.py**:

```bash
nano servidor_test.py
```

3. Se pega el siguiente código:

```py
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        print("¡La aplicación funciona! desistemas.blog")
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write("¡La aplicación funciona! desistemas.blog")

HTTPServer(('', 5173), Handler).serve_forever()
```

Y dentro de la aplicación nano, se guarda con CTRL + O + ENTER, y sale con las teclas CTRL + X.

4. Se ejecuta el código:

```
python3 servidor_test.py
```

5. Se visita la URL **vite.desistemas.blog** para comprobar que todo está bien.

![alt text]({{ base.url }}/assets/posts/como-exponer-un-servicio-o-app-con-nginx-facil-ssl/check-de-que-todo-esta-bien.webp)

# Epílogo

Hoy el administrador en sistemas aprendió a crear un sencillo proxy inverso con Nginx, dotandolo de seguridad de punto a punto, con una versión actualizada de nginx y en menos de 30 minutos.

> Nos vemos en un próximo artículo 😇