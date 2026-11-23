---
layout: post
title:  "Instalar un servidor de correo propio y moderno · Maddy Mail Server"
date:   2025-03-27 19:24:00 -0300
categories: email
tags: email, email server, smtp server, imap server, go language
---

# Preámbulo

Dentro del amplio ecosistema de servidores de correo electrónico en Linux, donde lo habitual es combinar múltiples piezas por separado (como Postfix para SMTP, Dovecot para IMAP y OpenDKIM para firmas), **Maddy Mail Server** destaca por unificar todo en un único binario escrito en Go, ligero y fácil de mantener.

En este tutorial se detallará cómo instalar y configurar un servidor de correo "con llave en mano". En este tutorial se va a instalar el servidor Maddy dentro de un contenedor LXC no privilegiado (Debian), dejándolo listo para enviar y recibir correos con estándares modernos de seguridad y entregabilidad.

> Existen **requisitos previos**: contar con un dominio propio, acceso al panel de gestión de DNS y una IP pública con los puertos **25, 80, 143, 465, 587 y 993** abiertos hacia el servidor.

# Instalar dependencias

Para poder descomprimir el paquete oficial que distribuye el proyecto, primero se debe instalar ***zstd*** como usuario `root`:

```bash
apt update
apt install zstd -y
```

# Descargar el binario

En la [página oficial de compilaciones de Maddy](https://maddy.email/builds/) se encuentran los binarios precompilados. Para este ejemplo se utiliza la versión `0.8.1` (estable al momento de redactar esta guía).

Desde la terminal del servidor, descargar el archivo comprimido:

```bash
wget https://maddy.email/builds/0.8.1/maddy-0.8.1-x86_64-linux-musl.tar.zst
```

# Instalar el binario

Descomprimir el paquete descargado:

```bash
tar --use-compress-program=unzstd -xvf maddy-0.8.1-x86_64-linux-musl.tar.zst
```

Copiar el binario al directorio `/usr/local/bin` para que esté disponible globalmente en el sistema:

```bash
cp maddy-0.8.1-x86_64-linux-musl/maddy /usr/local/bin/maddy
```

Asignarle permisos de ejecución:

```bash
chmod +x /usr/local/bin/maddy
```

# Instalar el servicio en systemd

El paquete incluye los archivos de unidad para `systemd` listos para usar. Copiarlos al directorio del sistema:

```bash
cp maddy-0.8.1-x86_64-linux-musl/systemd/* /etc/systemd/system/
```

Recargar el demonio de `systemd` para que reconozca los nuevos servicios:

```bash
systemctl daemon-reload
```

Habilitar el servicio para que arranque con el sistema (todavía sin iniciarlo, ya que falta la configuración):

```bash
systemctl enable maddy
```

# Crear usuario y grupo específico

Por seguridad, Maddy no debe ejecutarse como `root`. La documentación oficial recomienda crear un usuario y grupo dedicados exclusivamente al servicio, junto con su directorio de datos en `/var/lib/maddy`:

```bash
useradd -mrU -s /sbin/nologin -d /var/lib/maddy -c "maddy mail server" maddy
```

# Crear archivo de configuración

Crear el directorio de configuración y copiar la plantilla base incluida en el paquete:

```bash
mkdir /etc/maddy
cp maddy-0.8.1-x86_64-linux-musl/maddy.conf /etc/maddy/
```

Editar el archivo de configuración:

```bash
nano /etc/maddy/maddy.conf
```

Buscar las siguientes dos directivas al inicio del archivo:

```text
$(hostname) = mx1.example.org
$(primary_domain) = example.org
```

* **`$(hostname)`**: Debe coincidir con el subdominio que responderá como servidor de correo (el registro MX).
* **`$(primary_domain)`**: Corresponde al dominio principal registrado (en Nic.ar, Cloudflare, Hostinger, etc.).

Para el dominio de ejemplo utilizado en esta guía (`inforce.cloud`), la configuración queda así:

```text
$(hostname) = mx1.inforce.cloud
$(primary_domain) = inforce.cloud
```

# Crear subdominios DNS iniciales

Antes de solicitar los certificados TLS, es necesario crear los registros **A** (y **AAAA** si se utiliza IPv6) en el proveedor de DNS apuntando a la IP pública del servidor para los siguientes subdominios:

* `mx1.inforce.cloud`
* `smtp.inforce.cloud`
* `imap.inforce.cloud`
* `webmail.inforce.cloud`

Esto es indispensable para que **Certbot** pueda validar la propiedad de cada subdominio a través del puerto 80.

# Generar certificados TLS

Si el servidor aún no cuenta con certificados válidos, instalar **Certbot**:

```bash
apt install certbot -y
```

Generar un certificado multi-dominio (SAN) en modo *standalone* que cubra todos los subdominios configurados en el paso anterior (el puerto 80 debe estar libre durante este proceso):

```bash
certbot certonly --standalone -d mx1.inforce.cloud -d webmail.inforce.cloud -d smtp.inforce.cloud -d imap.inforce.cloud
```

El asistente solicitará un correo de contacto y aceptar los términos de servicio. Al finalizar, mostrará una salida similar a esta:

```text
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for mx1.inforce.cloud and 3 more domains

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/mx1.inforce.cloud/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/mx1.inforce.cloud/privkey.pem
This certificate expires on 2025-06-25.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.
```

# Vincular certificados TLS en Maddy

En `/etc/maddy/maddy.conf`, Maddy espera encontrar los certificados bajo la siguiente ruta:

```text
tls file /etc/maddy/certs/$(hostname)/fullchain.pem /etc/maddy/certs/$(hostname)/privkey.pem
```

Como Let's Encrypt almacena los archivos en `/etc/letsencrypt/` con permisos restrictivos para `root`, se debe otorgar propiedad al usuario `maddy` sobre las carpetas `live` y `archive` para que pueda leer tanto el certificado como la clave privada:

```bash
chown -R maddy:maddy /etc/letsencrypt/{live,archive}
```

Crear el directorio de certificados de Maddy y generar un enlace simbólico apuntando al certificado generado:

```bash
mkdir -p /etc/maddy/certs
ln -s /etc/letsencrypt/live/mx1.inforce.cloud /etc/maddy/certs/mx1.inforce.cloud
```

> **Nota:** Maddy recarga automáticamente los certificados del disco cada minuto. Si se renueva un certificado de forma manual, también se puede forzar la recarga reiniciando el servicio con `systemctl restart maddy`.

# Configurar registros DNS esenciales

Para que los servidores externos (Gmail, Outlook, etc.) acepten los correos enviados y no los envíen a spam, se deben configurar los registros básicos en el panel DNS del dominio (reemplazando `203.0.113.10` por la IP pública real del servidor):

| Tipo | Nombre / Host | Valor / Destino | Prioridad | Propósito |
| :--- | :--- | :--- | :--- | :--- |
| **A** | `mx1` | `203.0.113.10` | - | Apunta el servidor MX a la IP del contenedor. |
| **A** | `smtp` | `203.0.113.10` | - | Subdominio de envío para clientes de correo. |
| **A** | `imap` | `203.0.113.10` | - | Subdominio de recepción para clientes de correo. |
| **A** | `webmail` | `203.0.113.10` | - | Acceso web (si se despliega Roundcube/SnappyMail). |
| **MX** | `@` | `mx1.inforce.cloud` | `10` | Indica qué servidor recibe los correos del dominio. |
| **TXT** | `@` | `v=spf1 mx -all` | - | **SPF:** Autoriza únicamente al servidor MX a enviar correos. |
| **TXT** | `_dmarc` | `v=DMARC1; p=quarantine; rua=mailto:postmaster@inforce.cloud; adkim=s; aspf=s` | - | **DMARC:** Define qué hacer si fallan SPF o DKIM. |

### Registro PTR (DNS Inverso / rDNS)

Este registro **no se configura en el panel del dominio**, sino en el panel del proveedor de VPS o ISP dueño de la IP pública. Se debe solicitar que la IP `203.0.113.10` resuelva inversamente hacia `mx1.inforce.cloud`. Sin un PTR coincidente, la mayoría de los servidores rechazarán los mensajes.

# Iniciar el servicio

En muchas instalaciones de Debian/Ubuntu viene instalado **Postfix** por defecto ocupando el puerto 25. Antes de iniciar Maddy, asegurarse de detenerlo y deshabilitarlo:

```bash
systemctl stop postfix
systemctl disable postfix
```

Iniciar Maddy y verificar que esté corriendo sin errores:

```bash
systemctl start maddy
systemctl status maddy
```

# Configurar clave DKIM

Durante su primer arranque, Maddy genera automáticamente el par de claves criptográficas para firmar los correos salientes con **DKIM**. El registro DNS listo para copiar se encuentra en `/var/lib/maddy/dkim_keys/`:

```bash
cat /var/lib/maddy/dkim_keys/inforce.cloud_default.dns
```

Copiar el contenido completo del archivo (comienza con `v=DKIM1; k=rsa; p=...`) y crear un nuevo registro de tipo **TXT** en el panel DNS con el nombre `default._domainkey`:

![Crear registro TXT para almacenar la clave DKIM]({{ base.url }}/assets/posts/instalar-maddy-mail-server/dkim-domainkey.png)

# Política MTA-STS y TLS-RPT

**MTA-STS** evita ataques *Man-in-the-Middle* (MitM) forzando a los servidores remitentes a utilizar conexiones TLS válidas al entregar correo hacia nuestro dominio.

Para implementarlo, se necesitan tres elementos:

1. **Registro DNS A:** Crear el subdominio `mta-sts.inforce.cloud` apuntando a la IP del servidor (y emitirle un certificado TLS válido, por ejemplo con Certbot).
2. **Archivo de política web:** Servir mediante Nginx o Caddy la ruta `https://mta-sts.inforce.cloud/.well-known/mta-sts.txt` con el siguiente contenido exacto:

```text
version: STSv1
mode: enforce
max_age: 604800
mx: mx1.inforce.cloud
```

3. **Registros DNS TXT:** Añadir el identificador de versión de MTA-STS y el buzón de reportes TLS:

| Tipo | Nombre / Host | Valor |
| :--- | :--- | :--- |
| **TXT** | `_mta-sts` | `v=STSv1; id=2025032701` |
| **TXT** | `_smtp._tls` | `v=TLSRPTv1; rua=mailto:postmaster@inforce.cloud` |

# Registro DANE TLSA

**DANE** permite publicar la huella criptográfica del certificado TLS directamente en el DNS (requiere tener **DNSSEC** activado en el dominio). Esto refuerza la reputación y seguridad del servidor.

Para generar los parámetros, ingresar al [generador de registros TLSA de Huque](https://www.huque.com/bin/gen_tlsa).

Extraer el certificado público del servidor:

```bash
cat /etc/letsencrypt/live/mx1.inforce.cloud/cert.pem
```

Pegar el contenido completo (incluyendo `-----BEGIN CERTIFICATE-----` y `-----END CERTIFICATE-----`) en el campo *"Enter/Paste PEM format X.509 certificate here"* y completar las opciones como se muestra a continuación (utilizando uso `3` DANE-EE, selector `1` SPKI y tipo de coincidencia `1` SHA-256):

![Formulario generador DANE TLSA]({{ base.url }}/assets/posts/instalar-maddy-mail-server/dane-tlsa-form.png)

Al hacer clic en **Generate**, la herramienta devolverá los parámetros del registro:

![Parámetros generados para TLSA]({{ base.url }}/assets/posts/instalar-maddy-mail-server/tlsa-parameters.png)

Junto con una salida en formato de zona DNS similar a esta:

```text
_25._tcp.mx1.inforce.cloud. IN TLSA 3 1 1 (
                  b2d91c34f42b470d10816773d07bb09fc83f64183edd45ae76de786fc0b1
                  cfdc
)
```

Copiar los tres valores numéricos (`3`, `1`, `1`) y la cadena hexadecimal sin espacios ni saltos de línea. Luego, crear un registro de tipo **TLSA** en el panel DNS asociado al host del servidor MX (`_25._tcp.mx1`):

![Registro TLSA configurado en el panel DNS]({{ base.url }}/assets/posts/instalar-maddy-mail-server/tlsa-record-terminado.png)

# Comprobar propagación y estado de DNS

Antes de comenzar a enviar correos, conviene verificar desde la terminal que todos los registros respondan correctamente utilizando `dig`:

```bash
# Verificar registro MX y PTR
dig MX inforce.cloud +short
dig -x 203.0.113.10 +short

# Verificar SPF, DKIM y DMARC
dig TXT inforce.cloud +short
dig TXT default._domainkey.inforce.cloud +short
dig TXT _dmarc.inforce.cloud +short

# Verificar MTA-STS y TLSA
dig TXT _mta-sts.inforce.cloud +short
dig TLSA _25._tcp.mx1.inforce.cloud +short
```

Adicionalmente, se recomienda pasar una auditoría completa en plataformas externas como **MXToolbox**, **Hardenize** y enviar un correo de prueba a **Mail-Tester** para confirmar una puntuación de 10/10 antes de poner el servidor en producción.

# Crear casillas de email

A diferencia de configuraciones tradicionales con Dovecot, Maddy gestiona **usuarios virtuales** independientes de las cuentas del sistema Linux. Crear una casilla requiere dos pasos: crear las credenciales de autenticación y habilitar el buzón IMAP.

Por ejemplo, para crear la cuenta `sistemas@inforce.cloud`:

1. Crear las credenciales (solicitará escribir la contraseña una única vez):

```bash
maddy creds create sistemas@inforce.cloud
```

2. Crear la cuenta de almacenamiento IMAP asociada:

```bash
maddy imap-acct create sistemas@inforce.cloud
```

Con esto la casilla queda operativa y lista para configurarse en cualquier cliente de correo (Thunderbird, Apple Mail, Outlook o aplicaciones móviles) utilizando `smtp.inforce.cloud` (puerto 465 SSL/TLS o 587 STARTTLS) e `imap.inforce.cloud` (puerto 993 SSL/TLS).

# Referencias y fuentes

* [Documentación oficial de Maddy Mail Server — Tutorial de instalación](https://maddy.email/tutorials/setting-up/)
* [Repositorio de compilaciones oficiales de Maddy](https://maddy.email/builds/)
* [Generador de registros DANE TLSA — Shumon Huque](https://www.huque.com/bin/gen_tlsa)