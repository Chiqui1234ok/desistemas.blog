---
layout: post
title:  "Integrar una API REST con VBA y JsonConverter • Microsoft Access"
date:   2025-07-19 17:30:00 -0300
tags: json, jsonconverter, soap, rest, api, microsoft, access, tablas, sql
---

# Preámbulo

Si se le quiere dotar de funcionalidades a Microsoft Access, una forma de hacerlo es mediante llamadas a una API (local o externa). Sin embargo, las mayorías de APIs envían sus datos en formato JSON y Access no lo puede entender nativamente. Para ello está el proyecto [VBA-JSON en GitHub](https://github.com/VBA-tools/VBA-JSON), que se encarga de darle soporte a este "nuevo" formato que domina la mayoría de APIs en NodeJs y PHP.

Comencemos.

# 1. Descargar JsonConverter.bas

Desde el GitHub oficial se deja ver el archivo **JsonConverter.bas**, al cuál se le hace clic y el navegador redirigirá [acá](https://github.com/VBA-tools/VBA-JSON/blob/master/JsonConverter.bas).

Se le hace clic al botón de Copiar, como se indica en esta imágen.

![Descargar código fuente]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/descargar-codigo-fuente.png)

# 2. Importar el archivo en VBA

En Access, se debe abrir "Microsoft Visual Basic para Aplicaciones" (editor VBA) con la combinación de teclas ALT + F11.

![alt text]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/importar-archivo.png)

# 3. Revisar las referencias del editor VBA

Deben estar las siguientes referencias activadas, en el caso de Access 2016 se tuvieron que habilitar las siguientes características:

- Microsoft Scripting Runtime
- Microsoft XML 6.0

![Revisar las referencias del editor VBA]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/referencias-editor-vba.png)

Para abrir esta ventana, se accede a Herramientas > Referencias, desde el editor VBA.

> Es importante mencionar que una vez se termine de activar tanto "Microsoft Scripting Runtime" como "Microsoft XML 6.0", se le puede dar al botón "Aceptar" y se ordenarán los ítems.

# 4. Crear un módulo para testear JsonConverter

En Access, apretar la combinación de teclas ALT + F11 para abrir el Editor VBA. Luego, se debe hacer clic derecho en la carpeta "Módulos" > Insertar > Módulo, tal cuál la siguiente imágen.

![Cómo añadir un módulo desde el Editor VBA]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/anadir-modulo.png)

Allí se puede pegar el siguiente código de prueba, que hace una impresión en pantalla de un Json.

Antes de simplemente copiar y pegar, se debe prestar atención. Esto crea y parsea a JSON una propiedad "saludo" con su valor "¡Hola DeSistemas!".

```vbs
Sub TestJson()
    Dim json As Object
    Set json = JsonConverter.ParseJson("{""saludo"": ""¡Hola DeSistemas!""}")
    Debug.Print json("saludo")
End Sub
```

Se guarda el archivo con nombre "ProbarJson" desde el Editor VBA. En dicho editor se presiona CTRL + G, para abrir la ventana "Inmediato". Esto permite ejecutar código VBA rápidamente. Escribimos:

```
TestJson
```

Y presionamos la tecla "Enter" justo al terminar de escribir. Esto imprimirá "¡Hola DeSistemas!", el valor de la clave "saludo" que indiqué antes. La prueba:

![Mensaje parseado "¡Hola DeSistemas!"]({{ base.url }}/assets/posts/como-integrar-una-api-a-microsoft-access/hola-desistemas-json.png)

Con esta simple prueba nos aseguramos de que funciona el parseador y se instaló correctamente.
De tal forma, cada vez que sea necesario parsear json simplemente se llama a la función:

```
JsonConverter.ParseJson(<variableQueContieneDatosEnFormatoJson>)
```

---

¡Eso es todo! Ojalá les sea útil, no había encontrado mucho en Internet pero recopilé conocimientos y decidí compartirlo con ustedes.