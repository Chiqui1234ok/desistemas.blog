---
layout: post
title:  "Proxmox desde cero"
date:   2024-10-01 19:00:00 +0000
tags: guía, tutorial, proxmox, instalar, sistema, sistema operativo, alternativa
---

# Hablando en voz alta

Cuándo estaba escribiendo mi tutorial de [Todo sobre virtualización en Proxmox]({% post_url 2024-10-27-todo-sobre-virtualizacion-en-proxmox %}), caí en cuenta que... ¡no tengo tutorial de cómo se puede instalar Proxmox!

¿Cómo pretendo marcar el zurco para que germine mi comunidad y crezca en sabiduría, si no tengo un buen tutorial para comenzar con este sistema operativo?

# Objetivos

1. Analizar los requisitos de hardware: determinar un hardware base para poder experimentar y aprender.
2. Configurar lineamientos que debe una persona IT: y mejorar cualidades como la curiosidad, razonamiento, documentación, etc.
3. Aprender de forma general sobre los temas troncales de Proxmox: Tutoriales y links útiles para tu mejor insersión en el sistema.
4. Realizar una instalación de Proxmox 8.x .
5. Aprender las herramientas de Proxmox 8.x .

# Convenciones

Estas convenciones son para que puedas interpretar mejor, cuándo leas una palabra en un formato distinto del que venías leyendo.

1. `Texto en tipografía de "programador"`: Utilizo este tipo de estilo cuándo estoy escribiendo archivos de configuración u otro tipo de código.
2. ***Texto en negrita y cursiva***: Cuándo hablo de servicios, software, directorios o archivos.
3. **TEXTO EN MAYÚSCULAS**: Cuándo estoy haciendo referencia a una sección de la página. Generalmente un título que puede verse dentro de una captura de pantalla, determina "una sección".
4. **Texto en negrita**: Para indicar campos que pueden interactuar con el usuario. En la imágen del inicio del post, podrían ser **Node**, **VM ID**, **Resource Pool**, etc.
5. > Texto tipo cita: Para indicar notas (estilo "voz en off") del autor que está redactando el post.
   >

---

# Preámbulo

Proxmox (o Prox, entre los amigos) es un hipervisor de capa 1, porque gracias a KVM (módulos del Kernel Linux) una máquina virtual puede conseguir tener acceso (casi) directo al hardware del equipo. Por esta razón, también se le puede llamar "hipervisor bare-metal". Cuándo nos referimos a "bare-metal", estamos hablando de que un software corre directamente sobre el hardware de la máquina.

El hecho de que sea capa 1 lo hace más performante, porque se logra ejecutar la virtualización con la menor cantidad de trabas / paredes / capas de abstracción posibles, sólo las necesarias para lograr el cometido 😄
