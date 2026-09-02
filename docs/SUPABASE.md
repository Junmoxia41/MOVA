# SUPABASE

**Un único proyecto Supabase para la V1**, usado como backend cloud (§19): PostgreSQL, Auth,
Storage y PostgREST. Realtime solo si aporta valor real; Edge Functions solo si son necesarias.

## Coste

Objetivo **coste 0**: plan Free, sin polling continuo, sin realtime innecesario, sin imágenes
gigantes. Si aparece una necesidad de pago se evalúa primero la alternativa gratuita;
**el agente no activa servicios de pago** (Límites §2, Mega §117).

## Esquema

Migraciones en `supabase/migrations/`. Tablas: `profiles`, `drivers`, `vehicles`,
`service_areas`, `driver_availability`, `bookings`, `reviews`, `favorites`, `driver_plans`,
`subscriptions`, `notifications`, `app_config`, `audit_logs`, `sync_metadata` (§23).
Todas con UUID, timestamps, FK, constraints, índices y **RLS**.

## Row Level Security

Obligatoria en toda tabla sensible (§24). Reglas base:

- Conductor: puede modificar **su** perfil; no el de otro.
- Pasajero: accede a **sus** reservas; no a las privadas de otros.
- Admin: administra según permisos definidos en backend.

Sin políticas amplias sin justificación. Ver `SECURITY.md`.

## Autenticación

Supabase Auth con **email/password** en V1; arquitectura preparada para OTP y teléfono (§21).
Nunca se almacenan contraseñas manualmente. La sesión sobrevive al modo offline: el usuario no
queda bloqueado porque el servidor no responda temporalmente (§57).

## Credenciales

| Tipo | Qué es | Dónde va |
| --- | --- | --- |
| **PUBLIC CONFIG** | `SUPABASE_URL`, `SUPABASE_ANON_KEY` | `local.properties` → `BuildConfig` |
| **SECRET CONFIG** | `service_role` key, secretos privados | **Nunca** en el repo ni en la app |

`local.properties` no está versionado. En CI se inyectan por **GitHub Secrets** (§64).
El agente **no inventa** credenciales: si faltan, detiene solo esa tarea y lo reporta
(Límites §3, Mega §120).

## Configuración remota

`app_config` guarda mensajes, planes, promociones, flags, versión recomendada y mantenimiento.
**Nunca se confía en la configuración remota para decisiones de seguridad** (§58).

## Storage

Fotos comprimidas, tamaño limitado, MIME validado, sin duplicados; thumbnails solo si hacen
falta (§70).
