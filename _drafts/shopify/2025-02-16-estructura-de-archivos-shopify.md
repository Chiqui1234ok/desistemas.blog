---
layout: post
title:  "Estructura de archivos • Shopify"
date:   2024-01-28 19:00:01 +0000
tags: guía, tutorial, shopify, liquid, html, css, js
---

# Preámbulo


Probablemente el lector tenga un fuerte background en front-end y quiera asomarse para aplicar sus conocimientos en Shopify, con el objetivo de obtener un mejor trabajo, desarrollar plantillas para vender, o ambas.

Es en el momento en el que arma su entorno de desarrollo y realiza `shopify theme init` y `shopify theme dev --store <url de su tienda>`, cuándo las cosas se complican. Se aprecian muchos archivos en formato ***json*** y ***liquid***. Bueno, toca acostumbrarse a su sintáxis porque son los mejores amigos en el desarrollo de una tienda Shopify. Shopify también tiene un editor de template que es perfectamente compatible con estos archivos, lo cuál garantiza que el template en desarrollo tendrá una mejor mantenibilidad porque permitirá cambiar cosas "on the fly", una vez esté terminado.

Instala el plugin en VSCode "Shopify Liquid", y comencemos.

# Las páginas

Las páginas del sitio shopify están ubicadas en **./templates/**, y contienen los archivos correspondientes a cada página. Dando un ejemplo:

1. Abrir el archivo **./templates/index.json**.
2. Observar el código, por ejemplo, entre la línea 3 y 48 se encuentra la primer sección que se verá al abrir el sitio: 

![Image banner de la página principal]({{ base_url }}/assets/posts/estructura-de-archivos-shopify/image-banner.png)

A continuación, se muestra un pequeño extracto:

```json
{
  "sections": {
    "image_banner": {
      "type": "image-banner",
      "blocks": {
        "heading": {
          "type": "heading",
          "settings": {
            "heading": "Image banner",
            "heading_size": "h0"
          }
        },
```

3. Se ve que la estructura de la página principal está dentro del objeto "sections". Los objetos "image_banner", "featured_collection", "collage", etc (todos son hijos de "sections"); están en el mismo órden tanto en el archivo **json** como en la página web.
4. Dentro de "image_banner" se ve la clave "type" con el valor "image-banner". Ésto no está al azar, puesto que esa línea está diciendo que se utiliza la sección **./sections/image-banner.liquid**.

# Las secciones

Para los que no saben nada de Liquid, la primer línea del archivo **./sections/image-banner.liquid** ya tiene una mística en su primer línea:

```liquid
{{ 'section-image-banner.css' | asset_url | stylesheet_tag }}
```

La línea mostrada es una sintaxis de Liquid, un lenguaje de plantillas utilizado en Shopify y otros sistemas de gestión de contenido.

Esto merece una explicación:

1. `'section-image-banner.css'`: Este es el nombre del archivo CSS que se desea incluir.

2. `|`: Este es un operador de tubería en Liquid que se utiliza para encadenar filtros. Los filtros modifican el valor de la expresión a la izquierda del operador de tubería.

3. `asset_url`: Este es un filtro de Liquid que toma el nombre de un archivo y devuelve la URL completa del archivo en el servidor.

4. `stylesheet_tag`: Este es otro filtro de Liquid que toma una URL de un archivo CSS y devuelve una etiqueta `<link>` HTML que se puede insertar en el `<head>` de un documento HTML para incluir el archivo CSS.

Esta línea con sus dos filtros genera una etiqueta `<link>` HTML que apunta al archivo **./assets/section-image-banner.css** en el servidor, permitiendo que el archivo CSS se incluya en la página web.

## Schema

En la línea 169 comienza el esquema de la sección:

```liquid
...
```

A partir de acá, se escribe en código json. El objetivo de ésto es que el administrador de la tienda pueda realizar cambios rápidos del template, sin necesidad de tener que escribir código. Esos cambios se reflejarán en el código del esquema.

# Assets

Esta parte comienza a gustar más porque ya incluye archivos CSS y Javascript.