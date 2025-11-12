---
layout: post
title:  "Como configurar un dominio con DDNS (IP dinámica) • Cloudflare"
date:   2025-11-12 14:35:00 -0300
categories: [homelabing]
tags: cloudflare, router, ip estática, ip fija, ip dinámica, ddns, dynamic dns, dinámico
---

# Preámbulo

En este tutorial se presenta la solución para poder configurar **ddclient** con los servicios de Cloudflare mediante una API Token, y así no requerir una IP estática o fija para tener servicios online.

Se enseña desde la vinculación de nameservers de Cloudflare en Hostinger, hasta la compilación y configuración de la última versión de ddclient al día de hoy: ddclient 4.0.0.

# Añadir el dominio a la cuenta de Cloudflare

En la cuenta de Cloudflare que se realizará toda la configuración del DDNS, el administrador debe dirigirse a [dash.cloudflare.com](https://dash.cloudflare.com), y se verá esta pantalla:

Allí mismo, se hace clic en la pestaña "Domains", tal cuál se muestra en la imágen:

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/domain-onboarding-cloudflare.webp)

En esta nueva pestaña, aparecerá un formulario dónde se debe completar el campo "Enter an existing domain Or register a new domain" con el dominio deseado. El resto de opciones, relacionada al reconocimiento de los DNS ya registrados y limitaciones a los bots, pueden dejarse activados y por default.

Luego, se hace clic en el botón "Continue".

El paso siguiente es para seleccionar el plan "Free" o "Pro" (entre otros). Se selecciona el plan "Free", que es más que suficiente.

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/select-free-plan.webp)

Puede ocurrir un bug, que evita que se pase a la pantalla siguiente luego de elegir el plan, pero no importa porque la configuración básica ya se realizó.

Si nos situamos en el [panel de control](https://dash.cloudflare.com/), se verá el Dominio con el error "Invalid nameservers" bajo la columna "Status".

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/domain-status-invalid-nameservers.webp)

Este mensaje es común, porque aún no se realizó la delegación del dominio (mediante el cambio de nameservers). Para resolver esto, se debe leer el [siguiente paso](#nameservers-de-cloudflare-para-el-dominio-a-delegar).

# Nameservers de Cloudflare para el dominio a delegar

Estando en el [panel de control](https://dash.cloudflare.com/), se debe realizar clic en el error "Invalid nameservers" bajo la columna "Status".

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/domain-status-invalid-nameservers-recuadro.webp)

Esto redirigirá al navegador a una serie de pasos, los importantes son:

- [Tomar nota de los nameservers](#tomar-nota-de-los-nameservers).
- [Desactivar DNSSEC](#desactivar-dnssec). 

## Tomar nota de los nameservers

En la captura de abajo, en la sección que dice "Replace your current nameservers with Cloudflare nameservers", se dejan ver los nameservers que brinda Cloudflare para esta cuenta en particular.

> **Atención:** Los nameservers que se muestran a continuación pueden cambiar según la cuenta, por eso es importante dirigirse al link "Invalid nameservers", para poder ver los nameservers que corresponden para tu configuración.

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/update-nameservers-to-activate-cloudflare.webp)

Se debe tomar nota de ambos nameservers, que en el caso del tutorial son:

```
lennon.ns.cloudflare.com
sue.ns.cloudflare.com
```

Más adelante se completará un formulario con esta información.

## Desactivar DNSSEC

Es el punto 2 que se muestra en la captura del capítulo [Tomar nota de los nameservers](#tomar-nota-de-los-nameservers), y crucial para poder realizar la configuración inicial en Cloudflare. Para esto, se realizan los siguientes pasos:

1. Dirigirse al [panel de Hostinger](https://hpanel.hostinger.com/).
2. Hacer clic en el menú Dominios, o dirigirse a [este link](https://hpanel.hostinger.com/domains), y luego la opción "Portafolio de dominios".

![Ir al Portafolio de dominios]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/portafolio-de-dominios.webp)

3. Al ver el listado de dominios registrados en Hostinger, se hace clic en el botón "Administrar" del dominio deseado (en el ejemplo, sería el dominio inforce.cloud). Este botón está a la derecha del botón "Renovar".

4. En esta nueva página de Administración, aparece una barra lateral con varias opciones. Se debe elegir "DNS / Nameservers" > Pestaña "DNSSEC", o entrar a [este link](https://hpanel.hostinger.com/domain/inforce.cloud/dns?tab=dns_sec).

Si se observa este menú con un formulario pero sin ningún registro (como en la imágen a continuación), quiere decir que no está activado DNSSEC 👍

![DNSSEC está desactivado en Hostinger por defecto]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/dnssec-desactivado-por-default.webp)

## Delegar el dominio

1. Dirigirse al [panel de Hostinger](https://hpanel.hostinger.com/).
2. Hacer clic en el menú Dominios, o dirigirse a [este link](https://hpanel.hostinger.com/domains), y luego la opción "Portafolio de dominios".

![Ir al Portafolio de dominios de Hostinger]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/portafolio-de-dominios.webp)

3. Al ver el listado de dominios registrados en Hostinger, se hace clic en el botón "Administrar" del dominio deseado (en el ejemplo, sería el dominio inforce.cloud). Este botón está a la derecha del botón "Renovar".

4. En esta nueva página de Administración, aparece una barra lateral con varias opciones. Se debe elegir "DNS / Nameservers", o entrar a [este link](https://hpanel.hostinger.com/domain/inforce.cloud/dns?tab=dns_records).

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/nameservers-option.webp)

5. Acá ya se puede cliquear el botón "Cambiar Nameservers", para poder delegar el dominio a Cloudflare.

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/cambiar-nameservers-button.webp)

6. Ahora se deben colocar los dos nameservers que fueron provistos por Cloudflare en el paso "[Tomar nota de los nameservers](#tomar-nota-de-los-nameservers)", y hacer clic en el botón "Guardar".

7. Luego, se espera la confirmación.

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/confirmacion-nameservers-en-hostinger.webp)

## Comprobar cambio de nameservers en Cloudflare

Estando en el [panel de control](https://dash.cloudflare.com/), se debe realizar clic en el error "Invalid nameservers" bajo la columna "Status". Esto redirigirá al navegador a una página nueva. Al final de ella, se verá el botón "Check nameservers now".

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/check-dns-button-cloudflare.webp)

Si hacen clic muy pronto (en los primeros 5 minutos, por ejemplo), Cloudflare notifica que puede tomar hasta 24 hrs para que el cambio surta efecto. En el caso del tutorial, esto comenzó a funcionar dentro de los primeros 30 minutos. Ahora está todo perfecto para seguir con la configuración del DDNS.

# Crear y guardar API Key (token)

Dirigirse al [panel de control de Cloudflare](https://dash.cloudflare.com) y seleccionar el dominio en el que se está trabajando (en el ejemplo sería inforce.cloud). Se cargará una página nueva y, al scrollear hacía abajo, aparece lo siguiente:

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/get-your-api-token-link.webp)

Se debe hacer clic en el link "[Get your API token](https://dash.cloudflare.com/profile/api-tokens)", para generar un token seguro y darle los permisos necesarios a ddclient. Se hace clic en este botón:

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/create-token-button.webp)

En la nueva página que se carga, se debe buscar el sub-título "API token templates" y cliquear en el botón correspondiente a la opción "Edit Zone DNS".

Esto lleva a una nueva página, dónde se debe configurar el nombre del token, los permisos y zonas de la siguiente manera:

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/create-token-form.webp)

Al final de la página, se hace clic en el botón "Continue to Summary". A continuación, se revisa la configuración y se hace clic en el botón "Create token", en una pantalla que se verá así:

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/create-token-last-step.webp)

Como último paso, se debe guardar el token que muestra Cloudflare en un lugar seguro, puesto que luego de instalar **ddclient** en el contenedor Linux, se debe guardar allí.

También, si se desea probar el token con **curl**, se puede ejecutar el siguiente código:

```
curl "https://api.cloudflare.com/client/v4/user/tokens/verify" \
-H "Authorization: Bearer <código token provisto por cloudflare>"
```

Y responderá exitosamente, con un JSON similar a este:

```json
{
    "result": {
        "id":"<id oculto por motivos de seguridad>",
        "status":"active"
    },
    "success":true,
    "errors":[],
    "messages": [
        {
            "code":10000,
            "message":"This API Token is valid and active",
            "type":null
        }
    ]
}
```

# Instalar ddclient

Se procede a instalar la última versión de **ddclient** (4.0.0) desde GitHub sobre Debian 12, que ya tiene instalado **Perl**, lenguaje de programación que utiliza **ddclient** y será necesario para compilar la aplicación.

> **Atención:** Este tutorial indica como instalar la versión 4.0.0, que a día de hoy (<time datetime="2025-11-12">12 de Noviembre de 2025), es la última. Si visitás este post más avanzado en el tiempo y querés tener la última versión del programa, podés visitar la página <a href="https://github.com/ddclient/ddclient/releases">Releases</a> de <strong>ddclient</strong>. Ojalá este método de instalación y configuración explicado en el tutorial siga vigente. La misma página <a href="https://github.com/ddclient/ddclient/releases">Releases</a> suele indicar resolución de bugs y cambios en la sintáxis de configuración (si los hay, aunque realmente el archivo de configuración no suele cambiar entre versiones y por ende este tutorial debería funcionar en clientes más nuevos que salgan).

1. En la terminal de Linux, se descarga al archivo comprimido con `wget`:

```
wget https://github.com/ddclient/ddclient/releases/download/v4.0.0/ddclient-4.0.0.tar.gz
```

2. Se procede a extraer el archivo descargado:

```
tar xvfa ddclient-4.0.0.tar.gz
```

3. Se ingresa a la carpeta del programa:

```
cd ddclient-4.0.0
```

4. Se instalan dependencias de ddclient. Para ello, se escribe en la terminal **cpan** y se presiona la tecla ENTER, para entrar a la línea de comandos de Perl. Allí, se escribe y ejecuta el comando para descargar el siguiente módulo:

```
install HTTP::Daemon
```

Y también el módulo JSON, que se instala con la ejecución del siguiente comando:

```
install JSON::PP
```

Una vez realizadas estas dos instalaciones, que tardan bastante, se puede tipear el siguiente comando para salir de la interfaz **cpan**:

```
quit
```

5. Se ejecuta el archivo que realiza la configuración, para posteriormente compilar:

```
./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var
```

6. Se ejecutan estos dos comandos, que no deberían arrojar error pero si algún warning. Esto no es relevante, ya que las dependencias necesarias para que **ddclient** se ejecute para la tarea requerida están presentes:

```
make
make VERBOSE=1 check
```

7. Se procede a instalar el programa, como usuario privilegiado (root):

```
make install
```

# Configurar ddclient

Se debe editar el archivo **/etc/ddclient/ddclient.conf**, y buscar la sección de Cloudflare, que luce así:

```
##
## CloudFlare (www.cloudflare.com)
##
# protocol=cloudflare,        \
# zone=domain.tld,            \
# ttl=1,                      \
# login=your-login-email,     \
# password=APIKey             \
# domain.tld,my.domain.tld
```

Las líneas que deben editarse son:

## login=your-login-email

El parámetro `login`, en realidad, debe ser igualado a "token". Esto es así por el método nuevo que utilizaremos para conectar el cliente ddns a Cloudflare. Entonces, queda así:

```bash
login=token
```

## password=APIKey

Este parámetro requiere igualarse a la API Key que brindó Cloudflare anteriormente, tal cuál se explicó [acá](#crear-y-guardar-api-key-token). Se debe completar siguiendo esta sintáxis:

```
password=<código token provisto por cloudflare>
```

## domain.tld,my.domain.tld

Esto debe ser reemplazado completamente por el dominio que se utiliza en Cloudflare. Siguiendo con el ejemplo del tutorial, el texto "domain.tld,my.domain.tld" debe ser reemplazado por "inforce.cloud".

Para añadir varios dominios a la actualización de DNS, se debe ver el capítulo [Configurar ddclient para distintos subdominios (opcional)](#configurar-ddclient-para-distintos-subdominios-opcional).

> **Atención:** Se debe quitar el signo numeral / hashtag (#) de las líneas que contienen los parámetros *protocol*, *zone*, *ttl*, *login*, *password* y *domain.tld,my.domain.tld* (que se reemplazó con el dominio que se utiliza en Cloudflare). De esta forma, el cliente **ddclient** interpretará la nueva configuración.

## Error "unable to determine IP address"

Este error es común en la configuración propuesta por el tutorial, porque la implementación se hizo en un contenedor LXC, no en el propio router que tiene acceso a la IP pública. Para subsanar este problema, se añade el parámetro *use* y *web*, por encima de la configuración de cloudflare, quedando así:

```bash
use=web
web=https://api.ipify.org/

##
## CloudFlare (www.cloudflare.com)
##
protocol=cloudflare, \
zone=inforce.cloud, \
ttl=1, \
login=token, \
password=<api token provista por cloudflare> \
inforce.cloud
```

La incorporación de *use=web* y el parámetro *web*, indica que se debe obtener la IP de un proveedor externo. Esto soluciona el error "unable to determine IP address".

# Configurar ddclient para distintos subdominios (opcional)

Si se desean montar varios subdominios, la configuración es copiar y pegar, sólo que cambia la última línea.

Ejemplo para el subdominio test.inforce.cloud:

```bash
use=web
web=https://api.ipify.org/

##
## CloudFlare (www.cloudflare.com)
##
protocol=cloudflare, \
zone=inforce.cloud, \
ttl=1, \
login=token, \
password=<api token provista por cloudflare> \
inforce.cloud

protocol=cloudflare, \
zone=inforce.cloud, \
ttl=1, \
login=token, \
password=<api token provista por cloudflare> \
test.inforce.cloud
```

# Crear servicio systemd

Debian utiliza systemd como init, es por eso que se debe crear y editar el archivo correspondiente:

```bash
nano /etc/systemd/system/ddclient.service
```

Dentro, se pega este contenido:

```bash
[Unit]
Description=Dynamic DNS Update Client
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=ddclient -foreground -file /etc/ddclient/ddclient.conf
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```

Se habilita el servicio:

```bash
systemctl enable ddclient
```

Y se inicia:

```bash
systemctl start ddclient
```

# Comprobación

1. Abrir con el navegador web el link [https://api.ipify.org/](https://api.ipify.org/).
2. Anotar la dirección IP (es la pública de nuestra red).
3. En [dash.cloudflare.com](https://dash.cloudflare.com/), hacer clic en el dominio que se está configurando (ejemplo: inforce.cloud).
4. Hacer clic en la opción "DNS Records":

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/link-dns-records.webp)

5. En esta página, observar el registro tipo A. Debe coincidir con la IP anunciada en [https://api.ipify.org/](https://api.ipify.org/). Se esconde la IP que figura en la captura para más privacidad, digamos...

> **Atención:** La IP es visible mediante un `dnslookup`, Cloudflare no la va a enmascarar.

![alt text]({{ base.url }}/assets/posts/configurar-un-dominio-ddns-con-cloudflare-gratis/comprobacion-ip-actualizada.webp)

Habiendo comprobado esto, ya está todo correctamente configurado.

# Epílogo

A partir de ahora se podrán montar (en el dominio configurado) sitios web, servicios VPN y más. El como instalarlos, serán tutoriales que se lanzarán en el futuro 😀🥳

¡Nos vemos!