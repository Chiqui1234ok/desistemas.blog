---
layout: post
title:  "Automatizar OpenWRT con su API RPC"
date:   2025-03-14 12:32:00 +0300
tags: openwrt, api, rpc, json
---

Santi del pasado: Me pude comunicar con la API de OpenWRT, pero no tengo idea de como automatizar los cambios en los archivos network, firewall y dhcp (aún).

# Preámbulo

En un punto, el administrador de sistemas podría necesitar automatizar la creación de VLANs o alguna otra función de su router. En una época dónde Ansible y Terraform son la norma, es interesante poder tener opciones de automatización también en OpenWRT, que luego podrían incorporarse con Ansible.

# Instalar API

La filosofía de OpenWRT hace que este sistema operativo no tenga nada pre-instalado, más allá de lo básico. Es por ésto que es necesario realizar la instalación del software que se encarga de tener la API funcionando:

1. Primero, se actualiza el repositorio de paquetes:

```bash
opkg update
```

2. A continuación, se podrá descargar el software para ejecutar la API:

```bash
opkg install luci-mod-rpc luci-lib-ipkg luci-compat
```

Al finalizar el comando, notificará el éxito con este mensaje:

```bash
Configuring liblua5.1.5.
Configuring lua.
Configuring luci-lib-nixio.
Configuring luci-lib-ip.
Configuring luci-lib-jsonc.
Configuring liblucihttp-lua.
Configuring luci-lib-base.
Configuring libubus-lua.
Configuring ucode-mod-lua.
Configuring luci-lua-runtime.
Configuring luci-lib-json.
Configuring luci-mod-rpc.
Configuring luci-lib-ipkg.
Configuring luci-compat.
```

3. Luego, se debe reiniciar el proceso httpd:

```bash
/etc/init.d/uhttpd restart
```

# Habilitar permisos en el firewall

## 1. Revisar el puerto en el que se monta el servicio ***uhttpd***

```
cat /etc/config/uhttpd
```

Las primeras dos líneas serán:

```bash
config uhttpd 'main'
    list listen_http '0.0.0.0:80'
```

Esto indica que el protocolo HTTP "escucha" (es accesible) en el puerto 80. Este puerto debe ser habilitado en el firewall.

## 2. Configurar la regla en el firewall

Este tutorial está mostrando una función que es relativamente avanzada. Se supone que el router ya dispone de zonas en el firewall. En este caso, la zona "srv_home" es la que tendrá acceso al RPC.
Esta "zone" se usará durante todo el tutorial, así que, favor de recordarla.

```bash
config rule
    option name 'Allow LuCI RPC from SRV_HOME'
    option src 'srv_home'
    option dest_port '80'
    option proto 'tcp'
    option target 'ACCEPT'
```

## 3. Reiniciar servicios para aplicar cambios

1. Reiniciar uhttpd

```bash
/etc/init.d/uhttpd restart
```

2. Reiniciar firewall

```bash
/etc/init.d/firewall restart
```

# Iniciar sesión en la API

Para interactuar con los endpoints de la API, es necesario loguearse con el usuario de OpenWRT. Suponiendo que el router está en la dirección "10.0.0.1", sólo se debe editar el siguiente comando para indicar el usuario y contraseña:

```bash
curl http://10.0.0.1/cgi-bin/luci/rpc/auth --data '{ "id": 1, "method": "login", "params": [ "usuario", "contraseña" ] }'
```

Una vez editado, hay dos opciones:

## Opción 1: Ejecutarlo en una terminal

Si ya tenés una terminal con curl instalado, podrás ejecutar este comando, editando con la IP, usuario y contraseña correcta:

```bash
curl http://10.0.0.1/cgi-bin/luci/rpc/auth --data '{ "id": 1, "method": "login", "params": [ "usuario", "contraseña" ] }'
```

Y el resultado será similar a:

```bash
{"id":1,"result":"9dbcc9cb32077161e7424298615adc46","error":null}
```

Debes copiarte el valor de "result", para autenticarte en próximas llamadas a la API.

## Opción 2: Lanzar cURL con Postman

En caso de que creas más conveniente Postman, podrás importar el comando cURL desde el menú.

1. Accedé al menú

![Menú de Postman]({{ base_url }}/assets/posts/openwrt-api/postman-menu.png)

2. Dirigite a File > Import.

![Importación de cURL en Postman]({{ base_url }}/assets/posts/openwrt-api/postman-import.png)

3. En la nueva ventana, pegar el comando cURL en el campo de texto y seleccionar "Import without saving".

4. La importación terminará al instante, y se debe copiar la primer fila y columna:

![Copiar la fila para convertirla a raw]({{ base_url }}/assets/posts/openwrt-api/postman-copy-field.png)

5. La opción "x-www-form-urlencoded" está seleccionada. Se debe cliquear "raw" y pegar la cadena de texto.

6. Realizar clic en el botón "Send" y copiar el valor de "result", ya que es el token con el cuál nos podremos comunicar con la API en llamadas posteriores.

![Resultado de Postman]({{ base_url }}/assets/posts/openwrt-api/postman-result.png)