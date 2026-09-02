# DECISIONES TÉCNICAS

Registro de decisiones relevantes (Mega Prompt §104). Formato: contexto → decisión →
consecuencias. Las decisiones de producto y negocio **no** están aquí: son del propietario
(Límites §8).

---

## D-001 — Paquete `com.mova.app`  ✅ decidida por el propietario

- **Contexto**: la plantilla usaba `com.example.mova`. El Mega Prompt §8 propone
  `com.mova.santaclara` como ejemplo de estructura.
- **Decisión**: `namespace` y `applicationId` = **`com.mova.app`**, estructura
  `app/src/main/java/com/mova/app/`.
- **Motivo**: `com.example.*` está reservado por Google y no es publicable en Play. El
  propietario eligió `com.mova.app` frente a `com.mova.santaclara` (2026-09-02): deja el
  identificador libre del nombre de la primera ciudad, coherente con la expansión a otros
  municipios prevista en §78.
- **Cierre**: resuelve el conflicto **C11** y la decisión pendiente **D3** de la especificación.
- **Verificado**: compila en GitHub Actions (rename completo, incluidos los tests que
  comprueban `appContext.packageName`).

## D-002 — Versión de Room: **Room 3.0.x** (`androidx.room3`)

- **Contexto**: la documentación oficial vigente (consultada el 2026-09-02) muestra dos líneas:
  **Room 3.0.2** (`androidx.room3:room3-runtime`, KSP obligatorio, APIs basadas en corrutinas,
  requiere un `SQLiteDriver` como `androidx.sqlite:sqlite-bundled`) y **Room 2.8.x**
  (`androidx.room`, en modo mantenimiento con parches).
- **Decisión**: **Room 3.0.2** (`androidx.room3:room3-runtime` + KSP `room3-compiler` +
  `androidx.sqlite:sqlite-bundled` 2.7.0).
- **Motivo**: es la línea estable vigente según la documentación oficial (Room 2.x está en modo
  mantenimiento) y §105 exige no asumir versiones antiguas. El riesgo de adoptar una major nueva
  sin poder compilar en local desapareció al estar operativo GitHub Actions: cualquier error de
  API se detecta en el push.
- **Estado**: **implementada y verificada**. Run `33655788145`: compila, pasa lint y genera un
  APK de 13 936 422 bytes (el incremento frente a 11,25 MB es el SQLite bundled empaquetado).

## D-010 — KSP 2.3.11 con el built-in Kotlin de AGP 9

- **Contexto**: AGP 9.4 incorpora Kotlin integrado; por eso la plantilla de Android Studio no
  aplica `org.jetbrains.kotlin.android`. KSP `2.2.10-2.0.2` registra sus fuentes generadas vía
  `kotlin.sourceSets`, que el built-in Kotlin rechaza.
- **Error real** (CI run `33655481183`): `EvalIssueException: Using kotlin.sourceSets DSL to add
  Kotlin sources is not allowed with built-in Kotlin`.
- **Decisión**: **KSP 2.3.11**. La línea 2.3.x está desacoplada de la versión de Kotlin y corrige
  la detección de built-in Kotlin (google/ksp #2729, #2772).
- **Descartado**: `android.disallowKotlinSourceSets=false` en `gradle.properties`. Es un
  supresor del error, no una corrección, y está marcado para deprecación.
- **Lección**: este fallo sólo existe en la combinación AGP 9 + KSP antiguo. Ningún documento
  del proyecto lo anticipaba; lo detectó el compilador.

## D-003 — Inyección de dependencias manual, sin Hilt

- **Contexto**: Hilt/Dagger son habituales pero añaden dependencias y procesado de anotaciones.
- **Decisión**: contenedor manual en `core/common`.
- **Motivo**: §2 y §67 — mínimo de tecnologías y preferir lo que Android/Jetpack ya resuelve.
- **Reversible**: sí; migrar a Hilt es mecánico si el grafo crece.

## D-004 — Sin PWA, sin WebView como núcleo

- **Contexto**: aparecieron expectativas de PWA/IndexedDB ajenas a los documentos.
- **Decisión**: MOVA es Android nativo. IndexedDB → **Room**. No se construye PWA (§94) y la
  app no depende de WebView (§95).
- **Motivo**: §4 y §125 prohíben una web disfrazada de APK.
- **Reversible**: una capa web futura sería un proyecto separado.

## D-005 — Solo notificaciones locales en V1

- **Contexto**: §46 pide push preparado, pero sin añadir Firebase por costumbre.
- **Decisión**: notificaciones locales; el push queda como abstracción sin proveedor.
- **Motivo**: contratar un servicio push implica cuenta externa y posible facturación
  (Límites §2 y §15), que requieren autorización.

## D-006 — `MapProvider` sin proveedor en V1

- **Contexto**: §44 descarta Google Maps obligatorio.
- **Decisión**: abstracción `MapProvider` con zonas y direcciones escritas; sin mapa real en V1.
- **Motivo**: evita dependencias y claves de API de pago.

## D-007 — Cliente Supabase: `supabase-kt`

- **Contexto**: §68 exige comprobar compatibilidad entre Kotlin, supabase-kt, Ktor y Android.
- **Decisión**: `supabase-kt` con BOM, **versión por confirmar** contra la documentación vigente
  antes de añadirla a `libs.versions.toml`.
- **Estado**: pendiente de añadir la dependencia.

## D-008 — Verificación de build en GitHub Actions

- **Contexto**: el entorno del agente no tiene JDK, Android SDK, Gradle ni red para
  descargarlos.
- **Decisión**: la verificación real (build, tests, lint) se ejecuta en GitHub Actions.
- **Motivo**: §111 prohíbe afirmar que algo compila sin compilarlo.
- **Estado**: **operativa y en verde**. Run `33651253526` falló por
  `./gradlew: Permission denied` (el wrapper se commiteó con modo `100644` desde Windows);
  corregido a `100755`. Run `33651715254` pasó completo: tests, lint y APK debug.
- **Aprendizaje**: como ni los logs de Actions ni el blob de artefactos son accesibles desde el
  entorno del agente, el workflow publica el fallo como comentario del commit. Sin ese canal no
  habría forma de iterar.

## D-009 — Migraciones SQL escritas, no aplicadas

- **Contexto**: aplicar migraciones requiere credenciales y un entorno confirmado.
- **Decisión**: se versionan en `supabase/migrations/`; **no se aplican** a ningún proyecto.
- **Motivo**: Límites §3 (no inventar credenciales), §5 (detenerse ante operaciones
  destructivas) y §6 (nunca asumir que una BD es de desarrollo).
- **Preferencia**: `ADD → MIGRATE → DEPRECATE → REMOVE` antes que eliminar directamente.
