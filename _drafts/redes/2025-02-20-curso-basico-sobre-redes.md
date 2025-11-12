---
layout: post
title:  "Redes para principiantes"
date:   2025-02-20 13:00:00 +0000
tags: guía, kubernetes, micro servicios, openwrt, vlan, redes, network, networking
---

# Preámbulo

Hoy en retrospectiva, garantizo que esta guía se asegura de enseñar lo básico de redes (que no es poco), para que el lector no se pierda cuándo estudie cosas de más alto nivel, como por ejemplo:
- Sistemas operativos de routing y firewall
- Docker / ContainerD / Portman
- Kubernetes

Comencemos.

# ¿Qué es una red?

Una red computacional es un conjunto de dos o más computadoras que pueden compartir datos entre sí mediante una conexión.

## Concepto de conexión

Cuándo se conecta un pendrive a un equipo, no se sabe de dónde provienen los datos de esta unidad de almacenamiento, porque no hay conexión entre estas computadoras a través de la red.

La conexión típica de una red es vía cable, dónde se pueden distinguir dos grupos de conectores:

| Conector | Imagen |
|----------|--------|
| RJ-45: es el conector típico en todos los motherboards domésticos y de alta performance ([imágen](https://www.asrock.com/mb/photo/Fatal1ty%20X399%20Professional%20Gaming(L5).png)). Su versión "Cat6" garantiza hasta 100 metros de largo de cable sin degradación de la señal, manteniendo la velocidad de su especificación y con una conexión estable     | ![Ficha RJ-45]({{ base.url }}/assets/posts/curso-basico-sobre-redes/ficha-rj-45.png) |
| SFP: es un conector para conexiones de alta velocidad y estabilidad. Su cable suele ser de fibra óptica, y esto le da 10km de alcance. También tiene versiones que soportan soportan mayor velocidad (entre 10 y 40 veces más que el cable Cat5e que suelen tener los RJ-45)      | ![Ficha SFP]({{ base.url }}/assets/posts/curso-basico-sobre-redes/ficha-sfp.png) |

# Switch

