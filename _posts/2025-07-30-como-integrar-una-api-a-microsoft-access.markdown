---
layout: post
title:  "Integrar una API REST con VBA y JsonConverter • Microsoft Access"
date:   2025-07-19 17:30:00 -0300
tags: json, jsonconverter, soap, rest, api, microsoft, access, tablas, sql
---

## Preámbulo

Si se le quiere dotar de funcionalidades a Microsoft Access, una forma de hacerlo es mediante llamadas a una API (local o externa). Sin embargo, la mayoría de las APIs envían sus datos en formato JSON y Access no lo puede entender nativamente. Para ello está el proyecto [VBA-JSON en GitHub](https://github.com/VBA-tools/VBA-JSON), que se encarga de darle soporte a este "nuevo" formato que domina la mayoría de las APIs en Node.js y PHP.

Comencemos.

## 1. Descargar JsonConverter.bas

Desde el GitHub oficial se deja ver el archivo **JsonConverter.bas**, al cual se le hace clic y el navegador redirigirá [acá](https://github.com/VBA-tools/VBA-JSON/blob/master/JsonConverter.bas).

Se le hace clic al botón de copiar, como se indica en esta imagen:

![Descargar código fuente]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/descargar-codigo-fuente.png)

## 2. Importar el archivo en VBA

En Access, se debe abrir "Microsoft Visual Basic para Aplicaciones" (editor VBA) con la combinación de teclas **ALT + F11**. Luego, se importa el archivo descargado desde **Archivo > Importar archivo...** (o se pega el código en un nuevo módulo).

![Importar archivo JsonConverter.bas en el editor VBA]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/importar-archivo.png)

## 3. Revisar las referencias del editor VBA

Deben estar las siguientes referencias activadas (en el caso de Access 2016 se tuvieron que habilitar estas características):

- Microsoft Scripting Runtime
- Microsoft XML, v6.0

![Revisar las referencias del editor VBA]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/referencias-editor-vba.png)

Para abrir esta ventana, se accede a **Herramientas > Referencias** desde el editor VBA.

> Es importante mencionar que, una vez que se terminen de activar tanto "Microsoft Scripting Runtime" como "Microsoft XML, v6.0", se le puede dar al botón "Aceptar" y se ordenarán los ítems alfabéticamente al volver a abrir la ventana.

## 4. Crear un módulo para testear JsonConverter

Para crear el módulo se debe apretar la combinación de teclas **ALT + F11**** para abrir el Editor VBA. Luego, se debe hacer clic derecho en la carpeta **Módulos > Insertar > Módulo**, tal cual muestra la siguiente imagen:

![Cómo añadir un módulo desde el Editor VBA]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/anadir-modulo.png)

Allí se puede pegar el siguiente código de prueba, que hace una impresión en pantalla de un JSON.

Antes de simplemente copiar y pegar, se debe prestar atención: este código toma un JSON con la propiedad `"saludo"` y su valor `"¡Hola DeSistemas!"`, lo parsea y lo muestra en consola.

```vb
Sub TestJson()
    Dim json As Object
    Set json = JsonConverter.ParseJson("{""saludo"": ""¡Hola DeSistemas!""}")
    Debug.Print json("saludo")
End Sub
```

Se guarda el módulo con el nombre `ProbarJson` desde el Editor VBA. En dicho editor se presiona `CTRL + G` para abrir la ventana **Inmediato**, lo que permite ejecutar código VBA rápidamente. Escribimos:

```vb
TestJson
```

Y presionamos la tecla `Enter` justo al terminar de escribir. Esto imprimirá `"¡Hola DeSistemas!"`, el valor de la clave `"saludo"` que indiqué antes. La prueba:

![Mensaje parseado "¡Hola DeSistemas!"]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/hola-desistemas-json.png)

Con esta simple prueba nos aseguramos de que el parseador funciona y se instaló correctamente.
De tal forma, cada vez que sea necesario parsear JSON, simplemente se llama a la función:

```vb
JsonConverter.ParseJson(variableQueContieneDatosEnFormatoJson)
```

---

¡Eso es todo! Ojalá les sea útil; no había encontrado mucho en Internet, así que recopilé conocimientos y decidí compartirlo con ustedes.