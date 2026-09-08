---
title: "Generar credenciales y certificados SSL • ARCA AFIP"
description: "En esta guía se enseña como conseguir los accesos y delegaciones necesarias para poder programar en ambientes de desarrollo y producción, utilizando los WebServices de ARCA."
image: "/assets/posts/generar-credenciales-y-certificados-en-arca-afip/portada.webp"
date:   2025-12-1 09:00:00 -0300
layout: post
categories: [programacion]
---

Fuente: https://docs.afipsdk.com/recursos/tutoriales-pagina-de-arca/habilitar-administrador-de-certificados-de-testing

# Preámbulo

Texto.

# Instalar OpenSSL

Texto.

# Añadir OpenSSL a variables de entorno

Texto. Se puede sugerir un post viejo que indica como añadir cualquier cosa al PATH.

# Activar el Administrador de relaciones

Fuente: https://docs.afipsdk.com/recursos/tutoriales-pagina-de-arca/habilitar-administrador-de-certificados-de-produccion

# Delegación de servicio

{% include youtube.html videoUrl="https://www.youtube.com/embed/lpSz6DkAb38?si=WJrKNQ3N1Hw5l7i2" %}

# Generar clave privada

```bash
openssl genpkey -algorithm RSA -out priv.key -pkeyopt rsa_keygen_bits:2048
```

# Crear archivo de configuración

Se debe crear el archivo **

NOTA: debo crear un programa web que auto-configure esto 👇

```
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = v3_req

[ dn ]
C  = AR
O  = Nombre de la empresa
CN = Nombre del certificado (puede ser nombre de la app back-end)
serialNumber = CUIT xx-xxxxxxxx-x

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = inforce.cloud
DNS.2 = www.inforce.cloud
```

# Generar solicitud

```bash
openssl req -new -key priv.key -out solicitud.csr -config openssl_cuit.cnf
```

# Visualizar solicitud para copiarlo en ARCA

```bash
cat solicitud.csr
```