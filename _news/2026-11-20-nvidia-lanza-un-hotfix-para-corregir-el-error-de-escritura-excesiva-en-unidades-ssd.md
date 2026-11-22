---
layout: post
title: "NVIDIA lanza un hotfix para corregir el error de escritura excesiva en unidades SSD"
description: "NVIDIA publica el controlador GeForce Hotfix 621.35 para detener el proceso que causaba escrituras masivas en SSD durante periodos de inactividad."
image: https://tpucdn.com/img/1Se6PYMg42pnjKvV.jpg
date: 2026-11-20 20:50:50 -0300
categories: [hardware]
tags: nvidia, geforce, ssd, driver, hotfix, bug
---

NVIDIA ha publicado oficialmente el controlador [GeForce Hotfix 621.35](https://nvidia.custhelp.com/app/answers/detail/a_id/5940/~/geforce-hotfix-display-driver-version-621.35) con el objetivo de solucionar un error crítico que afectaba el rendimiento y la vida útil de las unidades de estado sólido (SSD). Esta actualización aborda específicamente un problema de escritura excesiva en el archivo `nvlog.nvlgstg` que ocurría de forma recurrente en segundo plano.

El fallo, detectado recientemente en los controladores versiones 621.14 y 621.24, provocaba que el proceso `NVDisplayContainer.exe` realizara operaciones de escritura constantes incluso cuando el sistema se encontraba en estado de inactividad. Según informes técnicos, este comportamiento podía alcanzar cifras alarmantes de hasta 30 GB de escritura por hora, un incremento drástico comparado con los aproximadamente 2 MB registrados en periodos de inactividad del controlador 621.01.

## Detalles del Hotfix y recomendaciones

Este parche se basa en el controlador Game Ready más reciente (versión 621.24 del 12 de noviembre). Al tratarse de un "hotfix", se trata de una descarga opcional disponible exclusivamente a través del sitio de atención al cliente de NVIDIA, ya que ha pasado por un proceso de control de calidad acelerado.

Hasta la llegada de esta solución, las alternativas para los usuarios afectados consistían en realizar un rollback a la versión 621.01 o detener temporalmente el servicio *NVIDIA Display Container LS*. Se recomienda a los usuarios que experimenten este problema instalar el hotfix lo antes posible, mientras que el resto de la comunidad puede optar por esperar a la próxima actualización con certificación WHQL.

Es pertinente señalar que esta situación ha sido recurrente en la industria, dado que AMD reportó un [error similar en sus controladores Radeon](https://www.techpowerup.com/354605/amd-confirms-excessive-ssd-writes-in-radeon-drivers-fix-coming-with-adrenalin-26-11-1) apenas unos días antes, lo que también obligó a la compañía a lanzar [controladores Adrenalin opcionales](https://www.techpowerup.com/354756/amd-patches-radeon-ssd-write-bug-in-adrenalin-26-11-1-optional-driver) para mitigar el impacto en los dispositivos de almacenamiento.

![Error de escritura en SSD de NVIDIA](https://tpucdn.com/img/Mx8qGr9HVmwa3OJq.jpg)