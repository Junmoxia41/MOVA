# PRODUCTO

## Propuesta

MOVA conecta pasajeros con **conductores independientes** en Santa Clara (Cuba) para descubrir,
contactar, reservar y organizar transporte. No es un clon de Uber/Didi/Cabify.

V1 = **directorio + reservas + agenda + gestión de conductores + movilidad local**.

## Servicios

🚕 Taxi · 🛺 Triciclo · 🏍️ Moto · 🚗 Auto · 🚐 Van · 📦 Carga ·
🚐 Viajes programados · 🛣️ Viajes intermunicipales

## Roles (§26)

| Rol | Puede |
| --- | --- |
| VISITANTE | Explorar, buscar, ver perfiles públicos, ver vehículos, consultar zonas, llamar |
| PASAJERO | Reservar, cancelar, favoritos, historial, reseñas, perfil |
| CONDUCTOR | Perfil, vehículo, disponibilidad, agenda, reservas, estadísticas |
| ADMIN | Aprobar/suspender conductores, usuarios, planes, reseñas, zonas, configuración, métricas |

El visitante **no está obligado a crear cuenta**: la autenticación se pide solo cuando una
función la necesita (§73).

## Geografía (§78, §79)

V1: **Santa Clara**, con zonas, calles, puntos de referencia y direcciones escritas.
**Sin GPS.** Modelo preparado para Provincia → Municipio → Ciudad → Zona y para expandir a
Camajuaní, Remedios, Caibarién, Placetas, Ranchuelo…

## Modelo comercial (§40, §41)

- Gratuito para pasajeros.
- Conductores pagan por **visibilidad / suscripción** (planes FREE · PRO · PREMIUM).
- **Sin comisión obligatoria por viaje en V1.**
- Precios **nunca hardcodeados**: se configuran en Supabase.
- Sin pasarela de pago compleja al inicio; solo se registran
  `subscription, status, amount, currency, start_date, end_date, payment_reference`.

> Los precios, la moneda, las comisiones y las condiciones son **decisión del propietario**
> (Límites §8). El agente implementa el mecanismo configurable, no el modelo de negocio.

## Ranking (§35, §80)

Verificación, disponibilidad, calidad del perfil, valoración, actividad, plan y distancia
futura. **El dinero no es el único factor** y los conductores gratuitos no desaparecen:
reglas de distribución equilibradas.

## Meta de adopción (§116)

**5 conductores → 20 → 50+**, recogiendo feedback real en Santa Clara antes de expandir.
