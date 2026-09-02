# ANDROID

## Versiones actuales del proyecto

Verificadas leyendo los ficheros de build del repositorio:

| Elemento | Valor | Fichero |
| --- | --- | --- |
| AGP | 9.4.0 | `gradle/libs.versions.toml` |
| Gradle | 9.6.0 | `gradle/wrapper/gradle-wrapper.properties` |
| Kotlin | 2.2.10 | `gradle/libs.versions.toml` |
| Compose BOM | 2026.02.01 | `gradle/libs.versions.toml` |
| `compileSdk` / `targetSdk` | 37 | `app/build.gradle.kts` |
| `minSdk` | 24 | `app/build.gradle.kts` |
| Toolchain JVM del daemon | 25 | `gradle/gradle-daemon-jvm.properties` |
| `sourceCompatibility` | 11 | `app/build.gradle.kts` |
| `applicationId` / `namespace` | `com.mova.santaclara` | `app/build.gradle.kts` |
| `versionCode` / `versionName` | 1 / 1.0.0 | `app/build.gradle.kts` |

> Los valores de SDK no se inventan: se ajustan a lo que soportan las herramientas y
> dependencias elegidas (Mega Prompt §66). Si una dependencia exige otro nivel, se revisa aquí.

## Entorno de compilación

`local.properties` **no está versionado**. Cada desarrollador lo genera con su `sdk.dir`.
El JDK lo aprovisiona Gradle según `gradle-daemon-jvm.properties` (toolchain 25, resuelto por
el plugin foojay declarado en `settings.gradle.kts`).

## Rendimiento (teléfonos económicos)

- Evitar recomposiciones innecesarias: estados estables, `remember`, claves en listas.
- Imágenes comprimidas y dimensionadas; nunca cargar el original si basta un thumbnail.
- Consultas paginadas; no descargar miles de registros (§34).
- Nada bloqueante en el hilo principal; E/S en `Dispatchers.IO`.
- Sin procesos de red infinitos ni servicios en segundo plano permanentes (§14).

## Accesibilidad

`contentDescription` en todo elemento no textual, tamaños táctiles adecuados, contraste
suficiente, textos legibles, navegación clara y feedback visible de cada acción.

## Permisos

Solo los necesarios (§98). Hoy: `INTERNET`, `ACCESS_NETWORK_STATE`. Cámara cuando se añadan
fotos de perfil/vehículo. **Ubicación no se solicita en V1** (no hay tracking, §45).

## Marca

Icono propio, simple, reconocible y legible a tamaño pequeño. No copiar logos existentes (§99).
Splash con `MOVA` + "Tu ciudad. Tu ruta. Tu movimiento.", sin permanencia innecesaria (§100).
