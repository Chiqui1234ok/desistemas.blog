---
layout: post
title: "Filtración revela detalles del SoC Intel Core Ultra 4000 'Nova Lake-H'"
description: "Se han filtrado imágenes del nuevo SoC Nova Lake-H de Intel, mostrando su arquitectura basada en el nodo de fabricación Intel 18A."
image: https://tpucdn.com/img/WKqSVzVB8ia7exq9.jpg
date: 2026-11-05 14:39:20 -0300
categories: [hardware, analisis]
tags: intel, nova lake, core ultra, hardware, soc, 18a
---

El SoC "Nova Lake-H", perteneciente a la serie Intel Core Ultra 4000, ha salido a la luz mediante una reciente filtración. Esta representa la segunda ocasión en la que el componente aparece en público, aunque en esta oportunidad se presenta únicamente a través de una imagen en bruto de baja resolución y sin [anotaciones de terceros](https://www.techpowerup.com/353791/intel-nova-lake-hx-and-nova-lake-h-die-shots-appear).

Esta variante presenta una configuración de núcleos 4+8+4, integrada por 4 núcleos de rendimiento (P-Cores), 8 núcleos de eficiencia (E-Cores) y 4 núcleos de bajo consumo (LPE-Cores). El conjunto se basa en una [matriz de cómputo fabricada con la tecnología Intel 18A-P](https://www.techpowerup.com/354311/intel-confirms-nova-lake-uses-18a-p-internal-node-more-details-at-ces). El paquete tiene unas dimensiones aproximadas de 12x23 mm, lo que resulta en un área total de 276 mm², incluyendo tanto matrices funcionales como matrices de relleno (dummy dies).

## Desglose de la arquitectura del SoC

La estructura del chip se compone de diversos elementos especializados:

*   **Matriz de gráficos:** Fabricada con el nodo Intel 3-E, integra 4 núcleos de GPU Xe y cubre aproximadamente 26 mm².
*   **Matriz de relleno:** Un componente de 21 mm² destinado a asegurar la integridad estructural del paquete.
*   **Matriz central de LPE:** Un bloque de 72 mm² basado en el nodo Intel 18A-P que alberga los 4 núcleos LPE y actúa como eje central del SoC.
*   **Matriz de control periférico:** Un componente de silicio de 58 mm², también fabricado bajo el nodo Intel 18A-P.
*   **Matriz de cómputo:** Esta sección alberga la configuración de 4 P-Cores y 8 E-Cores mediante el proceso Intel 18A-P, ocupando un área de 55 mm².

![Imagen del SoC Nova Lake-H](https://tpucdn.com/img/WKqSVzVB8ia7exq9.jpg)

![Detalle de la arquitectura del chip](https://tpucdn.com/img/dVP8EnR7MSzKVqWK.jpg)