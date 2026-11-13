---
layout: post
title:  "Tu blog podría ser invulnerable a ataques si usás Jekyll y Cloudflare"
description: "Los ataques están cada vez más frecuentes e inteligentes. La mejor defensa pasiva puede ser no tener base de datos ni aceptar input del usuario, ¿pero como se lleva a cabo un blog así, manteniendose vigente? Pasá que te muestro como \"lo viejo funciona\"."
image: "/assets/posts/como-exponer-un-servicio-o-app-con-nginx-facil-ssl/portada.webp"
date:   2026-11-12 16:45:00 -0300
categories: [programacion]
tags: jekyll, sitio web, sitio estático, no-sql
---

# Preámbulo

En el internet moderno, ningún sitio web está seguro. Increíblemente, este blog con menos de 15 usuarios diarios (que aprovecho a decirles que les agradezco a todos por leerme 😁) también recibe ataques de bots. Hace poco me emocioné porque estaba mirando Cloudflare y vi que tenía visitas de México, y nada más lejos de la realidad:

![Análisis tráfico México]({{ base.url }}/assets/posts/por-que-la-seguridad-de-tu-blog-podria-estar-resuelta-con-jekyll/analisis-trafico-mexico.png)

Si, de México lo único que están llegando son bots