---
layout: post
title: "Discord reconstruye su aplicación con Rust: el nuevo cliente consume solo 290 MB de RAM"
description: "El proyecto 'Discord Phoenix' abandona Electron para optimizar el rendimiento y la velocidad de respuesta en escritorio y móviles."
image: https://www.techpowerup.com/img/7eH3cdYrzhdh93b2.jpg
date: 2026-11-06 17:30:17 -0300
categories: [programacion, gaming]
tags: discord, rust, electron, optimización, software, gpui
---

Discord se encuentra reescribiendo su aplicación de escritorio utilizando el lenguaje de programación Rust, lo que supone el abandono de la arquitectura basada en Electron. Los primeros datos de rendimiento resultan sumamente prometedores. El cofundador y CTO de Discord, Stanislav Vishnevskiy, compartió [una captura de pantalla del Administrador de tareas](https://x.com/svishnevskiy/status/2118081920194203799) en X, donde se observa que el nuevo cliente, denominado "Discord Phoenix", utiliza únicamente 290,2 MB de memoria RAM.

Para contextualizar este avance, en la misma imagen se aprecia que el WebHelper de Steam consume 856 MB y Battle.net utiliza 344 MB. Esta cifra representa una reducción significativa frente a las versiones anteriores; a finales del año pasado, Discord informó que su cliente para Windows solía mantenerse por debajo de 1 GB de uso de RAM, llegando incluso a implementar un reinicio automático cuando el consumo superaba los 4 GB. Asimismo, Vishnevskiy presentó [un clip comparativo](https://x.com/svishnevskiy/status/2118398632236073156) que demuestra una velocidad de arranque superior y una navegación mucho más ágil e instantánea.

## Evolución hacia arquitecturas nativas

La optimización no se limitará al escritorio. Según Vishnevskiy, las aplicaciones móviles también recibirán una actualización estructural mediante la eliminación de React Native. Esto permitirá que las versiones móviles mantengan una interfaz nativa mientras comparten el código base con el cliente de escritorio a través de Rust.

En lugar de utilizar Tauri, como se había especulado anteriormente, el nuevo cliente está construido sobre GPUI, el marco de trabajo de interfaz de usuario escrito en Rust desarrollado por el equipo responsable del editor de código Zed. Aunque todavía no se ha confirmado una fecha de lanzamiento oficial, Discord ha manifestado su intención de iniciar las pruebas con usuarios en un futuro próximo.

![Rendimiento de Discord Phoenix](https://www.techpowerup.com/img/7eH3cdYrzhdh93b2.jpg)

![Interfaz de la nueva aplicación](https://www.techpowerup.com/img/fez4MvdaRXVg00BC.jpg)