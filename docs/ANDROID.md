# MOVA — Documentación Android

> Regla de verificación (§111): no se afirma que compila sin haberlo compilado.
> En el sandbox del agente se verificó que **los plugins resuelven y la configuración
> Gradle es válida** (`gradlew help` → `BUILD SUCCESSFUL`), y que el paso de compilación
> Kotlin se ejecuta correctamente. El sandbox tiene ~1.9 GB de RAM y el daemon de Gradle
> puede ser eliminado por OOM durante el build; por ello la compilación/empaquetado final
> del APK debe confirmarse en **Android Studio** desde el repositorio.

## Configuración actual

| Elemento | Valor |
|---|---|
| Gradle | `9.6.0` (wrapper) |
| Android Gradle Plugin | `9.4.0` |
| Kotlin | `2.2.10` |
| JDK (requerido por AGP 9.4) | `17` (mínimo; el daemon usa toolchain `25`) |
| JDK (bytecode source/target) | `17` |
| SDK Build Tools | `36.0.0` (default de AGP 9.4) |
| Platform SDK | `platforms;android-37.0` (id del paquete; corresponde a `compileSdk 37`) |
| Compose BOM | `2026.02.01` |
| Material3 | estable (vía BOM; actualmente `1.4.0`) |
| Navigation Compose | `2.9.8` |
| `compileSdk` / `targetSdk` | `37` |
| `minSdk` | `24` |
| Paquete | `com.mova.santaclara` |
| `versionCode` / `versionName` | `1` / `1.0.0` |

> Las versiones se fijaron verificando la documentación vigente (Android Developers) y los metadatos de `dl.google.com/android/repository`. **AGP 9.4 incluye soporte de Kotlin integrado**: no hay que aplicar el plugin `org.jetbrains.kotlin.android` (aplicarlo produce el error `Cannot add extension with name 'kotlin'`). Solo se aplican `android-application` + `kotlin-compose`.
> Antes de cada release, re-verificar que siguen siendo válidas (sección 66/105 del Mega Prompt).

## Estructura de paquetes

```text
com/mova/santaclara/
├── core/            # común, red, conectividad, logging, seguridad
├── data/            # (en Fase 2) room, dao, supabase, repository, sync
├── domain/          # (en Fase 2) model, usecase
├── feature/         # splash, home, search, driver, passenger, booking, ...
├── navigation/      # MovaDestinations, MovaNavGraph
├── ui/theme/        # Color, Type, Theme
└── MainActivity.kt
```

## Cómo compilar / verificar

1. Abrir el proyecto en **Android Studio** (versión compatible con AGP 9.4.0).
2. `File → Sync Project with Gradle Files`.
3. Ejecutar `./gradlew assembleDebug` para generar el APK de depuración.
4. Ejecutar `./gradlew test` para los tests unitarios.
5. (Opcional) `./gradlew lint`.

## Nota sobre credenciales (Mega Prompt §22)

Las apps Android no reciben variables de entorno como una app web. Las credenciales
públicas de Supabase (project URL + anon key) deben inyectarse mediante una estrategia
de build/configuración propia (build flavors, `BuildConfig`, o `local.properties`
ignorado por Git). En esta fase quedan definidas como constantes vacías en
`core/network/ApiConfig.kt` — **PENDIENTE DE DECISIÓN**.
