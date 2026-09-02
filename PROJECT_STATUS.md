# MOVA STATUS

## Estado
Fase 1 — Bootstrap. El esqueleto del proyecto Android nativo está creado. Aún sin backend ni funcionalidades de negocio.

## Completado
- Especificación consolidada (`docs/MOVA_SPECIFICATION.md`).
- Proyecto Android configurado (Kotlin + Compose, `com.mova.santaclara`).
- Navegación Compose base (Splash → Home).
- Tema MOVA + pantallas Splash y Home.
- Scaffolding de capa `core`.
- `.gitignore` + `local.properties` fuera de control de versiones.

## En desarrollo
- (nada en curso activamente)

## Pendiente
- Fase 0/1 restante: definir estrategia de `develop`/ramas si aplica.
- Fase 2 — Data (Room, entidades, DAOs, repositorios, Supabase, migraciones, RLS).
- Confirmación de build en Android Studio (no verificable en sandbox).

## Problemas conocidos
- El entorno de compilación del agente no dispone de Android SDK; la compilación debe confirmarse en Android Studio.
- No hay credenciales de Supabase aún (project URL + anon key) — aportadas por el propietario.

## Próxima fase
Fase 2 — Data: Room + entidades + DAOs + repositorios + estructura Supabase (migraciones, RLS y seeds de desarrollo).
