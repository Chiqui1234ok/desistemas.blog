---
layout: post
title: "HWiNFO introduce un servidor REST API para monitorizar sensores desde cualquier dispositivo"
description: "La nueva versión beta de HWiNFO permite visualizar datos de hardware en tiempo real a través de la red local mediante un servidor web integrado."
image: assets/news/2026-11-23-hwinfo-introduce-un-servidor-rest-api-para-monitorizar-sensores-desde-cualquier-dispositivo/teL0cXuuXV4wcTYj.webp
date: 2026-11-23 17:48:09 -0300
categories: [hardware]
tags: hwinfo, api, hardware, monitoreo, sensores, beta
---

HWiNFO ha lanzado la [versión 8.61 Beta](https://www.hwinfo.com/forum/threads/hwinfo-v8-61-6125-beta-released.11401/) (build 6125), la cual incorpora un [servidor REST API](https://www.hwinfo.com/forum/threads/hwinfo-rest-api-local-web-server.11402/) integrado. Esta nueva funcionalidad permite que todos los sensores monitorizados se distribuyan en formato JSON a través de protocolos HTTP o HTTPS, incluyendo detalles técnicos como unidades de medida, descripciones y agrupaciones de sensores.

Gracias a esta implementación, las lecturas de HWiNFO pueden consultarse mediante un navegador web en cualquier dispositivo conectado a la red local, incluyendo teléfonos inteligentes y tabletas. Esta mejora incrementa significativamente la comodidad para los usuarios que requieren supervisar las estadísticas de su hardware de forma constante sin necesidad de estar frente al ordenador.

## Recursos y configuración del servicio

Para apoyar esta nueva característica, HWiNFO ha publicado un [paquete en GitHub](https://github.com/malikm/HWiNFO/tree/main/sensors/rest_api) que contiene una guía de la API, paneles de control (dashboards) de ejemplo y material para la creación de interfaces mediante agentes de IA.

Para configurar el servicio, los usuarios deben dirigirse a la ventana de "Sensors", donde un nuevo botón denominado "Remote Center" permite abrir el panel de la API. Desde allí, es posible seleccionar la dirección IP y el puerto, elegir el uso de HTTPS e iniciar el servidor. Aunque se incluye un panel predefinido basado en la interfaz de sensores, el sistema permite la creación de páginas personalizadas.

![Interfaz de monitoreo de HWiNFO]({{ base.url }}/assets/news/2026-11-23-hwinfo-introduce-un-servidor-rest-api-para-monitorizar-sensores-desde-cualquier-dispositivo/teL0cXuuXV4wcTYj.webp)

## Limitaciones y medidas de seguridad

En la versión sin licencia, el servidor REST API tiene un límite de funcionamiento de 12 horas. Esta restricción coincide con las limitaciones de la versión gratuita para el soporte de memoria compartida (Shared Memory) y el monitoreo remoto de sensores. Los usuarios que requieran un uso extendido pueden acceder a todas las capacidades mediante la adquisición de HWiNFO Pro.

En cuanto a la seguridad, el equipo de HWiNFO recomienda operar el servidor únicamente dentro de redes de confianza para garantizar la integridad de la información.

![Detalles técnicos de los sensores]({{ base.url }}/assets/news/2026-11-23-hwinfo-introduce-un-servidor-rest-api-para-monitorizar-sensores-desde-cualquier-dispositivo/8oauk7Juem0vhhDg.webp)