---
layout: post
title:  "Instalar un dominio en Cloudflare • Hostinger"
description: "Cloudflare ofrece muchos servicios gratuitos, ideales para quién quiere llevar sitios web a la nube, sin requerir ni exponer su IP pública."
image: "/assets/posts/instalar-un-dominio-en-cloudflare/portada.webp"
date:   2025-02-23 23:30:02 -0300
categories: [homelabing]
tags: cloudflare, hostinger, dominio, dns, apuntar, apuntado
---

# Preámbulo

Cloudflare ofrece servicios que evitan ataques DDoS, te brindan un CDN que cachea contenido estático y [gracias a **cloudflared** se pueden llevar sitios web de tu PC a la nube, sin requerir IP pública]({% post_url openwrt/2025-02-18-instalar-cloudflared-en-openwrt %}). En este tutorial se enseñará a utilizar un dominio registrado en Hostinger con Cloudflare, aunque si el "Registrar" (dónde fue comprado el dominio) no es Hostinger, el procedimiento que enseña el tutorial no es difícil y puede ser interpretado para realizarlo en DreamHost, DonWeb y más.

El procedimiento del Registrar es sencillo, sólo se debe averiguar dónde editar los apuntados DNS.

El tutorial asume que el dominio ya fue adquirido y la cuenta en Cloudflare ya fue creada.

# 1. Ingresar al Panel de Cloudflare

Hay que dirigirse al [panel de control de Cloudflare](https://dash.cloudflare.com/), e iniciar sesión. Allí, se debe realizar clic en "Add a domain".

![Añadir un dominio]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/1-add-domain.webp)

# 2. Anotar el dominio a vincular

El botón "Add a domain" llevará a la siguiente página, dónde se debe escribir el dominio sin http/https. Luego de haberlo escrito y verificado, se prosigue con el botón "Continue" para poder seguir con la elección del plan.

![Escribir dominio]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/2-write-domain.webp)

# 3. Seleccionar un plan gratuito

Este plan será suficiente para tener un servicio correcto, y es el elegido en el tutorial. Para seleccionarlo, se hace clic en el título "Free", en la sección inferior de la página. Luego se debe presionar el botón "Continue".

![Seleccionar plan gratuito]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/3-select-free-plan.webp)

# 4. Revisar los DNS

En esta nueva página, Cloudflare notifica que pudo haber omitido subdominios y registros DNS, en especial los relacionados al email.

![Revisar DNS añadidos]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/4-review-dns-1.webp)

En este tutorial no se utilizarán MX ni DMARC, pero son vitales para tener una casilla de email funcional y de buena reputación, es decir, que no caiga en SPAM fácilmente. DeSistemas intentará hacer un tutorial sobre el tema de los correos lo antes posible.

A continuación se indican que dominios deberán eliminarse, porque sino no podrá utilizarse el dominio **inforce.cloud** con un servidor propio en el futuro.

![Revisar DNS añadidos]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/4-review-dns-2.webp)

# 5. Tomar nota de los nameservers de Cloudflare

A continuación, Cloudflare indica los nameservers que se deben utilizar el la "Zona DNS" del dominio registrado en Hostinger. Se debe tomar nota de estos DNS, pronto se colocarán en Hostinger.

> Es importante que tomes nota de tus DNS y no de los míos, porque es posible que Cloudflare tenga otra URL en tu caso, y no te funcione con los de la foto.

![Anotar los dos nameservers de Cloudflare]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/5-take-note-of-those-nameservers.webp)

# 6. Dirigirse al portafolio de dominios

Para quitar los nameservers viejos y colocar los de Cloudflare para terminar con la conexión, dirigirse al [hpanel](https://hpanel.hostinger.com/) > Dominios > Portafolio de dominios.

![Portafolio de dominios]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/6-domain-portfolio.webp)

# 7. Administrar dominio

Para poder editar los DNS al cuál apunta este dominio, se debe realizar clic en "Administrar", en el dominio **inforce.cloud**.

![Administrar dominio]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/7-admin-domain.webp)

# 8. Botón de edición de DNS

En el panel administrativo del dominio, se aprecia el link "Editar" en el título "DNS/Nameservers". Hay que hacerle clic.

![Editar DNS en Hostinger]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/8-edit-dns-button.webp)

Ésto lanzará una ventana, a la cuál se cliquea en el botón "Cambiar nameservers".

![Aceptar la ventana emergente sobre si realmente se desean cambiar los DNS]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/9-change-name-servers-button.webp)

# 9. Editar los DNS en el formulario

Finalmente, se borran las URLs que están por defecto y se completan con los que proporcionó Cloudflare en el punto 5.

En el caso del tutorial, se completaron así:

![DNS de Cloudflares en formulario de Hostinger]({{ base.url }}/assets/posts/instalar-un-dominio-en-cloudflare/10-change-nameservers.webp)

1. Se cliquea la opción "Cambiar nameservers".
2. En el primer campo de texto, se colocó el primer DNS proporcionado por Cloudflare.
3. En el segundo campo, el segundo DNS de Cloudflare.
4. Los otros nameservers pueden quedar vacíos, y se cliquea en el botón "Guardar".

# 10. Comprobar los cambios

Tardará unos pocos minutos para que el dominio vinculado a Cloudflare esté disponible.

> ATENCIÓN: Para que el Registrar actualice el cambio de DNS pueden pasar hasta 48hrs, aunque en estos últimos años es cuetión de minutos. Si pasan más de 4hrs y el dominio no reacciona con los siguientes comandos, lo más probable es que debas revisar tu configuración.

Para comprobar que el dominio esté apuntando correctamente, se puede ejecutar:

## En Linux

Abrir una terminal y sin necesidad de super-usuario, ejecutar:

```bash
host -t SOA inforce.cloud
```

El comando ***host*** devuelve un servidor DNS de Cloudflare, como se ve en la siguiente salida:

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

> Podría darse el caso dónde el apuntado es correcto, pero la información aún tarda en llegar a tu equipo. En el peor de los casos, 4 horas.

En breve se enseñarán varias herramientas para revisar el estado de la dispersión de DNS, hasta entonces, ¡nos vemos!