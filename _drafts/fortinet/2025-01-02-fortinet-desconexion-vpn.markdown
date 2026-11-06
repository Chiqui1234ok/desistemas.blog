---
layout: post
title:  "FortiNet • Desconexión VPN"
date:   2025-01-02 23:00:00 +0000
categories: fortinet vpn
tags: fortinet, vpn, problemas de conexión
---

# FortiNet • Desconexión VPN

Sucede que Luisina no puede conectarse a la VPN, o se le desconecta mientras la está usando. Ésto puede ser por micro-cortes (lo obvio), pero también por latencia alta y problemas del WiFi.

# Causas y consecuencias de una mala conexión

## Latencia alta / Timeouts

Por el momento, el caso de Luisina lo ví en profundidad hoy 2024-12-02. Realizando llamadas a la IP 1.1.1.1 vi latencias de 17 a 53ms, pero hubo diversas llamadas con un tiempo de respuesta de 115, 220 y 263ms.

Estimo (ya confirmaré esto cuándo avance el caso) que la VPN soporta latencias de alrededor de 100ms, pero si ya superan por mucho esa cifra, se vuelve problemático.

![La WiFi de Luisina mostró una latencia de 203ms para la descarga y 1551ms para la subida, en un momento dónde hubo problemas con la conexión a la VPN. Si bien el servidor de esta prueba no es el nuestro, es otro ubicado en Buenos Aires]({{ base.url}}/assets/posts/fortinet-desconexion-vpn/image.png)

La WiFi de Luisina mostró una latencia de 203ms para la descarga y 1551ms para la subida, en un momento dónde hubo problemas con la conexión a la VPN. Si bien el servidor de esta prueba no es el nuestro, es otro ubicado en Buenos Aires

## Pérdida de paquetes

Si se pierden paquetes también sufriremos una pérdida de conexión. Sin embargo, es importante aclarar que la pérdida de conexión puede deberse simplemente por una latencia excesivamente alta.

Por el momento, el caso de Luisina no presentó un caso dónde se pierdan paquetes, pero estimo que si es del 1% ya supone la desconexión.

<aside>
💡

Sabemos que 5% de pérdida se traduce en una pésima experiencia en cualquier aplicación/conexión.

</aside>

## Desconexión de la WiFi

Podría tener una mala señal y degradar su enlace de internet, lo que termina en mal rendimiento porque negocia una velocidad mínima.

# Diagnóstico

## Información de la conexión inalámbrica

Con el comando `netsh wlan show wlanreport` (en endpoints Windows), podemos generar un informe de la conexión inalámbrica.

[wlan-report-latest.html](wlan-report-latest.html)

![image.png]({{ base.url}}/assets/posts/fortinet-desconexion-vpn/image%201.png)

Como se puede ver rápidamente en el gráfico, hay muchos errores y desconexiones de la WiFi. Incluso en el medio de la sesión surgieron mensajes como “Network has no connectivity”.

### Enlace

A pesar de que la señal (> 83%) y la tarjeta WiFi (**Intel(R) Wireless-AC 9462**, id **5606d200-9035-4ca0-897a-c4b8cd2ee21e**) ****es buena, la laptop negoció un link de apenas 72,2Mbps para la red de 2,4GHz. Esto se ve con el comando `netsh wlan show all`.

```bash
Velocidad de recepción (Mbps)   : 72.2
Velocidad de transmisión (Mbps) : 72.2
Señal                           : 84% 
Perfil                          : Fibertel WiFi027 2.4GHz
```

La banda de 2,4GHz soporta hasta 600Mbps en WiFi 5 ac (la versión del router Sagemcom F@st 3890 V2 que seguramente tenga), pero no se puede negociar un link mayor a 72,2Mbps, que es lo mínimo del estándar.

![image.png]({{ base.url}}/assets/posts/fortinet-desconexion-vpn/image%202.png)

### **Session Success/Failures**

1. **Successes (0)**:
    - No se registraron conexiones exitosas a la red durante el período analizado.
2. **Failures (9)**:
    - Hubo 9 intentos fallidos de establecer o mantener una conexión Wi-Fi.
3. **Warnings (5)**:
    - Se registraron 5 advertencias, que suelen ser condiciones no críticas pero que indican posibles problemas en la conexión.

### Cambios de capacidad

Hubo varios mensajes sobre la incapacidad de conectarse a internet, por ejemplo el de las 8:56am:

```bash
Cambio de capacidad en {5606d200-9035-4ca0-897a-c4b8cd2ee21e} (0x47008000000000 Familia: V4 Capacidad: Local MotivoDeCambio: PassivePacketHops)
```

### Reconexiones fallidas

También hay un montón de mensajes de “**El servicio de Configuración automática de WLAN no se pudo conectar a una red inalámbrica.”** por ejemplo Luisina se comunicó conmigo a las 13:40, y allí hubo varios intentos de conexión fallidos (este error figura como “**Conexión automática con un perfil**”), porque perdió la señal WiFi.

## Ping

Podemos evaluar si existen paquetes perdidos o latencia alta, realizando un `ping` a nuestra VPN de la siguiente forma:

```bash
ping -n 50 200.68.107.92
```

Si tenemos paquetes con una latencia muy superior a los 100ms, ya sabemos que el endpoint está teniendo un problema de red que compromete la conexión a la VPN.

# Posibles Soluciones

Propongo 3 soluciones, de lo más simple a lo más difícil.

## Activar la auto-reconexión en FortiGate

Creo que ésto no solucionará el problema, primero porque esta no es la causa real y segundo, los problemas de latencia alta y/o micro-cortes pueden durar más de 30 segundos.

No recomiendo implementar esta solución. Si igualmente quieren probar ésto, paso a explicar:

Podemos habilitar la auto-reconexión y ajustar un timeout desde el CLI de FortiGate, de la siguiente manera:

```bash
$ config vpn ssl setting
	# Con el siguiente comando, activamos la re-conexión
  set tunnel-connect-without-reauth enable 
  # Esta opción puede configurarse al habilitar la re-conexión.
  # Por default, son 30 segundos.
  set tunnel-user-session-timeout 30
end
```

Estimo que hará que la conexión sea menos sensible cuándo surjan **pequeños** problemas de conexión.

[Fuente](https://community.fortinet.com/t5/FortiGate/Technical-Tip-Configuring-SSL-VPN-to-allow-tunnel-reconnection/ta-p/220498)

## Endurecer nuestras políticas sobre la red

Como propuesta, la empresa podría entregar junto al equipo de trabajo un cable de red. Esto **debería hacerse con los trabajadores que tienen este problema** de forma recurrente, por lo menos.

![Otros sectores IT de empresas hasta bloquean el WiFi porque consideran imperativo la conexión cableada.]({{ base.url}}/assets/posts/fortinet-desconexion-vpn/image%203.png)

Otros sectores IT de empresas hasta bloquean el WiFi porque consideran imperativo la conexión cableada.

También, el equipo que entregamos se debe utilizar con un router de buena calidad. Usualmente los que utilizan los ISP son de gama hogareña y suficientes para garantizar una buena conexión a internet (siempre hablando de conexión cableada).

### Los ISP a día de hoy (2024-12-02), utilizan estos routers:

| **Telecentro** | Sagemcom Fast 3890 v3 | - |
| --- | --- | --- |
| **Fibertel** | Sagemcom F@st 3890 V2 (¿V2?) | Sagemcom F@st 5657 |
| **Movistar (fibra)** | MitraStar HGU GPT-2541GNAC | Askey HGU RFT3505VW |
| **Claro** | - | - |

## Pedir cambio del ISP

Si nuestro trabajador sigue con problemas con nuestra VPN, y corroboramos que el problema no es nuestro y ya no tenemos opciones, debemos solicitarle que haga el cambio de proveedor de Internet.