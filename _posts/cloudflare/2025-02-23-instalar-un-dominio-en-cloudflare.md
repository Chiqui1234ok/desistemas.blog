---
layout: post
title:  "Instalar un dominio en Cloudflare • Hostinger"
date:   2025-02-23 23:30:02 +0300
tags: cloudflare, hostinger, dominio, dns, apuntar, apuntado
---

# Preámbulo

Cloudflare es un servicio que evita ataques DDoS, sirve como CDN, cachea contenido estático y más. En este tutorial se enseñará a utilizar un dominio registrado en Hostinger con Cloudflare, aunque si se lo compraste a otra empresa distinta de Hostinger, lo que se hará no es difícil: sólo se debe averiguar dónde editar los apuntados DNS.

El tutorial asume que el dominio ya fue adquirido y tenés cuenta en Cloudflare.

# 1. Ingresar al Panel de Cloudflare

Hay que dirigirse al [panel de control de Cloudflare](https://dash.cloudflare.com/), e iniciar sesión. Allí, se debe realizar clic en "Add a domain".

![Añadir un dominio]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/1-add-domain.png)

# 2. Anotar el dominio a vincular

El botón "Add a domain" llevará a la siguiente página, dónde se debe escribir el dominio sin http/https. Luego de haberlo escrito y verificado, se prosigue con el botón "Continue" para poder seguir con la elección del plan.

![Escribir dominio]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/2-write-domain.png)

# 3. Seleccionar un plan gratuito

Este plan será suficiente para tener un servicio correcto, y es el elegido en el tutorial. Para seleccionarlo, se hace clic en el título "Free", en la sección inferior de la página. Luego se debe presionar el botón "Continue".

![Seleccionar plan gratuito]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/3-select-free-plan.png)

# 4. Revisar los DNS

En esta nueva página, Cloudflare notifica que pudo haber omitido subdominios y registros DNS, en especial los relacionados al email.

![Revisar DNS añadidos]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/4-review-dns-1.PNG)

En este tutorial no se utilizarán MX ni DMARC, pero son vitales para tener una casilla de email funcional y de buena reputación, es decir, que no caiga en SPAM fácilmente. DeSistemas intentará hacer un tutorial sobre el tema de los correos lo antes posible.

A continuación se indican que dominios deberán eliminarse, porque sino no podrá utilizarse el dominio **inforce.cloud** con un servidor propio en el futuro.

![Revisar DNS añadidos]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/4-review-dns-2.PNG)

# 5. Tomar nota de los nameservers de Cloudflare

A continuación, Cloudflare indica los nameservers que se deben utilizar el la "Zona DNS" del dominio registrado en Hostinger. Se debe tomar nota de estos DNS, pronto se colocarán en Hostinger.

> Es importante que tomes nota de tus DNS y no de los míos, porque es posible que Cloudflare tenga otra URL en tu caso, y no te funcione con los de la foto.

![Anotar los dos nameservers de Cloudflare]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/5-take-note-of-those-nameservers.png)

# 6. Dirigirse al portafolio de dominios

Para quitar los nameservers viejos y colocar los de Cloudflare para terminar con la conexión, dirigirse al [hpanel](https://hpanel.hostinger.com/) > Dominios > Portafolio de dominios.

![Portafolio de dominios]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/6-domain-portfolio.png)

# 7. Administrar dominio

Para poder editar los DNS al cuál apunta este dominio, se debe realizar clic en "Administrar", en el dominio **inforce.cloud**.

![Administrar dominio]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/7-admin-domain.png)

# 8. Botón de edición de DNS

En el panel administrativo del dominio, se aprecia el link "Editar" en el título "DNS/Nameservers". Hay que hacerle clic.

![Editar DNS en Hostinger]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/8-edit-dns-button.png)

Ésto lanzará una ventana, a la cuál se cliquea en el botón "Cambiar nameservers".

![Aceptar la ventana emergente sobre si realmente se desean cambiar los DNS]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/9-change-name-servers-button.png)

# 9. Editar los DNS en el formulario

Finalmente, se borran las URLs que están por defecto y se completan con los que proporcionó Cloudflare en el punto 5.

En el caso del tutorial, se completaron así:

![DNS de Cloudflares en formulario de Hostinger]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/10-change-nameservers.png)

1. Se cliquea la opción "Cambiar nameservers".
2. En el primer campo de texto, se colocó el primer DNS proporcionado por Cloudflare.
3. En el segundo campo, el segundo DNS de Cloudflare.
4. Los otros nameservers pueden quedar vacíos, y se cliquea en el botón "Guardar".

# 10. Comprobar los cambios

Tardará unos pocos minutos para que el dominio vinculado a Cloudflare esté disponible. Para comprobar que el dominio esté apuntando correctamente, se puede ejecutar:

## En Linux

Abrir una terminal y sin necesidad de super-usuario, ejecutar:

```bash
host -t SOA inforce.cloud
```

Devuelve un servidor DNS de Cloudflare, con su conocida IP 8.8.8.8:

```bash
inforce.cloud has SOA record lennon.ns.cloudflare.com. dns.cloudflare.com. 2365636038 10000 2400 604800 1800
```

## En Windows

Ejecutar el siguiente comando en una ventana de PowerShell:

```powershell
Resolve-DnsName inforce.cloud
```

Devuelve el servidor primario y secundario de Cloudflare: 

```powershell
Name                        Type TTL   Section    PrimaryServer               NameAdministrator           SerialNumber
----                        ---- ---   -------    -------------               -----------------           ------------
inforce.cloud               SOA  1423  Authority  lennon.ns.cloudflare.com    dns.cloudflare.com          2365636038
```

> Podría darse el caso dónde el apuntado es correcto, pero la información aún tarda en llegar a tu equipo. En el peor de los casos, 6 horas.

En breve se enseñará como conectar un dispositivo de una red hogareña a Cloudflare, para poder hostear servicios propios y no tener que gastar en un servidor web.

¡Éxitos! Nos vemos.