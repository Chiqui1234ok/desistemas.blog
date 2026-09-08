---
layout: post
title:  "TrueNAS Scale • Permisos ACL"
date:   2024-11-25 22:00:00 +0000
categories: truenas acl
tags: truenas, scale, permisos, ACL
---

Estos permisos y comportamientos descriptos son para **ACL Type** seteado en **SMB/NFSv4**.

## **Read Data**:

- Permite al usuario o grupo leer el contenido de los archivos o carpetas (listar su contenido).

## **Write Data**:

- Permite al usuario o grupo **escribir datos en un archivo existente** o **crear nuevos archivos** en una carpeta.

<aside>
💡

Si el usuario A crea un archivo o carpeta, éste se transforma en dueño de él.

Un usuario B no podrá editar o borrar, a pesar de tener todos los permisos otorgados. Sólo podrá modificar y eliminar si en TrueNAS está especificado un permiso ACL para el grupo (dónde estén usuario A y B).

Para solucionar ésto, debemos ir a los ACL e indicar las opciones **Apply permissions recursively** y **Apply permissions to child datasets**. Con hacerlo una vez, será suficiente.

</aside>

## **Append Data**:

- En teoría, permite al usuario o grupo **añadir datos al final de un archivo** sin sobrescribir el contenido existente. En la práctica (con un txt) sólo funciona si está combinado con **Write Data**, **Write Attributes** y **Write Named Attributes**, lo cuál lo hace inútil.

## **Read Named Attributes**:

- Permite al usuario o grupo **leer atributos adicionales** que el sistema de archivos puede almacenar junto con un archivo o carpeta.
- Los atributos adicionales pueden ser incrustados por una app, y no son los metadatos convencionales.

## **Write Named Attributes**:

- Permite al usuario o grupo **escribir o modificar atributos nombrados adicionales** asociados con un archivo o carpeta.
- Los atributos nombrados son metadatos específicos del sistema de archivos que pueden ser utilizados por ciertas aplicaciones para almacenar información adicional. Este permiso permite al usuario agregar o modificar estos atributos personalizados.

## **Execute**:

- Permite al usuario o grupo **ejecutar archivos** (si son ejecutables y si el dataset lo permite) o **atravesar una carpeta** para acceder a subdirectorios.
- En una carpeta, este permiso es necesario para poder "entrar" en ella y acceder a su contenido o a sus subcarpetas, aunque no permite listar el contenido de la carpeta misma (para eso se necesita "Read Data").
- En archivos ejecutables, permite la ejecución del archivo.

## **Delete Children**:

- Permite al usuario o grupo **eliminar archivos o subdirectorios dentro de una carpeta**, independientemente de los permisos en los archivos o subcarpetas específicas. Incluso sin ser propietario.

<aside>
💡

El usuario siempre podrá eliminar archivos de su propiedad.

</aside>

## **Read Attributes**:

- Permite al usuario o grupo solamente **leer los atributos convencionales** del archivo o carpeta, como: tipo de archivo, permisos, propietario y grupo, última vez abierto (atime), última vez modificado (mtime), última vez que se cambiaron metadatos (ctime), inodo, cantidad de enlaces duros que le apuntan.

## **Write Attributes**:

- Permite al usuario o grupo solamente **modificar los atributos estándar** del archivo o carpeta, como las fechas de creación y modificación.

## **Delete**:

- Esta propiedad permite eliminar la carpeta raíz, que tiene este permiso activado. Ésto, en casi todos los casos, lo aplicamos a un Dataset. Por ende, un usuario con este permiso puede eliminar toda la carpeta en cuestión. Como se trata de un dataset que seguirá montado, en la práctica eliminar la carpeta eliminará su contenido pero seguirá estando en el Share.

![image.png]({{ base.url }}/assets/posts/truenas-scale-permisos-acl/image.png)

Como se puede ver, “Pruebas” es un dataset.

## **Read ACL**:

- Permite al usuario o grupo **leer la Lista de Control de Acceso (ACL)** del archivo o carpeta.
- Esto permite ver quién tiene acceso y qué permisos específicos tienen otros usuarios o grupos sobre el recurso, sin la capacidad de modificar esos permisos.

## **Write ACL**:

- Permite al usuario o grupo **modificar la ACL** del archivo o carpeta, es decir, agregar, modificar o eliminar entradas en la lista de control de acceso.
- Con este permiso, el usuario puede cambiar quién tiene acceso al archivo o carpeta y con qué nivel de permisos.

## **Write Owner**:

- Permite al usuario o grupo **cambiar el propietario** del archivo o carpeta.
- Este es un permiso de administración que permite asignar la propiedad del recurso a otro usuario o grupo.

## **Synchronize**:

- Permite al usuario o grupo **abrir el archivo o carpeta en modo de sincronización**, lo cual asegura que las operaciones de lectura y escritura se completen en el orden en que fueron solicitadas.
- Este permiso es útil para evitar problemas de concurrencia en sistemas con acceso simultáneo, asegurando consistencia en el acceso al archivo o carpeta.