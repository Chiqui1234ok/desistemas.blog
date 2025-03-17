---
layout: post
title:  "Exponer servicios en la nube con Public hostnames • Cloudflare"
date:   2025-03-02 00:30:02 +0300
tags: cloudflare, cloudflared, public hostnames, exponer servicios, servicios en la nube, homelab en la nube
---

# Preámbulo

Este post es la continuación de dos anteriores:

1) [Instalar un dominio en Cloudflare]({% post_url cloudflare/2025-02-23-instalar-un-dominio-en-cloudflare %}).

2) [Instalar Cloudflared en OpenWRT]({% post_url openwrt/2025-02-18-instalar-cloudflared-en-openwrt %}).

Mediante el contenido que se linkea arriba, es posible registrar un dominio en un *Registrar* veloz como lo es Hostinger, incluirlo en un plan gratuito de Cloudflare y configurar un túnel entre nuestra red y Cloudflare. El objetivo de esto es poder exponer servicios que están en una intranet hacia internet, accesible mediante un dominio desde cualquier lugar en el mundo y aprovechando el SSL/TLS provisto en Cloudflare.

De esta forma se pueden publicar servicios online sin exponer la IP y puertos de la red.

# Funcionamiento de un Public Hostname

Este formulario debe observarse para entender bien lo que se está a punto de hacer:

![Formulario public hostnames]({{ base.url }}/assets/posts/exponer-servicios-en-la-nube-con-public-hostnames/formulario-public-hostnames.png)

Tiene cuatro campos clave:

1) Subdomain: este campo es opcional, pero si el servicio no se trata del sitio web o app principal que reside en la raíz del dominio (en este caso, "inforce.cloud"), será necesario especificar un subdominio.

2) Domain: Cloudflare listará todos los dominios presentes, pero debe coincidir con el túnel que fue previamente seleccionado

Y en la sección **SERVICE**:

3) Type: El protocolo/socket por el cuál este servicio interactúa. Las opciones son: HTTP, HTTPS, UNIX, TCP, SSH, RDP, UNIX+TLS, SMB, HTTP_STATUS, BASTION.
Es importante mencionar que esta opción se refiere al protocolo de la aplicación que se quiere exponer, no del resultante en Cloudflare. Por ejemplo, es muy común que proyectos localhost no tengan un certificado válido, y en dicho caso se deberá indicar "HTTP". Cloudflare ofrece su propio certificado de forma automática.

4) URL: La dirección IP dentro de la red. En caso de que el puerto del servicio no sea el que está por defecto para el protocolo antes indicado, se debe escribir junto a la IP con la siguiente sintáxis:

```js
<IP>:<PUERTO>`
```

# Crear un public hostname

Se debe ir a [Cloudflare Zero Trust](https://one.dash.cloudflare.com/) > Seleccionar cuenta. Se cargará el panel de Cloudflare, y allí se selecciona desde la barra lateral: Networks > Tunnels y se elije el túnel "Inforce" de la tabla.
Esta acción mostrará una barra lateral con el botón "Edit" al cuál se le hace clic.

![El botón "Edit" se sitúa en la zona superior de la barra lateral]({{ base.url }}/assets/posts/exponer-servicios-en-la-nube-con-public-hostnames/edit-tunnel.png)

Aquél botón llevará a la configuración del túnel "Inforce", dónde en este caso ya se listan dos URLs porque previamente el autor del post creó dos Public hostnames. Se ve claramente como cada dirección apunta a una IP y puerto, en el caso del primer registro. Esto es porque el protocolo HTTP tiene un puerto por defecto en el número 80. El número 8080 es otro, por ende se debe especificar.

La sección para añadir este tipo de registros se encuentra en la pestaña **PUBLIC HOSTNAMES**.

![alt text]({{ base.url }}/assets/posts/exponer-servicios-en-la-nube-con-public-hostnames/seccion-public-hostnames.png)

En la página que aparecerá a continuación, se pueden añadir los dominios como se explicó en el título "Funcionamiento de un Public Hostname".

## Forzar la exposición de un servicio en el dominio raíz inforce.cloud

Al añadir el dominio de forma automática como se explicó en el post "[Instalar un dominio en Cloudflare]({% post_url cloudflare/2025-02-23-instalar-un-dominio-en-cloudflare %})", puede suceder que la URL principal quede "reservada" a una IP, y no permita añadir un public hostname a la URL [inforce.cloud](inforce.cloud) .

Para resolver ésto, se debe ir a [Cloudflare](https://dash.cloudflare.com) > inforce.cloud. Esto cargará una página específica para el dominio, y en la barra lateral se verá la opción **DNS**, a la que se hará un clic para ir automáticamente a la página "Records".
Puede suceder que la tabla tenga un registro de tipo "A" (columna "Type") e inforce.cloud esté apuntando a una IP. En caso de ver algo así, debe eliminarse.

Esto ya se mencionó en el post original de "[Instalar un dominio en Cloudflare]({% post_url cloudflare/2025-02-23-instalar-un-dominio-en-cloudflare %})", pero vale la pena volver a mencionarlo.

# Epílogo

En 3 posts cortos, el administrador de sistemas ahora sabe como tener servicios de casa en internet, incluso si tiene limitaciones en el router del ISP.