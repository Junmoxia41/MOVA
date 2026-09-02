# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/).

## [1.0.0]

### Added
- Proyecto Android nativo (Kotlin + Jetpack Compose) bajo paquete `com.mova.santaclara`.
- Navegación Compose (`navigation-compose 2.9.8`) con grafo base: Splash → Home.
- Pantalla de Splash con identidad provisional MOVA.
- Pantalla principal (Home) con acciones: Buscar transporte, Mis reservas, Favoritos, Mi cuenta.
- Scaffolding de capa `core`: logging, conectividad, resultado común, seguridad, red.
- Tema MOVA con paleta de color provisional.
- `.gitignore` (incluye `local.properties`, keystores, `.env`); `local.properties` retirado del control de versiones.
- Especificación consolidada `docs/MOVA_SPECIFICATION.md`.

### Changed
- Renombrado del paquete `com.example.mova` → `com.mova.santaclara`.
- `versionName` de `1.0` a `1.0.0`.

### Notes
- La verificación del build debe realizarse en **Android Studio** (el entorno de compilación del agente no incluye Android SDK). Ver `docs/ANDROID.md`.
