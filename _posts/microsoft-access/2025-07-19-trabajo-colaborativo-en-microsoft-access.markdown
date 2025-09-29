---
layout: post
title:  "Trabajo colaborativo • Microsoft Access"
date:   2025-07-19 17:30:00 -0300
categories: [programacion]
tags: trabajo, colaborativo, simultaneo, microsoft, access, tablas, sql
---

# Preámbulo

En este tutorial vamos a aprender como dividir un archivo de base de datos Access 2007 - 2016 en dos piezas llamadas "front-end" y "back-end".
Este procedimiento se considera una buena práctica porque:

- Modulariza los datos y lógica de la BD: esto hace que el mantenimiento y futuros desarrollos del programador/administrador sean más fáciles en su implementación.
- Mejora el rendimiento de la base de datos: esto se logra porque sólo los datos son transportados por la red y cargados en memoria.

> En una base de datos que no está dividida, un único archivo contiene tablas, consultas, filtros, formularios, reportes, macros y módulos. Muchos de estos elementos no son necesarios siempre por el usuario, sin embargo, se envían por la red y cargan en memoria por un tema "de diseño".

- Es más resiliente: si a un usuario se le cierra el Microsoft Access de forma inesperada, la posible corrupción del archivo que abrió con Access se limita a la copia del front-end que tiene ese usuario particular. Esto es porque el usuario accede a los datos de la BD utilizando tablas linkeadas, y los datos llegan de forma síncrona.

> Las chances de resultar con una base de datos corrupta por un cierre inesperado en un front-end, son cercanas a cero.

- Sistema de roles: esta división entre back y front da la posibilidad de brindar diferentes copias del front-end a cada usuario, segmentando su uso por departamento (suponiendo que estamos trabajando con una base de datos de una organización de 2 empleados o más). Cada copia puede tener diferencias entre sí. Por ejemplo, el front-end A podría tener consultas o formularios que trabajen en una tabla que guarda la facturación, mientras que el front-end B sólo vería los clientes que deben dinero a la empresa.
- Uso en simultáneo: al tener un front-end para cada usuario, todos ellos podrán trabajar en la base de datos sin que ésta se bloquee e imposibilite a alguien trabajar. Si bien Access tiene una opción para permitir el trabajo colaborativo con una base de datos unificada (sin modularizar front y back), las chances de corromper los datos es mucho más alta que realizando la división que se propone en este artículo.

---

Comencemos con los 2 pasos a realizar:


# 1. Realizar un backup

Antes que nada, ningún usuario debe estar en la base de datos durante la duración de este procedimiento. Además, antes de realizar la división es vital copiar la base de datos en algún sitio, para tener un respaldo.

En este tutorial se trabaja con el archivo original, y la copia se deja como backup.

Una vez realizado este backup, se puede abrir el archivo original con Microsoft Access y comenzar con la división.

# 2. División

Al abrir el archivo **.accdb**, se debe ir a la pestaña "Herramientas de la base de datos" y luego presionar el botón "Base de datos de Access".

![Presionar el botón "Base de datos de Access" bajo la pestaña "Herramientas de la base de datos", para iniciar con la división]({{ base.url }}/assets/posts/trabajo-colaborativo-en-microsoft-access/asistente-base-de-datos-de-access.png)

Se abrirá el asistente para la división de la base de datos. Se confirma realizando clic en el botón "Dividir base de datos".

![alt text]({{ base.url }}/assets/posts/trabajo-colaborativo-en-microsoft-access/asistente-con-boton-dividir-base-de-datos.png)

Este proceso tardará unos segundos, y la ventana de guardado querrá almacenar un nuevo archivo con el sufijo **_be**. Le damos al botón Dividir, que está al lado de Cancelar.

![alt text]({{ base.url }}/assets/posts/trabajo-colaborativo-en-microsoft-access/guardar-back-end.png)

Al guardar el archivo, pasarán unos segundos y el resultado será una ventana que anuncia "La base de datos se dividió satisfactoriamente". Se presiona el botón "Aceptar".

# Resultado

Al presionar el botón "Aceptar", Access tendrá el nuevo front-end abierto. Se observan cambios:

![alt text]({{ base.url }}/assets/posts/trabajo-colaborativo-en-microsoft-access/cambios-objetos-en-bd-dividida.png)

- Hay un asterisco al lado de cada tabla, indicando que es un link
- Al posar el cursor por arriba de alguna tabla, por ejemplo, "CERTIFICADOS", saldrá un recuadro blanco indicando que hace referencia al archivo con el sufijo **_be** (el back-end).

Sólo para recapitular, si miramos el backup de la base de datos que se realizó antes de comenzar con la división, los objetos de la tabla se verán así:

![alt text]({{ base.url }}/assets/posts/trabajo-colaborativo-en-microsoft-access/objetos-de-bd-backup.png)

Sin asterisco al lado de cada tabla y, además, este archivo pesa más que el back-end.

---

El proceso es muy sencillo, ¡ojalá les sea útil!