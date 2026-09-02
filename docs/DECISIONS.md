# DECISIONES TÉCNICAS

Registro de decisiones relevantes (Mega Prompt §104). Formato: contexto → decisión →
consecuencias. Las decisiones de producto y negocio **no** están aquí: son del propietario
(Límites §8).

---

## D-001 — Paquete `com.mova.santaclara`

- **Contexto**: la plantilla usaba `com.example.mova`. El Mega Prompt §8 propone
  `com.mova.santaclara`.
- **Decisión**: renombrar `namespace`, `applicationId` y estructura de paquetes.
- **Motivo**: `com.example.*` está reservado por Google y no es publicable en Play; cambiarlo
  después de publicar es caro.
- **Reversible**: sí, mientras no exista publicación. Se documenta como decisión D3 de la
  especificación por si el propietario prefiere otro identificador.

## D-002 — Versión de Room: `PENDIENTE DE DECISIÓN`

- **Contexto**: la documentación oficial vigente (consultada el 2026-09-02) muestra dos líneas:
  **Room 3.0.2** (`androidx.room3:room3-runtime`, KSP obligatorio, APIs basadas en corrutinas,
  requiere un `SQLiteDriver` como `androidx.sqlite:sqlite-bundled`) y **Room 2.8.x**
  (`androidx.room`, en modo mantenimiento con parches).
- **Decisión**: **aplazada** hasta que exista verificación de compilación.
- **Motivo**: el entorno del agente no puede compilar (BLOQUEO 1). Elegir una major nueva cuya
  API no se puede verificar aquí aumentaría el riesgo de entregar código que no compila,
  contrario a §111. Room 2.8.x sigue recibiendo parches y su API Android es estable.
- **Acción**: decidir y registrar en cuanto GitHub Actions esté operativo.

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
- **Estado**: workflow escrito; **bloqueado** por falta de permiso `workflows` (BLOQUEO 2).

## D-009 — Migraciones SQL escritas, no aplicadas

- **Contexto**: aplicar migraciones requiere credenciales y un entorno confirmado.
- **Decisión**: se versionan en `supabase/migrations/`; **no se aplican** a ningún proyecto.
- **Motivo**: Límites §3 (no inventar credenciales), §5 (detenerse ante operaciones
  destructivas) y §6 (nunca asumir que una BD es de desarrollo).
- **Preferencia**: `ADD → MIGRATE → DEPRECATE → REMOVE` antes que eliminar directamente.
