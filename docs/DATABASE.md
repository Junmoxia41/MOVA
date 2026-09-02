# BASE DE DATOS LOCAL — ROOM

**Room es la fuente local principal de datos persistentes** (§11). `SharedPreferences` queda
descartado como base de datos; `DataStore` se usa solo para preferencias y flags (§47).

## Entidades previstas

| Entidad | Contenido |
| --- | --- |
| `profiles` | Perfiles de usuario |
| `drivers` | Conductores |
| `vehicles` | Vehículos |
| `service_areas` | Zonas |
| `driver_availability` | Disponibilidad |
| `bookings` | Reservas |
| `reviews` | Reseñas |
| `favorites` | Favoritos |
| `sync_operations` | Cola de sincronización |
| `app_config` | Configuración remota cacheada |

## DAOs

`DriverDao`, `VehicleDao`, `BookingDao`, `ScheduleDao`, `ReviewDao`, `FavoriteDao`,
`SyncOperationDao` — separados, dentro de una única `MovaDatabase` (§48).

## Convenciones

- Clave primaria **UUID** en texto, coherente con Supabase.
- `created_at` / `updated_at` en todas las entidades; `version` donde haya concurrencia.
- `Flow` en las consultas que alimentan la UI.
- Cada entidad con comportamiento offline lleva marca de estado de sincronización
  (`PENDING_SYNC` / `SYNCED` / `FAILED`).

## Migraciones locales

Nunca `fallbackToDestructiveMigration` en release: se pierden datos del usuario.
Las migraciones se escriben y se prueban (§85).

## Relación con Supabase

Ver `SUPABASE.md` para el esquema remoto y `SYNC.md` para cómo se reconcilian ambos.
