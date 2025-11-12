---
layout: post
title:  "TrueNAS Scale • Datasets"
date:   2024-11-25 21:00:00 +0000
categories: truenas zfs
tags: truenas, scale, nas, datasets, zfs, zpool
---

# Opciones al crear el dataset

## Quota

Se pueden establecer límites en el espacio ocupado para cada dataset y todos sus hijos, yo probé con los siguientes valores y funciona:

| Valor escrito | Resultado (abreviado) del límite | Qué significa |
| --- | --- | --- |
| 1G / 1GiB | 1GiB | 1 Gibibit |
| 1T / 1TiB | 1TiB | 1 Tebibit |
| 1P / 1PiB | 1PiB | 1 Pebibit |
| 1024P / 1024PiB | 1EiB | 1 Exbibyte |
| 1E / 1EiB | No seteó el límite | No seteó el límite |

### **Sync**

- Controla la política de sincronización para el dataset, es decir, cómo se manejan las operaciones de escritura en términos de seguridad y rendimiento.
- **Opciones**:
    - **Standard**: Las escrituras se sincronizan de acuerdo con el tipo de cliente. Generalmente es la opción más equilibrada entre rendimiento y seguridad.
    - **Always**: Todas las escrituras se sincronizan inmediatamente al disco, asegurando integridad a cambio de un rendimiento más bajo.
    - **Disabled**: Desactiva la sincronización inmediata, mejorando el rendimiento pero arriesgando la pérdida de datos en caso de fallo de energía.

### **Compression Level**

- Define el tipo de compresión que se aplica a los datos almacenados en el dataset.
- **Opciones**:
    - **Off**: No se realiza ninguna compresión.
    - **LZ4**: Compresión rápida y eficiente en uso de recursos; recomendada para la mayoría de los casos.
    - **GZIP** (niveles 1-9): Compresión más intensiva, donde un nivel más alto ofrece mejor compresión, pero con un costo de rendimiento.
    - **ZLE**: Compresión que elimina bloques de cero, ideal para datos con espacios en blanco o nulos.
- La compresión puede ahorrar espacio en disco y mejorar el rendimiento de lectura/escritura, dependiendo de los datos.

### **Enable Atime**

- Controla si el sistema registra la última vez que se accedió a un archivo.
- **Opciones**:
    - **On**: Actualiza el tiempo de acceso cada vez que se lee un archivo.
    - **Off**: No actualiza el tiempo de acceso, lo cual mejora el rendimiento, especialmente en servidores de archivos con muchas lecturas.
- Desactivar esta opción puede ser útil en cargas de trabajo que no requieren registrar el acceso.

### **ZFS Deduplication**

- Activa la deduplicación de datos, lo que permite almacenar bloques idénticos solo una vez.
- **Opciones**:
    - **On**: Activa la deduplicación, ahorrando espacio al evitar duplicación de datos.
    - **Off**: Desactiva la deduplicación, lo cual es menos demandante de memoria y CPU.
- **Nota**: La deduplicación consume mucha memoria y puede afectar el rendimiento. Se recomienda solo si hay suficiente RAM y CPU.

### **Case Sensitivity**

- Determina si el sistema de archivos distingue entre mayúsculas y minúsculas en los nombres de archivos.
- **Opciones**:
    - **Sensitive**: Los nombres de archivo son sensibles a mayúsculas y minúsculas (ej. `file.txt` y `File.txt` son diferentes).
    - **Insensitive**: Los nombres de archivo no distinguen entre mayúsculas y minúsculas.
    - **Mixed**: El sistema de archivos es insensible a mayúsculas y minúsculas, pero conserva el caso original.
- Esta opción es importante para la compatibilidad con sistemas que manejan nombres de archivo de manera distinta.

### **Checksum**

- Verifica la integridad de los datos a medida que se escriben y leen en el disco.
- **Opciones**:
    - **On**: Activa la verificación de integridad mediante sumas de comprobación, protegiendo contra la corrupción de datos.
    - **Off**: Desactiva las sumas de comprobación, lo que podría mejorar el rendimiento, pero aumenta el riesgo de corrupción de datos.
- Es recomendable mantener las sumas de comprobación activadas para asegurar la integridad de los datos.

### **Read-only**

- Controla si el dataset es de solo lectura.
- **Opciones**:
    - **On**: Hace que el dataset sea de solo lectura, sin importar cómo se acceda al dataset (como por ejemplo Linux, Samba, NFS, etc).
    - **Off**: Permite lecturas y escrituras en el dataset.

### **Exec**

- Controla si se pueden ejecutar binarios en el dataset.
- **Opciones**:
    - **On**: Permite la **ejecución de binarios o scripts** almacenados en ese dataset, pero **no afecta directamente a comandos como `ls`**.
    - **Off**: Prohíbe la ejecución de archivos, lo cual puede mejorar la seguridad en entornos de red.
- Es útil para evitar la ejecución de scripts o binarios en datasets que se utilizan solo para almacenamiento.

### **Snapshot Directory**

- Controla la visibilidad del directorio `.zfs`, que contiene los snapshots del dataset.
- **Opciones**:
    - **Visible**: Hace que el directorio `.zfs` sea visible, permitiendo que los usuarios naveguen los snapshots.
    - **Invisible**: Oculta el directorio `.zfs`, evitando que los usuarios accedan directamente a los snapshots.
- Permitir la visibilidad puede ser útil para restaurar archivos desde snapshots sin intervención administrativa.

## ACL Type

Utilizo el tipo SMB/NFSv4, que es el más fácil de implementar y el que explicaré en esta documentación. Este modo resulta en un ACL compacto y fácil de implementar, sin necesidad de máscaras y el añadido de permisos “por default” que complican la lectura, como es el caso de POSIX.

## ACL Mode

- **Passthrough** (uso este, para que funcione bien con el tipo de ACL que elegimos): Permite que los permisos y listas de control de acceso (ACL) configurados en el dataset se apliquen directamente y sean gestionados sin modificaciones. Es útil cuando deseas que los permisos de Samba reflejen exactamente los permisos configurados en el sistema de archivos subyacente (ZFS). Esta opción es ideal si deseas una administración detallada y personalizada de los permisos a nivel de sistema de archivos y quieres que se mantengan sin cambios.
- **Inherit**: Hace que el dataset herede los permisos y ACL de su dataset superior o del dataset "padre". Esto significa que, al crear este dataset, no se aplicarán nuevas ACL directamente a este nivel, sino que usará la configuración de su jerarquía superior, lo cual es útil para mantener una estructura de permisos consistente en varios datasets relacionados.
- **Restricted**: Limita los permisos de manera que solo los administradores tengan control total sobre el dataset. Es adecuado cuando necesitas que solo los usuarios específicos (generalmente administradores) tengan acceso total, y otros usuarios tengan permisos restringidos, independientemente de los permisos de los archivos o directorios que contenga. Esto es útil en entornos de alta seguridad donde no deseas que los usuarios finales modifiquen los permisos.
- **Discard**: Elimina cualquier ACL existente en el dataset, utilizando en su lugar los permisos tradicionales de UNIX (propietario, grupo y otros). Es útil si deseas simplificar la gestión de permisos o si prefieres no usar el sistema ACL y, en su lugar, confiar en permisos más básicos.

## Metadata (Special) Small Block Size

Los metadatos en ZFS incluyen información sobre la estructura de archivos y directorios, permisos, tiempos de creación y modificación, así como otros datos sobre cómo se almacenan los archivos en el sistema de archivos. Estos metadatos se almacenan en bloques que el sistema de archivos usa para acceder rápidamente a la estructura y atributos de los datos.

### **¿Por qué ajustar el tamaño del bloque?**

Configurar el tamaño de bloque para los metadatos permite optimizar la eficiencia del espacio y el rendimiento. Un tamaño de bloque menor (por ejemplo, 512 bytes) consume menos espacio para almacenar metadatos pequeños, lo cual es útil en sistemas con muchos archivos pequeños, mientras que un tamaño de bloque mayor (hasta 1 MB) puede ser beneficioso para reducir la sobrecarga en sistemas con archivos grandes.

### **Ventajas de tamaños de bloque pequeños y grandes:**

| **Tamaño de Bloque** | **Características** | **Ventajas** | **Uso Recomendado** |
| --- | --- | --- | --- |
| **Pequeños (512 bytes, 1 KB, etc.)** | Bloques más pequeños que se ajustan mejor a operaciones de metadatos pequeñas y archivos pequeños. | Ahorro de espacio y eficiencia en operaciones pequeñas. | Configuraciones con muchos archivos pequeños o accesos frecuentes. |
| **Grandes (hasta 1 MB)** | Bloques más grandes que reducen la fragmentación y el número de operaciones de E/S para archivos grandes. | Mejor rendimiento en manejo de archivos grandes. | Acceso y almacenamiento de archivos de gran tamaño. |

### ¿Cuándo elegir un tamaño de bloque específico?

- **512 bytes a 4 KB**: Para configuraciones con muchos archivos pequeños y donde la eficiencia de espacio es crítica.
- **16 KB a 1 MB**: Para configuraciones que manejan archivos grandes o aplicaciones que requieren un rendimiento superior en la lectura/escritura de datos grandes.

Configurar esta opción depende del tipo de carga de trabajo y del hardware disponible, buscando el balance entre eficiencia de espacio y rendimiento en TrueNAS Scale.