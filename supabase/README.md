# Supabase — esquema y migraciones

## Contenido

```
supabase/
├── migrations/   0001 → 0007, en orden. Fuente de verdad del esquema.
└── seed/         Datos de desarrollo. NUNCA contra producción (Límites §5).
```

Las 14 tablas del Mega Prompt §23, todas con UUID, timestamps, foreign keys, constraints,
índices y **Row Level Security** (§24).

## Dónde están las credenciales

`secrets.properties` en la raíz del repositorio, **no versionado** (`.gitignore`).
Contiene `SUPABASE_URL` y `SUPABASE_ANON_KEY`: configuración **pública** de cliente
(clave `sb_publishable_…`, viaja dentro del APK y está protegida por RLS).

La `service_role` key y cualquier secreto privado **no van ahí ni en la app** (§22).

## Aplicar las migraciones

### Opción A — GitHub Actions (recomendada)

Añade el secret `SUPABASE_DB_URL` en *Settings → Secrets and variables → Actions* con la
connection string de *Settings → Database → Connection string (URI)*.

Luego: *Actions → Android CI → Run workflow → marca `apply_migrations` → Run*.

Es **manual a propósito**: escribir DDL en una base real nunca debe dispararse solo
(Límites §5 y §6). Cada fichero se aplica con `ON_ERROR_STOP=1` y en una sola transacción;
si uno falla, se detiene ahí y publica el error como comentario del commit.

### Opción B — SQL Editor de Supabase

Abre *SQL Editor* y ejecuta los ficheros **en orden**: `0001`, `0002`, `0003`, `0004`,
`0005`, `0006`, `0007`. Son idempotentes donde es seguro (`create table if not exists`,
`create or replace function`, `drop policy if exists` + `create policy`).

## Seed

`seed/0001_dev_seed.sql` — zonas de Santa Clara y planes. Los precios son **0 a propósito**:
el precio real es decisión del propietario (Límites §8).

Solo contra **desarrollo**. Antes de ejecutarlo, confirma el entorno (Límites §6).

## Estado

| Comprobación | Estado |
| --- | --- |
| Ficheros escritos y revisados | ✅ 14/14 tablas, 14/14 con RLS, 0 funciones usadas antes de definirse |
| Ejecutados contra una base real | ❌ **Todavía no** |

La revisión fue **estática**, no una ejecución. El entorno de desarrollo no alcanza
`*.supabase.co` (el proxy TLS del sandbox corta el handshake) ni el puerto 5432.
La primera ejecución real dirá si algo falla.
