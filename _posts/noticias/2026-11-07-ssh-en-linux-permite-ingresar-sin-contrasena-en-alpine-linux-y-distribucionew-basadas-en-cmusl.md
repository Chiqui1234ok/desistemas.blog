---
layout: post
title: "Cualquiera puede entrar a Alpine Linux sin conocer la contraseña • Nueva vulnerabilidad de SSH en combinación con C MUSL"
date: 2026-11-07 14:10:03 +0000
categories: [Seguridad, Sysadmin]
tags: [openssh, alpine, vulnerabilidades, cve, ciberseguridad]
---
El proyecto OpenSSH ha publicado de urgencia la versión 10.6p2 para subsanar un fallo crítico que permite a atacantes no autenticados iniciar sesión de forma remota en cuentas sin contraseña (por ejemplo, cuentas protegidas únicamente mediante llaves SSH) en servidores basados en Alpine Linux.

A continuación, detallamos la causa técnica del fallo, los requisitos para que un host sea explotable y los pasos necesarios para mitigar el riesgo.

# Causa técnica: colisión entre musl y OpenSSH

La vulnerabilidad fue descubierta y reportada por el investigador Özgún Kültekin (Wakefield). Se origina por un comportamiento inesperado entre la lógica interna de autenticación de sshd y la implementación de la función crypt() en la biblioteca estándar musl libc, empleada por Alpine Linux.

# Mecánica del fallo

1. Compilación sin PAM: En los paquetes predeterminados de Alpine Linux, openssh-server se compila sin soporte PAM (Pluggable Authentication Modules), delegando la validación de contraseñas enteramente al código nativo de sshd.

2. Cuentas basadas en claves o del sistema: En /etc/shadow, los usuarios que no poseen una contraseña tradicional (como los configurados para acceder exclusivamente con llave pública) tienen un asterisco (*) en el campo del hash.

3. Mecanismo anti-timing (CVE-2016-6210): Para evitar que un atacante descubra si un usuario existe midiendo el tiempo de respuesta, sshd toma prestado el salt de otra cuenta válida del sistema si la cuenta objetivo tiene un hash inválido o demasiado corto.

4. Límite de longitud en musl crypt(): Si el hash de referencia utiliza SHA-256 ($5$) o SHA-512 ($6$), la función crypt() de musl rechaza entradas mayores a 256 bytes (diseñado originalmente como defensa contra ataques DoS) y devuelve una cadena de error de un único carácter: *.

5. Autenticación concedida: sshd compara la salida de crypt() ("*") con el valor almacenado en /etc/shadow para esa cuenta ("*"). Al ser idénticos, valida la sesión en un único intento.

Con maa condiciones dadas, un atacante remoto solo necesita enviar una contraseña arbitraria de entre 257 y 1.024 caracteres  dirigida a un usuario sin contraseña para ingresar al sistema.

# Requisitos de explotación

- Un  sistema solo es vulnerable si confluyen todas estas condiciones:

- Utiliza openssh-server sin soporte PAM (o configurado con UsePAM no).

- Mantiene habilitada la directiva PasswordAuthentication yes (comportamiento por defecto).

- Posee al menos un usuario con * en el campo de contraseña de /etc/shadow (frecuente en root o cuentas de despliegues en la nube).

- Posee al menos otra cuenta local con un hash convencional ($5$ o $6$).

> [!IMPORTANT]
> Importante: Las distribuciones basadas en glibc (como Debian, CentOS, RHEL, Ubuntu) y los servicios que emplean PAM o demonios como Dropbear no están afectados por este problema.

# Mitigación y Actualización

1. Actualizar el paquete OpenSSH

Alpine Linux ha liberado paquetes parcheados para todas sus versiones soportadas. Para aplicar el parche y reiniciar el demonio:

```bash
apk upgrade -U openssh
rc-service sshd restart
```

2. Deshabilitar la autenticación por contraseña (Solución temporal)

Si no es posible actualizar de inmediato, la recomendación de los mantenedores de OpenSSH es deshabilitar la autenticación por contraseña:

a) Modifica la configuración en /etc/ssh/sshd_config o añade un archivo en sshd_config.d/:

```bash
echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/disable-password.conf
```

b) Valida la configuración y reinicia el servicio:

```bash
sshd -t && rc-service sshd restart
```

c) Confirma la directiva activa:

```bash
sshd -T | grep -i passwordauthentication
```

> [!TIP]
> Debe retornar: `passwordauthentication no`.

# Detección e investigación

Si sospechas que un entorno estuvo expuesto, revisa /var/log/messages en busca de inicios de sesión por contraseña en cuentas restringidas, por ejemplo:

```
Accepted password for <usuario> from <IP_ORIGEN> port <PUERTO> ssh
```

Si encuentras accesos no justificados, audita inmediatamente ~/.ssh/authorized_keys, las tareas programadas en cron y el historial de comandos ejecutados en el sistema.
