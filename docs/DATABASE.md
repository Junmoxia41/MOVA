# BASE DE DATOS LOCAL — ROOM

**Room es la fuente local principal de datos persistentes** (§11). `SharedPreferences` queda
descartado como base de datos; `DataStore` se usa solo para preferencias y flags (§47).

## Estado actual

Implementado y **verificado en CI**: `DriverEntity` + `DriverDao` + `MovaDatabase` (versión 1,
esquema exportado a `app/schemas`). El resto de entidades está previsto abajo.

Configuración real (`gradle/libs.versions.toml`): Room `3.0.2` (`androidx.room3`),
KSP `2.3.11`, `androidx.sqlite:sqlite-bundled` `2.7.0`. Room 3 exige KSP y un `SQLiteDriver`;
se usa el bundled para tener la misma versión de SQLite en todos los dispositivos (§88).

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

`exportSchema = true` y `ksp { arg("room.schemaLocation", "$projectDir/schemas") }` guardan el
esquema versionado en `app/schemas/`, que es lo que permite probar migraciones después.

## Relación con Supabase

Ver `SUPABASE.md` para el esquema remoto y `SYNC.md` para cómo se reconcilian ambos.
