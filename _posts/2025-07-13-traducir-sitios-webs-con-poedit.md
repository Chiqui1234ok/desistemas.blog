---
layout: post
title:  "Realizar traducciones de aplicaciones y webs • Poedit"
date:   2025-07-13 17:30:00 -0300
categories: [programacion]
tags: gettext, poedit, traducir wordpress, traducir, traducciones, ingles, español, wordpress, traducción, po, mo, pot, desarrollo
---

# Preámbulo

Existe una forma fácil y portable de traducir aplicaciones de escritorio y web. Este tutorial enseñará, mediante el software ***gettext*** y ***poedit***, a crear una plantilla para traducir a todos los idiomas deseados.

Comencemos.

# Instalar *gettext*

Esta herramienta es ideal para crear un archivo POT automáticamente. Nos ahorrará mucho tiempo, si le indicamos bien cómo buscar en el código.

## Instalar *gettext* en Linux

```
apt update && apt install gettext -y
```

## Instalar *gettext* en Windows

### 1. Descargar

Se puede descargar e instalar desde [este link](https://mlocati.github.io/articles/gettext-iconv-windows.html).

Se debe descargar la opción x64 "static", para asegurarse de que no falta ninguna biblioteca (DLL).

![alt text]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/descargar-gettext-static-para-windows.webp)

Al terminar de descargar el archivo comprimido, se debe hacer clic derecho > Extraer todo... , y luego se presiona el botón "Extraer".

![alt text]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/extraer-gettext.webp)

> En el caso del tutorial, se extrae en **\\10.0.0.2\home\sgimenez\Downloads\gettext0.24-iconv1.17-static-64**, y se utilizará esta ruta para los ejemplos.

### Añadir al PATH

Se debe añadir **\\10.0.0.2\home\sgimenez\Downloads\gettext0.24-iconv1.17-static-64** al PATH, para poder ejecutar ***xgettext*** desde la consola y sin tener que indicarle dónde está el ejecutable.

> ¿No sabés cómo añadir al PATH en Windows? Seguí [este tutorial]({% post_url 2025-07-13-como-ejecutar-un-programa-desde-cmd-anadiendo-al-path %}).

# Instalar *poedit*

La instalación de este programa es muy sencilla. Como casi cualquier instalación de Windows, se descarga el ejecutable y se le da a "Siguiente".

1. Descargar desde la [página oficial](https://poedit.net/download).

![Botón de descarga de Poedit para Windows 10 y superiores]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/descargar-poedit.webp)

2. Abrir el archivo ejecutable

3. Autorizar la apertura del archivo, haciendo clic en el botón "Ejecutar":

![Autorización del instalador]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/captura-de-autorizacion-de-instalador.webp)

4. Aceptar el acuerdo de licencia en el primer paso del instalador

![Aceptar el acuerdo de licencia]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/aceptar-el-acuerdo-de-licencia.webp)

5. Instalar y esperar.

![Instalar poedit]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/instalar-poedit.webp)

6. Al terminar la instalación, apretar el botón "Finalizar". Esto abrirá el programa.

7. Por ahora, minimizamos el programa. ¡Lo usaremos en breve! 🥳

# Crear el archivo POT con *gettext*

Este archivo contiene todas las cadenas de texto que se deben traducir.

## 1. Tomar las referencias

Por ejemplo, en una plantilla Wordpress se observan líneas de código PHP como la siguiente:

```php
_e('Texto de bienvenida • Sidebar • Sección principal', 'dominio');
```

Ó también:

```php
__('Texto de bienvenida • Sidebar • Sección principal', 'dominio');
```

Ambas funciones hacen lo mismo, a excepción que "_e" toma la traducción de "Texto de bienvenida • Sidebar • Sección principal" y también la imprime en pantalla con el comando "echo" de PHP, ahorrándose tener que hacer:

```php
echo __('Texto de bienvenida • Sidebar • Sección principal', 'dominio');
```

## 2. Preparar la carpeta de traducciones

Entonces, se concluye que cualquier línea que tenga "_e" o "__", es un texto para traducir. Antes de ejecutar ***gettext***, se deben realizar unas preparaciones.

Se debe crear una carpeta en el proyecto a traducir. En el caso del ejemplo, se debe traducir la plantilla en la ruta relativa **wp-content/themes/singerman-makon**. Por ende, se realiza un ***cd*** allí:

```bash
cd wp-content/themes/singerman-makon
```

Una vez con la terminal situada en dicha carpeta del theme, se crea el directorio que contendrá las traducciones:

```bash
mkdir languages
```

## 3. Crear el archivo POT

Una vez hecho los preparativos, se creará el archivo POT con ***gettext***, indicándole el lenguaje de programación, las keywords/referencias que ya se expusieron en el post (**_e** y **__**), el encoding (UTF-8), el archivo de salida y el comando ***find***, para poder crear las traducciones a partir de la búsqueda de todos los archivos con extensión PHP.

Con todo esto tomado en cuenta, se ejecuta:

```
xgettext --language=PHP \
  --keyword=__ \
  --keyword=_e \
  --from-code=UTF-8 \
  --output=languages/singerman-makon.pot \
  $(find . -name "*.php")
```

Este comando generará rápidamente algo como lo siguiente:

```
# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
#, fuzzy
msgid ""
msgstr ""
"Project-Id-Version: PACKAGE VERSION\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: 2025-04-16 21:22-0300\n"
"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
"Language-Team: LANGUAGE <LL@li.org>\n"
"Language: \n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"

#: vendor/index/fx/3-customers/customers.php:5
msgid "Cliente Full 1"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:6
msgid "Cliente Full 2"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:7
msgid "Cliente Full 3"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:8
msgid "Cliente Full 4"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:57
msgid "Cliente Min 1"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:58
msgid "Cliente Min 2"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:59
msgid "Cliente Min 3"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:60
msgid "Cliente Min 4"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:61
msgid "Cliente Min 5"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:62
msgid "Cliente Min 6"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:63
msgid "Cliente Min 7"
msgstr ""

#: vendor/index/fx/3-customers/customers.php:64
msgid "Cliente Min 8"
msgstr ""

#: vendor/index/fx/3-customers/wallpapers.php:4
#: vendor/index/fx/1-who-we-are/wallpapers.php:4
msgid "Fondo (vertical)"
msgstr ""

#: vendor/index/fx/3-customers/wallpapers.php:5
#: vendor/index/fx/1-who-we-are/wallpapers.php:5
msgid "Fondo (horizontal)"
msgstr ""

#: vendor/index/fx/2-services/buttons.php:4
msgid "Pie de página • Botón izq"
msgstr ""

#: vendor/index/fx/2-services/buttons.php:5
msgid "Pie de página • Botón der"
msgstr ""

#: vendor/index/fx/2-services/header.php:10
msgid "Título de Servicios"
msgstr ""

#: vendor/index/fx/2-services/header.php:22
msgid "Subtítulo de Servicios"
msgstr ""

#: vendor/index/fx/2-services/cards.php:4
msgid "Servicio 1"
msgstr ""

#: vendor/index/fx/2-services/cards.php:5
msgid "Servicio 2"
msgstr ""

#: vendor/index/fx/2-services/cards.php:6
msgid "Servicio 3"
msgstr ""

#: vendor/index/fx/2-services/cards.php:7
msgid "Servicio 4"
msgstr ""

#: vendor/index/fx/2-services/cards.php:8
msgid "Servicio 5"
msgstr ""

#: vendor/index/fx/2-services/cards.php:9
msgid "Servicio 6"
msgstr ""

#: vendor/index/fx/1-who-we-are/sidebar.php:9
msgid "Sidebar • Texto de presentación"
msgstr ""

#: vendor/index/fx/1-who-we-are/buttons.php:4
msgid "Sidebar • Botón"
msgstr ""

#: vendor/index/fx/1-who-we-are/buttons.php:5
msgid "Sección • Botón"
msgstr ""

#: vendor/index/fx/1-who-we-are/industry-leaders.php:4
msgid "Referentes • Izquierda"
msgstr ""

#: vendor/index/fx/1-who-we-are/industry-leaders.php:5
msgid "Referentes • Centro"
msgstr ""

#: vendor/index/fx/1-who-we-are/industry-leaders.php:6
msgid "Referentes • Derecha"
msgstr ""

#: vendor/index/sections/4-contact/section.php:5
msgid "¿Nuestro perfil te interesa?"
msgstr ""

#: vendor/index/sections/4-contact/section.php:8
msgid "Conversemos"
msgstr ""

#: vendor/index/sections/3-customers/section.php:16
msgid "Opiniones de nuestros clientes"
msgstr ""

#: vendor/index/sections/3-customers/section.php:19
msgid ""
"Hacemos posible sus proyectos, los mantenemos conectados y asesorados para "
"tomar las mejores decisiones."
msgstr ""

#: vendor/index/sections/1-who-we-are/section.php:12
msgid "inicio"
msgstr ""

#: vendor/index/sections/1-who-we-are/section.php:21
msgid "Leer más"
msgstr ""

#: vendor/index/sections/1-who-we-are/section.php:34 header.php:44
msgid "Servicios"
msgstr ""

#: vendor/index/sections/1-who-we-are/section.php:53
msgid "Trabajamos con los referentes del sector"
msgstr ""

#: vendor/index/sections/2-services/section.php:1
msgid "servicios"
msgstr ""

#: functions.php:53
msgid "Marca"
msgstr ""

#: functions.php:61
msgid "Isotipo"
msgstr ""

#: functions.php:72
msgid "Nombre de la marca"
msgstr ""

#: functions.php:83
msgid "Slogan"
msgstr ""

#: functions.php:94
msgid "Página principal • Sección Principal"
msgstr ""

#: functions.php:109
msgid "Página principal • Sección Servicios"
msgstr ""

#: functions.php:122
msgid "Página principal • Sección Clientes"
msgstr ""

#: header.php:39
msgid "Nosotros"
msgstr ""

#: header.php:49
msgid "Clientes"
msgstr ""

#: header.php:54
msgid "Contacto"
msgstr ""

#: header.php:59
msgid "ES"
msgstr ""
```

La cabecera debe adaptarse a los datos del traductor y el idioma base, por ende, puede editarse así:

```
# Traducción al español Argentino.
# Copyright (C) 2025 Santiago Gimenez
# This file is distributed under the same license as the PACKAGE package.
# Santiago Gimenez <santiagogimenez@xxx.com>, 2025.
#
msgid ""
msgstr ""
"Project-Id-Version: PACKAGE VERSION\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: 2025-04-16 21:22-0300\n"
"PO-Revision-Date: 2025-04-16 21:22-0300\n"
"Last-Translator: Santiago Gimenez <santiagogimenez@xxx.com>\n"
"Language-Team: Español (Argentina) <es@li.org>\n"
"Language: es_AR\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
```

# Abrir el archivo .pot

Ahora, con ***Poedit*** se procede a abrir la plantilla **.pot** y empezar a traducir.

![alt text]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/importar-plantilla-poedit.webp)

Como primer medida, ***Poedit*** pregunta sobre el idioma al que desea traducirse. En el caso del ejemplo se utilizó Español (Argentina) como base, pero se quiere traducir a Inglés (Estados Unidos), por ende:

![alt text]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/poedit-seleccion-de-idioma.webp)

> ¡Ojo! El archivo .pot no se toma como una traducción. Por ende, si querés tener traducción al mismo idioma del archivo **.pot**, deberás re-abrir el archivo **.pot**, elegir idioma "Español (Argentina)" y luego guardarlo como **es_AR.po**.

Al responder y aceptar, se mostrará la aplicación sin más ventanas emergentes. Podés probar las traducciones automáticas desde este botón:

![alt text]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/poedit-traducciones-automaticas.webp)

Pero, lamentablemente, la aplicación debe aprender (o eso menciona) sobre nuestras propias traducciones. Al menos en la versión gratuita.

![alt text]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/poedit-no-puede-traducir-automaticamente.webp)

# Comienza la traducción

La aplicación es súmamente sencilla. En la parte inferior, mostrará el texto original y luego otro campo para colocar la traducción. Yo ya traducí del español al inglés:

![Así podemos comenzar con la traducción]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/comienza-la-traduccion.webp)

# Guardar la traducción

Desde este botón se podrá guardar la traducción en formato **.po**.

![Guardar traducción en formato .po]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/poedit-guardar-traduccion.webp)

# Compilar a formato .mo

El formato **.mo** es utilizado, por ejemplo, por templates Wordpress. En síntesis, el archivo **.po** es utilizado para desarrollar las traducciones, mientras que **.mo** es el archivo que utilizará el programa para el cuál estamos creando la traducción (en este caso, Wordpress).
***Poedit*** automáticamente compila en formato **.mo** al guardar el **.po**. En caso de que eso no haya sucedido, se puede compilar desde Archivo > Compilar en MO... .

![Compilar en formato MO]({{ base.url }}/assets/posts/traducir-sitios-webs-con-poedit/compilar-en-formato-mo.webp)


---


Ahora sabés lo básico para crear traducciones. El lugar dónde se guardan las traducciones son diversas y dependen del programa que las utiliza. En Wordpress, es en la carpeta **languages**, dentro del directorio dónde se encuentran los archivos del theme que querés utilizar.

¡Gracias por leer! Nos vemos en un próximo tutorial.