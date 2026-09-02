# OFFLINE FIRST

Es una característica central, no un añadido (§10).

```
LOCAL FIRST → CLOUD SYNC
```

## Contrato

Sin conexión, MOVA **sigue funcionando**: abre, muestra lo almacenado, permite consultar
información, ver reservas y agenda, modificar operaciones permitidas, registrar cambios y
**encolar lo pendiente**.

## Fuente de verdad

**Room es la fuente de verdad de la UI** para toda entidad con comportamiento offline (§12):

```
Supabase → Sync → Room → ViewModel → Compose
```

La UI no depende de que cada pantalla consulte Supabase.

## Estados de conectividad (§52)

`ONLINE` · `OFFLINE` · `SYNCING` · `SYNC_ERROR`

La app **nunca se bloquea** por estar offline. El indicador es discreto: 🟠 *Sin conexión* (§53).

## Marcadores de sincronización (§33)

| Estado | Indicador |
| --- | --- |
| Pendiente de sincronizar | 🟠 Pendiente de sincronización |
| Sincronizada | 🟢 Sincronizada |
| Fallida | 🔴 No sincronizada (la información se conserva) |

## Qué funciona sin conexión ni autenticación (§96)

| Acción | Offline | Sin cuenta |
| --- | --- | --- |
| Explorar perfiles públicos (caché) | Sí | Sí |
| Buscar por tipo/zona sobre datos cacheados | Sí | Sí |
| Llamar a un conductor | Sí | Sí |
| Crear una reserva | Sí, queda `PENDING_SYNC` | No |
| Ver mis reservas / historial | Sí, desde Room | No |
| **Confirmación real del conductor** | **No: requiere sincronización** | No |

Estas diferencias no se improvisan: están analizadas y documentadas a propósito.

## Prueba de apagón (§87)

```
usuario crea operación sin Internet → guardada → teléfono apagado → encendido
→ Room intacto → vuelve Internet → WorkManager → Sync   ⇒  no se pierde nada
```
