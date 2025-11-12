---
layout: post
title:  "Prueba Kubernetes como en producción"
date:   2025-01-30 16:46:00 +0000
tags: guía, curso, kubernetes, balanceo de carga, kubernetes producción, linux, debian, docker, jenkins, ci, cd, cicd
---

# Preámbulo

Este completo tutorial busca crear un entorno con dos máquinas virtuales, que ejecutan el siguiente software:

1) Docker: para instalar rápidamente el software a implementar.
2) Jenkins: para automatizar el despliegue a producción.
3) Kubernetes: para crear un balanceo de carga. Depende de los dos primeros.
4) Prometheus: obtiene cientos de puntos de datos sobre la máquina dónde se ejecuta.
5) Grafana: muestra los datos de Prometheus en un historigrama.

# Creación e instalación de la VM

En caso de no saber sobre cómo crear una máquina virtual con Debian 12, se recomienda seguir [este tutorial](#) y todas las recomendaciones posteriores que se muestran ahí, como la comprobación de los parches de seguridad de la VM, los ajustes sobre el gestor de paquetes, de la fecha y hora del sistema con chronyd, instalar byobu y btop y configurar la IP estática (esto permitirá conectarse vía SSH siempre a la misma IP).

## Post-instalación

Además de lo anteriormente mencionado, se debe instalar:

1. **netcat**: ideal para comprobar si los puertos requeridos por Kubernetes fueron abiertos.

```bash
apt install netcat-traditional -y
```

Docker, por su parte, abrirá los puertos que requiera, utilizando **iptables**.

2. **iptables-persistent**: permite guardar los puertos editados en iptables, de forma que sean persistentes en el sistema.

```bash
apt install iptables-persistent -y
```

Preguntará por el guardado de:
1. Las reglas IPv4: Si
2. Las reglas IPv6: No (comúnmente, ninguna red interna utiliza IPv6)

3. Se instala **GPG** para la importación de las claves públicas de nuevos repositorios:

```bash
apt install gpg
```

-------

Luego de tener una única VM lista, se procede con la instalación del software. Más adelante se clonará para tener dos máquinas operativas.

# Iniciar sesión vía SSH

En una terminal de Linux, Mac o Windows, se debe tipear:

```bash
ssh sistemas@192.168.0.228 
# Nota: modificar con la IP de la VM dónde se está trabajando
```

# Elevar permisos

Para ejecutar los siguientes comandos de instalación, es preciso estar operando como "root":

```bash
su -
# Introducir contraseña de administrador
```

# Docker · Instalación

*Esta guía utiliza la [oficial](https://docs.docker.com/engine/install/debian/) de Docker.*

Para correr los contenedores en "pods", un nuevo concepto que incorpora Kubernetes, es necesario tener primero la aplicación que ejecuta esos contenedores. De los [distintos proyectos que soporta Kubernetes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/), se elije Docker.

Para comenzar con la instalación, se debe ejecutar la siguiente cadena de comandos, en la terminal de la máquina virtual:

## Añadir clave oficial GPG de Docker

```bash
apt update && \
apt install ca-certificates curl -y && \
install -m 0755 -d /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
chmod a+r /etc/apt/keyrings/docker.asc
```

## Añadir el repositorio al gestor apt:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
```

## Actualizar el repositorio e instalar

```bash
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

## Comprobar la instalación

El siguiente comando indicará que el servicio "docker" está corriendo:

```bash
systemctl status docker
```

![mensaje de systemd]({{ base.url}}/assets/img/prueba-kubernetes-como-en-produccion/systemctl-status-docker.png)

# Jenkins · Instalación

Tomando la guía [oficial](#), se procede a:

## Añadir el GPG de Jenkins:

Estas keys corresponden al la versión LTS de Jenkins.

```bash
wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
```

## Actualizar repositorios con la nueva entrada, e instalar

```bash
apt update
apt install jenkins
```

## Instalar Java

Jenkins utiliza Java para ejecutarse, y la implementación OpenJDK es ideal, sin necesidad de virar hacia software de código privativo.

```bash
apt install fontconfig openjdk-17-jre -y
```

## Comprobar la instalación de Java

```bash
java -version
```

El comando `java -version` debería mostrar en pantalla la siguiente leyenda:

```bash
openjdk version "17.0.13" 2024-10-15
OpenJDK Runtime Environment (build 17.0.13+11-Debian-2deb12u1)
OpenJDK 64-Bit Server VM (build 17.0.13+11-Debian-2deb12u1, mixed mode, sharing)
```

# Kubernetes · Pre-requisitos

## Abrir puertos

Kubernetes requiere conectarse por una serie de puertos, como explica en su [documentación](https://kubernetes.io/docs/reference/networking/ports-and-protocols/). Esto se configura con **iptables**:

```bash
iptables -A INPUT -p tcp --dport 6443 -j ACCEPT && \
iptables -A INPUT -p tcp --dport 2379 -j ACCEPT && \
iptables -A INPUT -p tcp --dport 2380 -j ACCEPT && \
iptables -A INPUT -p tcp --dport 10250 -j ACCEPT && \
iptables -A INPUT -p tcp --dport 10259 -j ACCEPT && \
iptables -A INPUT -p tcp --dport 10257 -j ACCEPT
```

Luego, se hacen persistentes con:

```bash
netfilter-persistent save
```

Se debe reiniciar el equipo, para confirmar que la apertura de puertos es persistente:

```bash
reboot
```

Al iniciar sesión como usuario "sistemas" y luego elevar privilegios con `su -`, se puede ejecutar:

```bash
iptables -L
```

Los puertos permitidos aparecerán así:

![iptables -L]({{ base.url }}/assets/posts/prueba-kubernetes-como-en-produccion/iptables_-L.png)

# Kubernetes · Instalación

La web oficial indica en [esta sección](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime):

> Docker Engine does not implement the CRI which is a requirement for a container runtime to work with Kubernetes. For that reason, an additional service cri-dockerd has to be installed. cri-dockerd is a project based on the legacy built-in Docker Engine support that was removed from the kubelet in version 1.24.

El endpoint al que Kubernetes se conectará es: *unix:///var/run/cri-dockerd.sock*.

Ahora si, se procede a instalar ***kubeadm*** (bootstrap del cluster), ***kubelet*** (encargado de iniciar pods y contenedores) y ***kubectl*** (la línea de comandos para interactuar con cada cluster).

## Añadir la clave pública para la versión 1.32 de Kubernetes

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
``` 

## Añadir el repositorio apt al gestor de paquetes

```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
```

## Instalar con *apt*

```bash
apt update && \
apt install -y kubelet kubeadm kubectl
```

## Evitar actualizaciones de Kubernetes

```bash
apt-mark hold kubelet kubeadm kubectl
```

Este comando indicará por pantalla que no se actualizarán los paquetes:

```bash
kubelet fijado como retenido.
kubeadm fijado como retenido.
kubectl fijado como retenido.
```

## Habilitar el servicio de *kubelet*

Se debe habilitar con el siguiente comando:

```bash
systemctl enable --now kubelet
```

Al realizar ésto, la aplicación entrará en un loop en el cuál espera a que ***kubeadm*** le indique qué hacer.

# CGroups

💡 CGroups es un conjunto de funciones del kernel Linux que permite aislar y designar recursos del sistema de forma controlada a cierto proceso. Existen varios drivers para ésto.

Docker y Kubernetes deben utilizar el mismo controlador de CGroups. Al utilizar Debian y por ende ***systemd***, ya se utiliza el controlador propio de este init: cgroups v2. Utilizar éste es la forma recomendada, siendo que además ***kubelet*** inicia como un proceso hijo de ***systemd***.

A partir de la versión 1.22, el default es el driver de ***systemd***, por lo cuál no debe realizarse ningún cambio.

[Más información](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/).

## Comprobar la existencia de CGroups V2

Para poder comprobar el tipo de cgroup, se escribe el comando:

```bash
stat -fc %T /sys/fs/cgroup/
```

Que imprimirá en pantalla: `cgroup2fs`.

# Clonar VM

Si, llegó el momento de clonar la máquina virtual porque se realizaron las siguientes tareas:

1) Configuración básica del SO.
2) Actualizar el gestor de paquetes.
3) Añadir los repositorios de Docker, Jenkins y Kubernetes.
4) Instalar estos 3 softwares.

Para clonar la máquina virtual, se apaga ejecutando en la terminal:

```bash
poweroff
```

Luego, en Proxmox se realizan los siguientes clics:

![alt text]({{ base.url }}/assets/posts/prueba-kubernetes-como-en-produccion/clonar-vm-proxmox.png)

La acción "Clone" abrirá una ventana, dónde se completan los campos de la siguiente manera:

- VM ID: 281
- Name: kubernetes-cicd2
- Snapshot: current
- Target storage: Same as source

## Atención

⚠️ Por el momento, se sigue trabajando en la máquina original.
Se enciende desde la interfaz de Proxmox, y se continúa.

# Configuración · *kubeadm*

***kubeadm*** permitirá automatizar el despliegue de una aplicación en un clúster Kubernetes, siendo un "clúster" un conjunto de máquinas que poseen versiones idénticas de ***kubelet***, ***kubeadm*** y ***kubectl*** instalados. Estas máquinas trabajan en conjunto, para garantizar la alta disponibilidad del software.

Con esta aplicación es posible crear un clúster viable para producción, es decir, que incluso pueda obtener la [Certificación de Kubernetes](https://kubernetes.io/blog/2017/10/software-conformance-certification/) (cosa que se hará hincapié más adelante).

## Objetivos

1. Configurar un servidor orquestador.
2. Instalar una red para que los pods puedan comunicarse.

Seguir leyendo en: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#instructions