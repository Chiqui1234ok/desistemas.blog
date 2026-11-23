---
layout: post
title:  "Bitwarden gratis (selfhosted) en Linux • Vaultwarden"
date:   2025-09-21 12:49:00 +0000
categories: seguridad
tags: guía, tutorial, docker, bitwarden, vaultwarden, linux, contenedor, seguridad
---

# Preámbulo

Almacenar contraseñas directamente en el navegador web representa un riesgo elevado: cualquier extensión comprometida, fallo de aislamiento o ataque mediante JavaScript malicioso puede exponer las credenciales guardadas.

Para evitar depender de terceros sin resignar comodidad ni auditoría criptográfica, **Vaultwarden** se consolidó como la alternativa *self-hosted* por excelencia. Se trata de una implementación alternativa del servidor de Bitwarden escrita en Rust, sumamente liviana y 100 % compatible con los clientes oficiales (escritorio, extensiones de navegador y aplicaciones móviles).

En esta guía se instalará **Vaultwarden (`1.34.3`)** mediante Docker sobre **Debian 12.7** aplicando buenas prácticas de seguridad desde el primer minuto, junto con el cliente oficial **Bitwarden Desktop (`v2025.8.2`)**.

> **Nota sobre seguridad:** Bitwarden exige **HTTPS obligatorio** para operar. Los navegadores modernos bloquean la *WebCrypto API* (necesaria para cifrar y descifrar la bóveda localmente) si se intenta acceder mediante HTTP sin cifrar fuera de `localhost`. Es necesario contar con un dominio y certificado HTTPS.

---

# Instalar Docker

1. Iniciar sesión en el servidor Linux con un usuario con privilegios administrativos y elevar sesión a `root`:

```bash
sudo -i
```
*(Si `sudo` no está instalado en Debian, utilizar `su -`).*

2. Actualizar el índice de paquetes e instalar las dependencias necesarias para añadir repositorios HTTPS:

```bash
apt update
apt install ca-certificates curl -y
```

3. Crear el directorio para las llaves GPG de APT con permisos `0755`:

```bash
install -m 0755 -d /etc/apt/keyrings
```

4. Descargar la llave oficial de Docker y otorgar permisos de lectura:

```bash
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
```

5. Incorporar el repositorio oficial de Docker a las fuentes de APT:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
```

6. Actualizar nuevamente los repositorios e instalar Docker Engine junto con el plugin de Docker Compose:

```bash
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

---

# Instalar y endurecer Vaultwarden (servidor)

1. Crear el directorio base del proyecto y la carpeta persistente para la base de datos y adjuntos:

```bash
mkdir -p /opt/vaultwarden/data && cd /opt/vaultwarden
```

2. Generar un hash seguro **Argon2id** para proteger el panel de administración (`/admin`). Nunca se debe utilizar una contraseña en texto plano para este parámetro:

```bash
docker run --rm -it vaultwarden/server:1.34.3 /vaultwarden hash
```

El comando solicitará una contraseña maestra para el panel administrativo y devolverá una cadena similar a `ADMIN_TOKEN='$argon2id$v=19$m=65540,t=3,p=4$...'`. Guardar ese valor.

3. Crear un archivo `.env` con permisos restringidos para almacenar las variables sensibles fuera del `docker-compose.yml`:

```bash
nano /opt/vaultwarden/.env
```

Pegar el siguiente contenido (reemplazando el dominio y el hash generado en el paso anterior):

```env
DOMAIN=https://vault.tudominio.com
SIGNUPS_ALLOWED=true
INVITATIONS_ALLOWED=false
SHOW_PASSWORD_HINT=false
ADMIN_TOKEN='$argon2id$v=19$m=65540,t=3,p=4$TU_HASH_GENERADO_AQUI'
```

> **Importante:** `SIGNUPS_ALLOWED=true` se deja habilitado **únicamente** para crear tu cuenta inicial. Más adelante se cambiará a `false` para cerrar el registro público.

4. Restringir los permisos del archivo `.env` para que solo `root` pueda leerlo:

```bash
chmod 600 /opt/vaultwarden/.env
```

5. Crear el archivo `docker-compose.yml`:

```bash
nano /opt/vaultwarden/docker-compose.yml
```

Pegar la siguiente definición, que incluye vinculación exclusiva a `127.0.0.1` (para forzar el paso por un proxy inverso con HTTPS) y reducción de privilegios del contenedor:

```yaml
services:
  vaultwarden:
    container_name: vaultwarden
    image: vaultwarden/server:1.34.3
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - "127.0.0.1:8080:80"
    volumes:
      - ./data:/data
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - SETUID
      - SETGID
      - DAC_OVERRIDE
```

*(Guardar en `nano` con `CTRL + O`, `ENTER`, y salir con `CTRL + X`).*

---

# Comprobar el arranque del contenedor

Ubicados dentro de `/opt/vaultwarden`, iniciar el servicio en segundo plano:

```bash
cd /opt/vaultwarden
docker compose up -d
```

Verificar los registros de arranque para confirmar que no existan errores:

```bash
docker logs vaultwarden
```

La salida debe mostrar el banner de inicio de la versión `1.34.3`:

```text
/--------------------------------------------------------------------\
|                        Starting Vaultwarden                        |
|                           Version 1.34.3                           |
|--------------------------------------------------------------------|
| This is an *unofficial* Bitwarden implementation, DO NOT use the   |
| official channels to report bugs/features, regardless of client.   |
| Send usage/configuration questions or feature requests to:         |
|   https://github.com/dani-garcia/vaultwarden/discussions or        |
|   https://vaultwarden.discourse.group/                             |
| Report suspected bugs/issues in the software itself at:            |
|   https://github.com/dani-garcia/vaultwarden/issues/new            |
\--------------------------------------------------------------------/
```

---

# Utilizar HTTPS con la aplicación (Proxy Inverso)

Como el contenedor escucha únicamente en `127.0.0.1:8080`, es necesario colocar un proxy inverso delante que gestione el certificado TLS y redirija el tráfico cifrado hacia Vaultwarden.

Si ya utilizas **Nginx Proxy Manager** o **Caddy** en tu infraestructura, basta con apuntar el subdominio `vault.tudominio.com` hacia la IP del host en el puerto `8080` y activar SSL con Let's Encrypt.

Si deseas configurarlo directamente en el mismo servidor Debian mediante **Nginx + Certbot**:

1. Apuntar un registro DNS tipo **A** de `vault.tudominio.com` hacia la IP pública del servidor (o IP privada si se usará exclusivamente dentro de una VPN como WireGuard/Tailscale).
2. Instalar Nginx y Certbot:

```bash
apt install nginx certbot python3-certbot-nginx -y
```

3. Crear el bloque de servidor en `/etc/nginx/sites-available/vaultwarden`:

```nginx
server {
    listen 80;
    server_name vault.tudominio.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Cabeceras de endurecimiento HTTP
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header Referrer-Policy "no-referrer" always;
    }
}
```

4. Habilitar el sitio, verificar la sintaxis y emitir el certificado TLS gratuito con Let's Encrypt:

```bash
ln -s /etc/nginx/sites-available/vaultwarden /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
certbot --nginx -d vault.tudominio.com --redirect
```

A partir de este momento, la bóveda web estará accesible de forma segura en `https://vault.tudominio.com`.

---

# Hardening y seguridad post-instalación

Antes de migrar tus contraseñas reales, aplica estas medidas críticas:

### 1. Crear tu cuenta y cerrar el registro público
1. Ingresa a `https://vault.tudominio.com` y haz clic en **Crear cuenta**.
2. Utiliza una **contraseña maestra larga y única** (idealmente una frase de paso de 4 o 5 palabras aleatorias) y anótala en papel en un lugar físico seguro. Si la olvidas, nadie podrá recuperar tus datos.
3. Una vez creada tu cuenta, edita `/opt/vaultwarden/.env` y deshabilita el registro abierto:

```env
SIGNUPS_ALLOWED=false
```

4. Recrea el contenedor para aplicar el cambio:

```bash
cd /opt/vaultwarden && docker compose up -d
```

*(Opcional: si no necesitas utilizar el panel `https://vault.tudominio.com/admin`, comenta o elimina la variable `ADMIN_TOKEN` del `.env` y reinicia el contenedor para desactivar por completo la interfaz de administración).*

### 2. Activar Autenticación en Dos Pasos (2FA)
Dentro de la interfaz web de Vaultwarden, dirígete a **Configuración → Seguridad → Verificación en dos pasos** y vincula una aplicación autenticadora (**TOTP** como Aegis, Ente Auth o Google Authenticator) o una llave física **FIDO2 / WebAuthn** (YubiKey). Guarda los códigos de recuperación fuera del gestor.

### 3. Configurar Firewall (UFW)
Limita los puertos expuestos al exterior únicamente a SSH y tráfico web cifrado:

```bash
apt install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

### 4. Protección contra fuerza bruta con Fail2ban
Para bloquear automáticamente direcciones IP que intenten adivinar contraseñas mediante ataques automatizados, se recomienda instalar **Fail2ban** y monitorear los intentos fallidos de inicio de sesión registrados por Vaultwarden en `/opt/vaultwarden/data/vaultwarden.log` (activando `LOG_FILE=/data/vaultwarden.log` y `EXTENDED_LOGGING=true` en el `.env`).

### 5. Copias de seguridad cifradas
Toda la información reside en `/opt/vaultwarden/data`. Sin embargo, copiar el archivo `db.sqlite3` en caliente mientras el contenedor escribe datos puede corromper la base de datos. Para respaldar de forma segura mediante `cron`:

```bash
apt install sqlite3 age -y
sqlite3 /opt/vaultwarden/data/db.sqlite3 ".backup '/tmp/db_backup.sqlite3'"
tar -czf /tmp/vw-backup.tar.gz -C /tmp db_backup.sqlite3 -C /opt/vaultwarden/data attachments sends rsa_key.pem rsa_key.pub.pem
```

Luego cifra el archivo resultante (por ejemplo con `age` o `gpg`) antes de sincronizarlo hacia un almacenamiento externo o nube.

---

# Instalar Bitwarden (cliente)

Para conectar los dispositivos al servidor propio, se utilizan los clientes oficiales de Bitwarden. En este ejemplo se instala **Bitwarden Desktop (`v2025.8.2`)** en Linux:

1. Descargar el paquete `.deb` (o `.AppImage`) correspondiente a la versión `desktop-v2025.8.2` desde [GitHub Bitwarden Releases](https://github.com/bitwarden/clients/releases).
2. Instalar el paquete desde la terminal:

```bash
apt install ./Bitwarden-2025.8.2-amd64.deb -y
```

3. **Paso fundamental antes de iniciar sesión:** Al abrir la aplicación (tanto en escritorio como en la extensión de navegador o app móvil), no ingreses tu correo directamente, ya que intentará autenticarse contra los servidores oficiales en la nube (`bitwarden.com`).
4. Hacé clic en el desplegable **"Accediendo a: bitwarden.com"** (o el ícono del engranaje en versiones anteriores), selecciona **Autoalojado (Self-hosted)** e introduce la URL completa de tu servidor:

```text
https://vault.tudominio.com
```

5. Guardá la configuración e inicia sesión con tu correo, contraseña maestra y segundo factor (2FA).

---

# Referencias y fuentes

* [Repositorio oficial y Wiki de Vaultwarden (GitHub)](https://github.com/dani-garcia/vaultwarden/wiki)
* [Documentación de instalación de Docker Engine en Debian](https://docs.docker.com/engine/install/debian/)
* [Lanzamientos oficiales de clientes Bitwarden (GitHub Releases)](https://github.com/bitwarden/clients/releases)
* [Guía oficial de Hardening y Proxy Inverso para Vaultwarden](https://github.com/dani-garcia/vaultwarden/wiki/Hardening)