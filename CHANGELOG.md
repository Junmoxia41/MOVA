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
- Pipeline de CI `.github/workflows/android-ci.yml`: tests, lint y APK debug en cada push, con
  reporte de fallos como comentario del commit.

### Changed

- `versionName` de `1.0` a `1.0.0` (esquema `MAJOR.MINOR.PATCH`).
- `applicationId` y `namespace` a `com.mova.app`, decidido por el propietario.

## [1.0.0] — 2026-09-02

### Added

- Especificación consolidada del proyecto en `docs/MOVA_SPECIFICATION.md`.
- Proyecto Android base generado por Android Studio: Kotlin, Jetpack Compose, Material 3.
- Permisos `INTERNET` y `ACCESS_NETWORK_STATE`.

### Changed

- Paquete y `applicationId` de `com.example.mova` a `com.mova.app` (identificador confirmado por el propietario).

### Fixed

- `gradlew` ahora es ejecutable (modo `100755`): se había commiteado con `100644` desde Windows
  y fallaba con `Permission denied` en Linux, macOS y CI.
- `local.properties` dejó de estar versionado: contenía la ruta local del SDK y el propio
  fichero indica que no debe subirse a control de versiones.
