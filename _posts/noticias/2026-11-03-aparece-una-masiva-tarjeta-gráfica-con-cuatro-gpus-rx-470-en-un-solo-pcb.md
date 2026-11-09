---
layout: post
title: "Aparece una masiva tarjeta gráfica con cuatro GPUs RX 470 en un solo PCB"
description: "Se ha descubierto una placa de video de dimensiones colosales que integra cuatro procesadores Polaris, posiblemente diseñada para minería."
image: https://www.techpowerup.com/img/JfIgYwUR5aqXQXfz.jpg
date: 2026-11-03 17:14:45 -0300
categories: [hardware]
tags: amd, rx 470, gpu, hardware, mineria, polaris
---

Un usuario de la plataforma X, bajo el pseudónimo GOK, ha [compartido imágenes](https://x.com/GOKForFree/status/2117551629918785974) de una tarjeta gráfica de dimensiones excepcionales que integra cuatro GPUs de arquitectura Polaris en un único PCB. El dispositivo presenta una disposición de los procesadores en un esquema de 2x2, y cada unidad parece estar rodeada por ocho chips de memoria GDDR5. Esta configuración resultaría en 8 GB de VRAM por cada GPU, alcanzando un total masivo de 32 GB de memoria en toda la placa.

De acuerdo con la información proporcionada por GOK, una etiqueta en el componente identifica el modelo como una quad RX 470, lo que equivaldría a un total de 8.192 procesadores de flujo (stream processors). Para suministrar la energía necesaria a este hardware, la tarjeta cuenta con cuatro conectores de alimentación de 8 pines, mientras que su única salida de video disponible es un puerto HDMI único. En una de las fotografías, el componente aparece junto a una placa base, evidenciando un tamaño significativamente superior al de la propia placa madre.

## Origen y especificaciones técnicas

Aunque el PCB muestra un logotipo de AMD junto a la inscripción "DYII-XQ570 V1.0", existen indicios de que AMD no es el fabricante original. El usuario [señaló](https://x.com/GOKForFree/status/2117565810550116820) que la tarjeta carece de un número de parte (OPN) oficial y que la nomenclatura utilizada no sigue los estándares habituales de la compañía. Este comportamiento es común en fábricas externas en China que suelen incluir logotipos de fabricantes establecidos en sus propios diseños.

Otro detalle técnico relevante es la identificación del switch PCIe como un PI7C9X2G, un componente de tecnología PCIe 2.0. Debido a estas características, se presume que el dispositivo fue fabricado específicamente para la minería de criptomonedas. Hasta el momento, no se han realizado pruebas de funcionamiento debido a la falta de un disipador de calor adecuado para tal magnitud de hardware.

El uso de placas multi-GPU para minería no es un concepto inédito en la industria. Como antecedente, Sapphire lanzó en 2021 una [tarjeta de minería dual con RX 570](https://www.techpowerup.com/285619/sapphire-dual-radeon-rx-570-mining-card-pictured) que ofrecía 16 GB de memoria y un único puerto HDMI.

![Tarjeta gráfica con cuatro GPUs](https://www.techpowerup.com/img/k5TNODNkjqWFHqoU.jpg)
![Vista de la placa base comparativa](https://www.techpowerup.com/img/RlWtPmL5LJ4DiMzH.jpg)