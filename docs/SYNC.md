# SINCRONIZACIÓN

## Sync Engine

Cola local persistente en Room. Entidad `sync_operations` (§15):

| Campo | Tipo |
| --- | --- |
| `id` | UUID |
| `entity` | texto (driver, booking, favorite…) |
| `entity_id` | UUID |
| `operation` | INSERT / UPDATE / DELETE |
| `payload` | JSON |
| `created_at` | timestamp |
| `status` | PENDING / PROCESSING / SYNCED / FAILED / CONFLICT |
| `retry_count` | entero |
| `last_attempt_at` | timestamp |
| `last_error` | texto |

## Flujos (§16)

Con conectividad:

```
Internet disponible → WorkManager → SyncWorker → leer PENDING → procesar
→ enviar a Supabase → respuesta → actualizar Room → SYNCED
```

Sin conectividad:

```
guardar localmente → PENDING → esperar conectividad
```

## Reintentos (§17)

Backoff creciente; **no bombardear Supabase** (plan Free, §20).

| Situación | Resultado |
| --- | --- |
| Error temporal / red | `retry` con backoff |
| Error permanente (4xx de validación) | `FAILED` |
| Conflicto de versión | `CONFLICT` |

El usuario **nunca** pierde una operación por quedarse sin Internet.

## Conflictos (§18)

La arquitectura se diseña para conflictos, no los ignora. Se usan `updated_at`, `version`,
`operation id` y timestamps. **No se sobrescriben datos en silencio**: ante un conflicto
importante se registra, se preserva la información, se resuelve según reglas y se evita pérdida.

Estrategia prevista: *last-write-wins* por `version` para campos de perfil, y conservación de
ambas versiones para reservas (decisión detallada cuando exista el esquema aplicado —
ver `DECISIONS.md`).

## WorkManager (§14)

Trabajos persistentes para: sincronización pendiente, reintentos, operaciones diferibles y
mantenimiento local. Sin procesos de red infinitos ni servicios permanentes.

## Pruebas obligatorias (§86)

Online · offline · crear reserva offline · cerrar app · abrir app · volver online ·
WorkManager · Supabase responde · Supabase no responde · reintento · conflicto.
