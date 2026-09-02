# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/).

## [Unreleased]

### Fixed
- Configuración de build Android inválida en `app/build.gradle.kts`. Reemplazada la DSL
  inexistente (`compileSdk { version = release(37) }`, `optimization { enable = false }`)
  por la DSL válida de AGP 9.4 (`compileSdk = 37`, `isMinifyEnabled = false`).
- Alineado el target JVM a `17` (AGP 9.4 requiere JDK >= 17).
- No se aplica el plugin `org.jetbrains.kotlin.android`: AGP 9.4 ya incluye Kotlin
  integrado; aplicarlo causaba `Cannot add extension with name 'kotlin'`.

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
