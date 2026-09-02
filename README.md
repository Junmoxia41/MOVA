# 🚕 MOVA

**Tu ciudad. Tu ruta. Tu movimiento.**

Plataforma local de movilidad para **Santa Clara, Villa Clara, Cuba**: conecta pasajeros con
conductores independientes para descubrir, contactar, reservar y organizar servicios de
transporte (taxi, triciclo, moto, auto, van y carga).

MOVA **no** es un clon de Uber/Didi/Cabify. La V1 es:
**directorio + reservas + agenda + gestión de conductores + movilidad local**, con
**Offline First** como característica central.

## Stack

| Área | Tecnología |
| --- | --- |
| Plataforma | Android nativo · Android Studio |
| Lenguaje / UI | Kotlin · Jetpack Compose · Material 3 |
| Arquitectura | MVVM + Clean Architecture ligera |
| Local | Room (fuente de verdad de la UI) · DataStore |
| Trabajos | WorkManager |
| Backend | Supabase (PostgreSQL · Auth · Storage · PostgREST) |
| Versiones / CI | Git · GitHub · GitHub Actions |

Prohibido: Flutter, React Native, Ionic, Capacitor, WebView como núcleo. **MOVA es nativa.**

## Estructura

```
app/src/main/java/com/mova/santaclara/
├── core/      common · connectivity · logging · network · security
├── data/      local/{room,dao} · remote/supabase · repository · sync
├── domain/    model · usecase
├── feature/   auth home search driver passenger booking schedule favorites reviews profile admin
├── navigation/
└── MainActivity.kt

supabase/    migrations · seed
docs/        documentación del proyecto
```

## Requisitos

- Android Studio con el JDK y el Android SDK que genera el wrapper de Gradle.
- `compileSdk`/`targetSdk` 37 · `minSdk` 24 · Gradle 9.6.0 · AGP 9.4.0 · Kotlin 2.2.10.
- `local.properties` **no está versionado**: Android Studio lo genera con tu `sdk.dir`.

## Compilar

```bash
./gradlew testDebugUnitTest   # tests unitarios
./gradlew lintDebug           # lint
./gradlew assembleDebug       # APK de depuración
```

## Estado

Consulta **`PROJECT_STATUS.md`** (estado vivo) y **`CHANGELOG.md`** (historial).

## Documentación

| Documento | Contenido |
| --- | --- |
| [`docs/MOVA_SPECIFICATION.md`](docs/MOVA_SPECIFICATION.md) | **Especificación maestra consolidada** |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Capas, flujo de estado, estructura |
| [`docs/ANDROID.md`](docs/ANDROID.md) | Entorno, SDK, rendimiento, accesibilidad |
| [`docs/DATABASE.md`](docs/DATABASE.md) | Room: entidades, DAOs, migraciones |
| [`docs/SUPABASE.md`](docs/SUPABASE.md) | Backend, Auth, RLS, credenciales |
| [`docs/OFFLINE.md`](docs/OFFLINE.md) | Modelo Offline First |
| [`docs/SYNC.md`](docs/SYNC.md) | Sync Engine, cola, reintentos, conflictos |
| [`docs/SECURITY.md`](docs/SECURITY.md) | RLS, Keystore, logging, privacidad |
| [`docs/RELEASE.md`](docs/RELEASE.md) | Versionado, firma, APK/AAB, rollback |
| [`docs/GITHUB.md`](docs/GITHUB.md) | Ramas, commits, Actions |
| [`docs/TESTING.md`](docs/TESTING.md) | Estrategia y pruebas obligatorias |
| [`docs/PRODUCT.md`](docs/PRODUCT.md) | Roles, modelo comercial, alcance |
| [`docs/ADMIN.md`](docs/ADMIN.md) | Panel de administración |
| [`docs/DRIVER.md`](docs/DRIVER.md) | Guía del conductor |
| [`docs/DECISIONS.md`](docs/DECISIONS.md) | Decisiones técnicas registradas |
| [`docs/ROADMAP.md`](docs/ROADMAP.md) | Fases 0–14 |

## Normativa del proyecto

Este repositorio se desarrolla bajo dos documentos vinculantes incluidos en la raíz:

- `Límites de Autonomía del Agente.docx` — qué puede ejecutar el agente y qué requiere
  autorización del propietario. **Tiene prioridad.**
- `MOVA — Mega Prompt Maestro de Desarrollo.docx` — qué se construye y cómo.

Ningún cambio de código, configuración o infraestructura puede contradecirlos.

## Licencia

`PENDIENTE DE DECISIÓN` — el propietario debe definir la licencia.
