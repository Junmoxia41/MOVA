# Changelog

Formato basado en Keep a Changelog. Versionado: `MAJOR.MINOR.PATCH` (Mega Prompt §61).

## [Unreleased]

### Added

- `.gitignore` completo (entorno local, keystore, secretos, builds).
- Línea base de documentación: `README.md`, `PROJECT_STATUS.md`, `CHANGELOG.md` y
  `docs/` (ARCHITECTURE, ANDROID, DATABASE, SUPABASE, OFFLINE, SYNC, SECURITY, RELEASE,
  GITHUB, TESTING, PRODUCT, ADMIN, DRIVER, DECISIONS, ROADMAP).
- Migraciones iniciales de Supabase con Row Level Security en `supabase/migrations/`.
- Seeds de desarrollo en `supabase/seed/`.

### Changed

- `versionName` de `1.0` a `1.0.0` (esquema `MAJOR.MINOR.PATCH`).

## [1.0.0] — 2026-09-02

### Added

- Especificación consolidada del proyecto en `docs/MOVA_SPECIFICATION.md`.
- Proyecto Android base generado por Android Studio: Kotlin, Jetpack Compose, Material 3.
- Permisos `INTERNET` y `ACCESS_NETWORK_STATE`.

### Changed

- Paquete y `applicationId` de `com.example.mova` a `com.mova.santaclara`.

### Fixed

- `local.properties` dejó de estar versionado: contenía la ruta local del SDK y el propio
  fichero indica que no debe subirse a control de versiones.
