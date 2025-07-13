---
layout: post
title:  "Como ejecutar un programa desde CMD añadiendo al PATH • Windows"
date:   2025-07-13 19:30:00 -0300
tags: windows, path, programacion, programación, codigo, código, ejecucion, ejecución, cmd, powershell, consola, ejecutar, programa, app
---

# Preámbulo

Cuándo en línea de comandos de Windows se ejecuta ***ping***, ***winsat***, ***msconfig***, etc; el sistema operativo sabe dónde se ubican estos archivos ejecutables y por ésto se abren.

Sin embargo, cuándo se instalan aplicaciones de terceros como ***node***, ***mongosh***, ***mongodb***, ***xgettext***, ***lmstudio*** y un largo etcétera, es posible que el instalador de estas aplicaciones no añada la ruta dónde fueron instalados al PATH. Por ello, si se desea ejecutar una nueva aplicación que no viene por defecto en Windows y desea abrirse desde un CMD o PowerShell, se deben realizar los siguientes pasos:

# ¿Cómo añadimos una aplicación al PATH?

## 1. Ubicar la carpeta dónde se instaló nuestro nuevo programa

Si la aplicación se instaló en (por ejemplo) **C:\Users\Santiago\.lmstudio\bin**, debemos añadir esa ruta al PATH.

![Hay que encontrar dónde está el ejecutable que se desea abrir]({{ base.url }}/assets/posts/como-anadir-al-path-windows/aca-esta-el-ejecutable-que-deseamos-abrir.png)

Como se ve en la imágen, es importante asegurarse de que el ejecutable que se desea abrir desde el CMD o PowerShell esté en la carpeta que se va a añadir al PATH.

Al instalar algunas aplicaciones, el binario que se buscar ejecutar no está en una carpeta tan obvia, sino dentro de otra (en **bin**, como indica el ejemplo del tutorial).

## 2. Abrir la ventana de variables de entorno

Desde el menú de Windows, buscar "variables" y hacer clic en "Editar las variables de entorno del sistema".

![abrir la opcion de Editar las variables de entorno del sistema]({{ base.url }}/assets/posts/como-anadir-al-path-windows/editar-variables-de-entorno-del-sistema.png)

Luego, se debe hacer clic en el botón "Variables de entorno...":

![alt text]({{ base.url }}/assets/posts/como-anadir-al-path-windows/boton-variables-de-entorno.png)

## 3. Editar las variables de entorno

Para poder añadir la ruta de nuestro programa a las variables de entorno, se hace clic en "Path" y luego el botón "Editar":

![Seleccionar "Path" y luego botón "Editar"]({{ base.url }}/assets/posts/como-anadir-al-path-windows/seleccionar-path-y-boton-editar.png)

A continuación, se realizan los siguientes pasos:

![Pasos para añadir una ruta al PATH](pasos-para-anadir-una-ruta-al-path.png)

Luego, se le da al botón "Aceptar" en las ventanas restantes.

---

# Listo

De ahora en más, cualquier nueva ventana de CMD y PowerShell cargará el nuevo PATH y al escribir el nombre de la aplicación que queremos abrir en un CMD o PowerShell, Windows revisará las rutas que están dentro del PATH y abrirá el archivo dónde lo encuentre.