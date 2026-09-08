---
layout: post
title:  "Instalar Maddy Mail Server"
date:   2025-03-27 19:24:00 -0300
categories: email
tags: email, email server, smtp server, imap server
---

Santi del pasado: falta indicar el tema de los registros dns y emparejar toda la info y redacción.

# Preámbulo

De un sinfín de servidores de email, entregado de diferentes maneras, se encuentra Maddy Email. Este tutorial instalará la aplicación en un contenedor LXC no privilegiado.

# Instalar dependencia

Para poder descomprimir el archivo que ofrece maddy.email, se debe instalar ***zstd*** como usuario root:

```bash
apt update
apt install zstd -y
```

# Descargar binario

Se copia el link del archivo "maddy-0.8.1-x86_64-linux-musl.tar.zst", que se encuentra en el [siguiente link](https://maddy.email/builds/). La versión 0.8.1 es la más estable al día de hoy (Marzo 2025).

En una terminal, se descarga este archivo comprimido con:

```bash
wget https://maddy.email/builds/0.8.1/maddy-0.8.1-x86_64-linux-musl.tar.zst
```

# Instalar binario

Para instalar maddy, y que sea ejecutable como una app normal en Linux, primero se descomprime:

```bash
tar --use-compress-program=unzstd -xvf maddy-0.8.1-x86_64-linux-musl.tar.zst
```

Y se copia el binario a **/usr/local/bin**:

```bash
cp maddy-0.8.1-x86_64-linux-musl/maddy /usr/local/bin/maddy
```

Además, se le da permisos de ejecución:

```bash
chmod +x /usr/local/bin/maddy
```

# Instalar servicio

El servicio de systemd ya está preparado, sólo hay que copiarlo:

```bash
cp maddy-0.8.1-x86_64-linux-musl/systemd/* /etc/systemd/system/
```

Se recarga el listado de servicios con daemon-reload:

```bash
systemctl daemon-reload
```

Y se habilita el servicio, pero no se inicia:

```bash
systemctl enable maddy
```

# Crear usuario y grupo específico

La documentación de Maddy sugiere crear un usuario y grupo específico. No utilizan el grupo "mail", en cambio, crean uno propio:

```bash
useradd -mrU -s /sbin/nologin -d /var/lib/maddy -c "maddy mail server" maddy
```

# Crear archivo de configuración

```bash
mkdir /etc/maddy
```

Copiar el archivo de configuración de ejemplo:

```bash
cp maddy-0.8.1-x86_64-linux-musl/maddy.conf /etc/maddy/
```

Y editarlo:

```bash
nano /etc/maddy/maddy.conf
```

Se deben buscar las siguientes dos líneas:

```bash
$(hostname) = mx1.example.org
$(primary_domain) = example.org
```

Y cambiar "hostname" por la URL que se encargará del registro MX del DNS. El "primary domain" corresponde al dominio en sí (comprado y registrado en un sitio como Hostinger, GoDaddy, Nic.ar, etc).

Para el caso del ejemplo se dejará así:

```
$(hostname) = mx1.inforce.cloud
$(primary_domain) = inforce.cloud
```

# Crear sub-dominios DNS

Se debe crear el subdominio mx1, webmail, smtp e imap, todos apuntando al servidor (puerto 80). Porque es dónde certbot busca para generar el certificado.

# Generar certificados TLS

Si el servidor no tiene sus certificados TLS, que sería lo más común, se debe instalar "certbot" para realizar esto de forma más sencilla:

```bash
apt install certbot -y
```

Y luego se genera el certificado para los dominios que deben estar protegidos por el certificado. Por ello, se incluyen tanto el subdominio SMTP como el del webmail.

```bash
certbot certonly --standalone -d mx1.inforce.cloud -d webmail.inforce.cloud -d smtp.inforce.cloud -d imap.inforce.cloud
```

Este comando lanzará unas preguntas que se deben responder a consciencia. El proceso tardará menos de un minuto y arrojará este mensaje:

```bash
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for webmail.inforce.cloud and 2 more domains

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/webmail.inforce.cloud/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/webmail.inforce.cloud/privkey.pem
This certificate expires on 2025-06-25.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.
```

# Certificados TLS (ver si está bien)

En esta línea del archivo de configuración, se pueden ver los certificados que deben colocarse:

```
tls file /etc/maddy/certs/$(hostname)/fullchain.pem /etc/maddy/certs/$(hostname)/privkey.pem
```

Al [generar y guardar los certificados TLS en Let's Encrypt](#), se guardan en **/etc/letsencrypt/**, y por ende se crear un registro ACL para que el usuario "maddy" los pueda leer:

```bash
chown -R maddy /etc/letsencrypt/{live,archive}
```

Crear la carpeta **certs**:

```bash
mkdir /etc/maddy/certs
```

Hacer un link simbólico:

```bash
ln -s /etc/letsencrypt/live/mx1.inforce.cloud /etc/maddy/certs/mx1.inforce.cloud
```

---

Es importante notar que maddy refrescará su certificado cada un minuto, así que en caso de que se haya colocado uno nuevo, maddy lo reconocerá rápidamente. También puede forzarse este cambio realizando un reinicio del servicio con:

```bash
systemctl restart maddy
```

# Registros DNS

El como hacerlo está en el chat "Instalar maddy email" de chatgpt.

# Iniciar

Puede que postfix esté iniciado por default como servicio. Se debe detener y deshabilitar:

```bash
systemctl stop postfix
systemctl disable postfix
```

El servidor de correo se inicia con:

```bash
systemctl start maddy
```

# Clave DKIM

Hace falta un registro en el DNS para que el correo funcione como se debe, y es la clave DKIM. Esta clave se generó en el primer inicio de Maddy, se puede encontrar en: **/var/lib/maddy/dkim_keys/inforce.cloud_default.dns** y con el comando ***cat*** se verá la clave:

```bash
cat /var/lib/maddy/dkim_keys/inforce.cloud_default.dns
```

Se debe copiar esa clave y, en el DNS, añadirla como registro TXT. El nombre del registro debe ser "default._domainkey". En la siguiente imágen se ve como se concatena:

![Crear registro TXT para almacenar la clave DKIM]({{ base.url }}/assets/posts/instalar-maddy-mail-server/dkim-domainkey.png)

# Política MTA-STS y DANE

Para evitar ataques de tipo "MitM", se debe crear un archivo que esté disponible en la URL "https://mta-sts.inforce.cloud/.well-known/mta-sts.txt". Así que si, deberás tener un servidor NGINX o algo que sirva esa carpeta **.well-known** y su archivo mta-sts.txt.

El contenido de este archivo de texto será:

```
version: STSv1
mode: enforce
max_age: 604800
mx: mx1.inforce.cloud
```

# Registro DANE TLSA

Para crear un registro que muestre un un certificado TLSA (DANE), se va a [este link](https://www.huque.com/bin/gen_tlsa). Este paso es recomendable, ya que constituye a la reputación del dominio.

En el campo de texto "Enter/Paste PEM format X.509 certificate here" se debe copiar y pegar el contenido de **/etc/letsencrypt/live/mx1.inforce.cloud/cert.pem**, para ello:

```bash
cat /etc/letsencrypt/live/mx1.inforce.cloud/cert.pem
```

Y se pega todo el contenido en el formulario, desde la primera hasta la última línea.

El formulario se debe completar así, y ya habiendo colocado tu certificado propio.

![alt text]({{ base.url }}/assets/posts/instalar-maddy-mail-server/dane-tlsa-form.png)

Al hacer clic en el botón "Generate", el sitio llevará a una nueva página:

![alt text]({{ base.url }}/assets/posts/instalar-maddy-mail-server/tlsa-parameters.png)

Los números marcados deben anotarse para luego colocarse en el registro del DNS de tipo "TLSA".

Y además, un campo de texto mostrará un contenido similar a éste. Lo que importa es la cadena de texto entre paréntesis, que debe copiarse y eliminarse todos los espacios.

```
_25._tcp.mx1.inforce.cloud. IN TLSA 3 1 1 (
                  b2d91c34f42b470d10816773d07bb09fc83f64183edd45ae76de786fc0b1
                  cfdc
)
```

Estos 4 datos deben copiarse, y crear un registro "TLSA" como el siguiente, con el nombre "_25._tcp.smtp":

![alt text]({{ base.url }}/assets/posts/instalar-maddy-mail-server/tlsa-record-terminado.png)

# Comprobar expansión de DNS

Texto.

# Crear casillas de email

A diferencia de softwares como Dovecot o Postfix, Maddy utiliza "usuarios virtuales", que pueden crearse y no tienen relación con usuarios del sistema Linux. Para crear una casilla de correo para el área de sistemas, se utiliza el comando:

```bash
maddy creds create sistemas@inforce.cloud
```

Pedirá la contraseña una única vez, favor de escribirla correctamente.

Luego de tipear la contraseña y presionar ENTER, Maddy creará un usuario que ahora se debe autorizar para el acceso IMAP y SMTP:

```bash
maddy imap-acct create sistemas@inforce.cloud
```

https://maddy.email/tutorials/setting-up/