# GUÍA DEL CONDUCTOR

## Alta (§115)

```
crear cuenta → crear perfil → seleccionar triciclo/taxi → añadir vehículo
→ configurar horario → recibir reserva → aceptar → completar → recibir valoración
```

El alta definitiva requiere verificación de ADMIN (§38): 🛡️ VERIFICADO.

## Perfil (§27)

`id`, `name`, `photo`, `phone`, `description`, `verification_status`, `active`, `plan_id`,
`rating`, `review_count`, `created_at`, `updated_at`.

## Vehículo (§28)

`id`, `driver_id`, `type`, `brand`, `model`, `color`, `capacity`, `description`, `active`,
timestamps. Tipos: `TAXI · TRICYCLE · MOTORCYCLE · CAR · VAN · CARGO · OTHER`.

## Disponibilidad (§29)

`AVAILABLE · BUSY · OFF_DUTY · UNAVAILABLE`.
**Disponibilidad no es GPS**: es un estado que el conductor declara.

## Mi agenda (§30, §76)

Horario, disponibilidad, reservas, bloqueos y cambios, con vista día y semana:

```
08:00 Disponible
09:30 Reserva
11:00 Disponible
13:00 Reserva
16:00 Disponible
```

Acciones: cambiar disponibilidad, aceptar, rechazar, completar y bloquear horario.

## Reservas (§31, §32)

Al recibir una reserva: detalles → **Aceptar** o **Rechazar**.
Estados: `PENDING · ACCEPTED · REJECTED · CANCELLED · COMPLETED · EXPIRED`.

## Planes (§39)

`FREE · PRO · PREMIUM`. Mejoran visibilidad; **no sustituyen** a la calidad: el ranking es
equilibrado y los conductores gratuitos no desaparecen (§80).

## Offline

Los cambios de disponibilidad y agenda hechos sin conexión quedan en cola y se sincronizan al
recuperar la señal. Ver `OFFLINE.md`.
