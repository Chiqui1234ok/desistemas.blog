---
layout: post
title: "La actualización 23.5.0 de Nintendo Switch 2 corrige el primer jailbreak basado en software"
description: "La versión 23.5.0 de la consola de Nintendo ha bloqueado el exploit ns2jb, limitando las capacidades de modificación del sistema."
image: https://tpucdn.com/img/lZOZEqLZ9hlVLBcC.jpg
date: 2026-11-10 16:47:37 -0300
categories: [gaming, hardware]
tags: nintendo, switch 2, jailbreak, firmware, exploit
---

La más reciente actualización de software para Nintendo Switch 2, correspondiente a la versión 23.5.0, parece haber neutralizado el funcionamiento de ns2jb, el [primer jailbreak basado exclusivamente en software](https://www.techpowerup.com/354036/nintendo-switch-2-gets-its-first-software-only-jailbreak-with-help-from-openai-codex) para la consola. Según ha informado el dataminer [OatmealDome](https://x.com/OatmealDome/status/2119976839640690818), el exploit de sistema operativo en el que se basaba este método ha sido parcheado, lo que impide la extracción y modificación de juegos a partir de este momento.

No obstante, se ha señalado que podrían existir excepciones menores, como ciertos juegos en formato de cartucho o posibles actualizaciones de software lanzadas en un futuro próximo. Si bien los exploits presentes en títulos específicos, tales como la aplicación de programación SmileBASIC 4 y Civilization VII, siguen operativos, ya no es posible utilizar dichas vulnerabilidades para acceder al resto del sistema operativo. Esto limita el uso de *homebrew* únicamente a las funciones que dichas aplicaciones ya permitían de forma aislada.

## Detalles de la actualización de Nintendo

Las [notas de parche](https://en-americas-support.nintendo.com/app/answers/detail/a_id/68473#current) oficiales de Nintendo no hacen mención explícita a esta corrección de seguridad. Los cambios listados por la compañía se centran en la implementación de opciones de accesibilidad durante la configuración inicial, la preparación de la infraestructura para la gestión de regalos en la eShop dentro de grupos familiares, la incorporación de un nuevo idioma para la función de texto a voz y diversas correcciones generales.

Esta actualización representa el primer cambio significativo en el firmware de la Switch 2 desde la versión 23.0.1, que fue el objetivo del investigador de seguridad Sammy "pepsipu" Hajhamid el pasado 22 de octubre. El exploit mencionado aprovechaba un error de desbordamiento de enteros (*integer overflow*) en SmileBASIC 4, una aplicación de programación de la Switch 1 que es compatible con la nueva generación mediante retrocompatibilidad. Cabe recordar que dicho método requería una conexión constante a un PC y no persistía tras reiniciar el dispositivo, circunstancia que motivó a Nintendo a retirar SmileBASIC 4 de la eShop poco después de su aparición.