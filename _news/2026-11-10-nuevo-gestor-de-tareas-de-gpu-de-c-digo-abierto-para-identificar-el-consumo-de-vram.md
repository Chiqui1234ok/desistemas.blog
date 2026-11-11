---
layout: post
title: "Nuevo gestor de tareas de GPU de código abierto para identificar el consumo de VRAM"
description: "Scott Hanselman presenta gputaskman, una herramienta de terminal para monitorizar el uso detallado de VRAM y procesos de IA local."
image: https://www.techpowerup.com/img/Z5eyeNBkqe0RCQw1.jpg
date: 2026-11-10 15:43:18 -0300
categories: [hardware, programacion]
tags: microsoft, gpu, vram, gputaskman, ai, open source, scott hanselman
---

Scott Hanselman, vicepresidente de Microsoft, ha desarrollado [gputaskman](https://github.com/shanselman/gputaskman), una herramienta gratuita y de código abierto diseñada para monitorizar el uso de la memoria de video (VRAM). La aplicación se ejecuta en una ventana de terminal con una interfaz similar a `htop`, listando cada proceso que utiliza la GPU junto con su huella de memoria, la actividad del motor y el entorno de ejecución cargado, como CUDA o Vulkan. Además, cuenta con un panel superior para realizar el seguimiento de la utilización, las frecuencias de reloj, la temperatura y el consumo de energía.

![Interfaz de gputaskman](https://www.techpowerup.com/img/Z5eyeNBkqe0RCQw1.jpg)

Aunque el Administrador de tareas de Windows ha integrado la visualización del uso de la GPU desde 2017, la herramienta de Hanselman busca cubrir un vacío informativo importante. Mientras que el sistema operativo puede indicar que se están utilizando, por ejemplo, 15 GB de memoria de video, no siempre especifica qué aplicaciones o procesos son los responsables de dicho consumo.

## Enfoque en Inteligencia Artificial local

Una de las capacidades más relevantes de este software es su especialización en la monitorización de inteligencia artificial local. El inspector de modelos integrado puede identificar el modelo de lenguaje extenso (LLM) que un proceso tiene cargado, informando sobre su cuantización, sus pesos y el coste estimado del caché KV. Asimismo, los usuarios de plataformas como Ollama y LM Studio obtendrán información precisa sobre el tamaño del contexto y los nombres de los modelos.

El desarrollador ha aclarado que el software se encuentra en una etapa experimental temprana, por lo que los datos detallados sobre la IA deben considerarse como estimaciones. Hanselman [compartió el proyecto en X](https://x.com/shanselman/status/2117419804189741408) la semana pasada, solicitando la colaboración de la comunidad mediante la realización de *pull requests*.