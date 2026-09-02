# MOVA — ESPECIFICACIÓN CONSOLIDADA

| Campo | Valor |
| --- | --- |
| **Documento** | `docs/MOVA_SPECIFICATION.md` |
| **Versión del documento** | 1.1.0 |
| **Fecha** | 2026-09-02 |
| **Estado** | Consolidado — desarrollo iniciado (Fase 1 verificada en CI). Estado vivo en `PROJECT_STATUS.md` |
| **Naturaleza** | Especificación maestra derivada. No sustituye a las fuentes; las resume, ordena y relaciona. |

**Fuentes de esta especificación (leídas completas, sin omisiones):**

1. `Límites de Autonomía del Agente.docx` — 17 secciones.
2. `MOVA — Mega Prompt Maestro de Desarrollo.docx` — 126 secciones (0 a 125).

**Precedencia normativa.** El propio Mega Prompt lo declara en sus secciones 1 y 118: el
documento de **Límites de Autonomía tiene prioridad** sobre cualquier instrucción técnica.
Cuando ambos documentos parezcan contradecirse, **manda Límites** y el conflicto se escala
al propietario si no se resuelve por el principio de reversibilidad.

**Regla de fidelidad.** Todo lo que aparece aquí procede de las dos fuentes o de la
inspección real del repositorio. Nada ha sido inventado. Lo que las fuentes no definen se
marca explícitamente como `PENDIENTE DE DECISIÓN` y **no** se trata como requisito de V1.

---

## 1. Objetivo

MOVA es una **aplicación Android nativa** de movilidad local que conecta **pasajeros** con
**conductores independientes** en **Santa Clara, Villa Clara, Cuba**, permitiendo descubrir,
contactar, reservar y organizar servicios de transporte.

Eslogan provisional: **"Tu ciudad. Tu ruta. Tu movimiento."**

Objetivo real de la V1: **validar el producto con conductores reales de Santa Clara**, no
construir una plataforma nacional desde el primer día.

Metas de adopción por etapas: **5 conductores → 20 conductores → 50+ conductores**, y solo
después expansión a otras localidades (Camajuaní, Remedios, Caibarién, Placetas, Ranchuelo…).

Prioridad de ingeniería explícita:

```
FUNCIONALIDAD > ESTABILIDAD > SEGURIDAD > MANTENIBILIDAD > ESCALA
```

Regla fundamental: **MVP REAL + ARQUITECTURA ESCALABLE**. No construir una arquitectura
gigantesca solo por parecer "profesional", ni introducir tecnologías innecesarias.

## 2. Producto

MOVA **no es un clon de Uber, Didi ni Cabify**, y no debe comportarse como uno.

La V1 es conceptualmente:

```
DIRECTORIO + RESERVAS + AGENDA + GESTIÓN DE CONDUCTORES + MOVILIDAD LOCAL
```

Servicios de transporte contemplados inicialmente:

| Servicio | Icono |
| --- | --- |
| Taxi | 🚕 |
| Triciclo | 🛺 |
| Moto | 🏍️ |
| Auto | 🚗 |
| Van | 🚐 |
| Transporte de carga | 📦 |
| Viajes programados | 🚐 |
| Viajes intermunicipales | 🛣️ |

Alcance geográfico V1: **Santa Clara**, con el modelo de datos preparado para
Provincia → Municipio → Ciudad → Zona. En V1 se usan **zonas, calles, puntos de referencia y
direcciones escritas**; **no se exige GPS**.

La carga (📦 frigoríficos, muebles, compras, mercancías) debe quedar **preparada en la
arquitectura**, sin convertirse en una funcionalidad gigante de la V1.

## 3. Usuarios y roles

| Rol | Puede | No puede |
| --- | --- | --- |
| **VISITANTE** | Explorar, buscar, ver perfiles públicos, ver vehículos, consultar zonas, llamar | Reservar, tener historial |
| **PASAJERO** | Reservar, cancelar, favoritos, historial, reseñas, perfil | Acceder a reservas privadas de otros |
| **CONDUCTOR** | Gestionar perfil, vehículo, disponibilidad, agenda, reservas, estadísticas | Modificar el perfil de otro conductor |
| **ADMIN** | Aprobar/suspender conductores, gestionar usuarios, planes, reseñas, zonas, configuración, revisar reservas y métricas | Exceder lo autorizado por backend/RLS |

Principio de experiencia: **no obligar a crear cuenta inmediatamente**. El visitante explora
y llama sin registro; la autenticación se pide solo cuando una función la necesita
(reservar, historial).

La verificación de conductores (`PENDING → VERIFIED → REJECTED → SUSPENDED`) la realiza
**solo ADMIN**, y se muestra como **🛡️ VERIFICADO**. La autorización real debe estar
protegida por backend/RLS, nunca solo por la UI.

Clasificación de datos: **PUBLIC / AUTHENTICATED / PRIVATE / ADMIN**, con políticas y
almacenamiento coherentes con esa clasificación.

## 4. Funcionalidades

### 4.1 Núcleo V1

- **Exploración y búsqueda** por nombre, tipo, zona y disponibilidad, con filtros por tipo de
  vehículo. Consultas eficientes: no descargar miles de registros innecesariamente.
- **Perfil del conductor**: foto, nombre, verificación, tipo de vehículo, valoración, zona,
  horario, precio orientativo, y acciones `Llamar` / `Reservar` / `Favorito`.
- **Vehículos**: tipo, marca, modelo, color, capacidad, descripción, activo. Tipos:
  `TAXI, TRICYCLE, MOTORCYCLE, CAR, VAN, CARGO, OTHER`.
- **Disponibilidad**: `AVAILABLE, BUSY, OFF_DUTY, UNAVAILABLE`. **No confundir disponibilidad
  con GPS.**
- **Agenda del conductor ("MI AGENDA")**: horario, disponibilidad, reservas, bloqueos,
  cambios, vista día y semana.
- **Reservas**: creación, aceptación, rechazo, cancelación, completado, expiración e
  historial. Estados: `PENDING, ACCEPTED, REJECTED, CANCELLED, COMPLETED, EXPIRED`.
- **Agenda del pasajero ("MIS RESERVAS")** con estados visuales.
- **Reserva offline**: se guarda en Room como `PENDING_SYNC` y muestra
  🟠 *Pendiente de sincronización* → 🟢 *Sincronizada* → 🔴 *No sincronizada* (conservando
  siempre la información).
- **Favoritos**: Room inmediato, Supabase cuando corresponda.
- **Reseñas**: solo tras una reserva **completada**; una reserva no puede generar reseñas
  infinitas. Campos: `rating, punctuality, treatment, vehicle, comment, created_at`.
- **Planes**: `FREE`, `PRO`, `PREMIUM`, configurados remotamente. **Precios nunca
  hardcodeados.**
- **Administración**: dashboard, conductores, usuarios, reservas, planes, reseñas,
  configuración.
- **Notificaciones locales** y estados de reserva.
- **Llamada**: Intent de Android que abre el marcador. Sin llamadas silenciosas y sin
  historial de llamadas.
- **Contacto**: botón 💬 que usa WhatsApp si está disponible u otra app compatible, con
  llamada como alternativa. **WhatsApp no es requisito.**
- **Ranking**: verificación, disponibilidad, calidad del perfil, valoración, actividad, plan
  y distancia futura. **El dinero no debe ser el único factor** y los conductores gratuitos no
  deben desaparecer por completo: reglas de distribución equilibradas.
- **Analíticas básicas**: usuarios, conductores, reservas, conversiones, reseñas, planes. Sin
  sistema analítico pesado.
- **Auditoría**: `audit_logs` con quién, qué, cuándo y resultado de las acciones
  administrativas importantes.

### 4.2 Preparado pero fuera de la V1

GPS y tracking continuo, mapas con proveedor real, push notifications, otros modelos de
cobro, expansión geográfica, panel web de administración.

### 4.3 Pantalla principal (concepto)

```
MOVA
Tu ciudad. Tu ruta. Tu movimiento.

[ 🚕 Buscar transporte ]
[ 📅 Mis reservas ]
[ ❤️ Favoritos ]
[ 👤 Mi cuenta ]
```

Diseño: limpio, moderno, rápido, pocos elementos, botones grandes, claramente nativo.

## 5. Arquitectura

```
                    MOVA
                     │
          ┌──────────┴──────────┐
          │                     │
        UI                   DOMAIN
          │                     │
   Jetpack Compose        Use Cases
          │                     │
          └──────────┬──────────┘
                     │
                    DATA
                     │
          ┌──────────┴──────────┐
          │                     │
       LOCAL                 REMOTE
          │                     │
       Room                 Supabase
          │                     │
          └──────────┬──────────┘
                     │
                Sync Engine
                     │
                 WorkManager
```

**MVVM + Clean Architecture ligera**, con flujo de estado unidireccional:

```
UI → Evento → ViewModel → Use Case → Repository → Local/Remote → State → UI
```

### Capas y responsabilidades

| Capa | Contenido |
| --- | --- |
| **UI** | screens, components, navigation, render de estado |
| **DOMAIN** | modelos de dominio, casos de uso, reglas de negocio |
| **DATA** | repositories, Room, DAOs, Supabase, DTOs, mappers, sincronización |
| **CORE** | configuración, logging, conectividad, errores, utilidades, seguridad |

No colocar lógica de negocio compleja dentro de composables. ViewModels por feature, nunca
ViewModels gigantes. Casos de uso solo cuando exista lógica de negocio real: **no crear
clases artificiales para llenar carpetas**.

### Estructura de carpetas propuesta

```
mova/
├── app/src/main/java/com/mova/santaclara/
│   ├── core/{common,network,connectivity,logging,security}
│   ├── data/{local/{room,dao},remote/supabase,repository,sync}
│   ├── domain/{model,usecase}
│   ├── feature/{auth,home,search,driver,passenger,booking,schedule,favorites,reviews,profile,admin}
│   ├── navigation/
│   └── MainActivity.kt
├── supabase/{migrations,seed,functions}
├── docs/
├── tests/
├── .github/workflows/
├── gradle/  build.gradle.kts  settings.gradle.kts  gradle.properties
├── .gitignore  README.md  CHANGELOG.md  PROJECT_STATUS.md  LICENSE
```

Esta estructura puede mejorarse si existe una alternativa técnicamente superior, **pero la
separación de responsabilidades es innegociable**.

> **Actualización (2026-09-02).** El árbol anterior reproduce la propuesta literal del Mega
> Prompt §8. El identificador adoptado es **`com.mova.app`** (decisión del propietario,
> registrada en `docs/DECISIONS.md` → D-001), no `com.mova.santaclara`. El resto de la
> estructura se mantiene.

### Componentes clave

- **Repositorios con interfaz**: `DriverRepository`, `VehicleRepository`, `BookingRepository`,
  `ScheduleRepository`, `ReviewRepository`, `FavoriteRepository`, `ProfileRepository`,
  `SyncRepository`.
- **`MovaDatabase`** con DAOs separados: `DriverDao`, `VehicleDao`, `BookingDao`,
  `ScheduleDao`, `ReviewDao`, `FavoriteDao`, `SyncOperationDao`. `Flow` donde aporte valor.
- **ViewModels**: `HomeViewModel`, `SearchViewModel`, `DriverViewModel`, `BookingViewModel`,
  `ScheduleViewModel`, `ProfileViewModel`, `AdminViewModel`.
- **Use Cases**: `SearchDriversUseCase`, `CreateBookingUseCase`, `AcceptBookingUseCase`,
  `CancelBookingUseCase`, `SyncPendingOperationsUseCase`, `RateDriverUseCase`.
- **Navegación** nativa de Compose con rutas `home`, `search`, `driver/{id}`, `booking`,
  `bookings`, `schedule`, `favorites`, `profile`, `settings`, `admin`, protegidas según
  autenticación y rol.
- **Abstracción `MapProvider`** para incorporar después OpenStreetMap, mapas offline o GPS.

### Límite de código

Ningún archivo de código debería superar **~200 líneas** (Kotlin, SQL, scripts importantes y
configuración cuando sea razonable). Si crece: dividir, extraer componentes, separar
responsabilidades. **No fragmentar absurdamente solo para cumplir un número.**

## 6. Tecnologías permitidas

| Área | Tecnología |
| --- | --- |
| Plataforma | **Android nativo**, entorno principal **Android Studio** |
| Lenguaje | **Kotlin** |
| UI | **Jetpack Compose** + **Material 3** cuando sea apropiado |
| Arquitectura | **MVVM + Clean Architecture ligera** |
| Persistencia local | **Room** (fuente de verdad de la UI) |
| Preferencias | **DataStore** (no para grandes colecciones) |
| Trabajos persistentes | **WorkManager** |
| Conectividad | **Android Connectivity APIs** |
| Backend | **Supabase** (PostgreSQL, Auth, Storage, PostgREST) |
| Cliente remoto | **supabase-kt**, verificando compatibilidad con Kotlin, Ktor y Android; preferir BOM |
| Versionado | **Git + GitHub** |
| CI/CD | **GitHub Actions** |

Criterio de selección (obligatorio antes de añadir cualquier librería):
**¿Android/Jetpack ya resuelve esto?** Si la respuesta es sí, se usa la solución nativa.
Mantener el número de dependencias bajo.

## 7. Tecnologías prohibidas

Prohibidas **como framework principal**: Flutter, React Native, React, Next.js, Vue, Angular,
Ionic, Cordova, Capacitor y **WebView como núcleo de la aplicación**.

Prohibido construir la app principal como una **web empaquetada**. MOVA debe ser
**NATIVA ANDROID**: "no quiero una aplicación web disfrazada de APK".

Prohibido además:

- **No usar SharedPreferences como base de datos principal** (usar Room; DataStore para
  configuración simple).
- **No añadir Firebase simplemente porque sea habitual**; si se necesita push real, investigar
  primero la alternativa técnica apropiada y sus costes.
- **No usar Google Maps de forma obligatoria** en V1.
- **No implementar criptografía casera**.
- **No hacer tracking GPS continuo en V1**.
- **No crear procesos de red infinitos** ni servicios en segundo plano permanentes sin
  necesidad.
- **No depender de WebView para que la app funcione**; si alguna función requiere una web
  externa, usar navegador o Custom Tab.
- **No descargar código nativo arbitrariamente desde GitHub** (idea antigua explícitamente
  descartada por la sección 59 del Mega Prompt).

## 8. Offline First

Es una **característica central**, no un añadido.

```
LOCAL FIRST → CLOUD SYNC
```

Sin Internet, MOVA **debe seguir funcionando**: abrir, mostrar datos locales, consultar
información almacenada, ver reservas, consultar agenda, modificar operaciones permitidas,
registrar cambios y **encolar operaciones pendientes**.

**Room es la fuente de verdad de la UI** para toda entidad con comportamiento offline:

```
Supabase → Sync → Room → ViewModel → Compose
```

La UI **no** consulta Supabase directamente pantalla por pantalla.

Estados de conectividad que el sistema debe distinguir: `ONLINE`, `OFFLINE`, `SYNCING`,
`SYNC_ERROR`. **No bloquear la aplicación cuando está offline**; mostrar discretamente
🟠 *Sin conexión* y permitir seguir trabajando con lo local.

Acciones sin autenticación o sin conexión: hay que **analizarlas caso por caso y no inventar
comportamiento inseguro**. Ejemplo documentado: explorar perfiles públicos puede funcionar
offline con caché; una reserva nueva puede quedar pendiente localmente; **la confirmación real
del conductor requiere sincronización**.

## 9. IndexedDB

`PENDIENTE DE DECISIÓN` — **y en la práctica: descartado para MOVA.**

Los dos documentos **no mencionan IndexedDB en ningún punto** (verificado por búsqueda textual
completa sobre ambos ficheros). IndexedDB es una API de navegador; MOVA es Android nativo,
donde el equivalente funcional exigido por el Mega Prompt es **Room** (secciones 11, 12 y 48).

Resolución adoptada en esta especificación:

```
IndexedDB (concepto web)  →  Room (implementación real en MOVA)
```

Room almacena: perfiles, conductores, vehículos, áreas, disponibilidad, reservas, favoritos,
historial, configuraciones locales y operaciones de sincronización.

Si en algún momento se aprobara una capa web adicional, su persistencia sería decisión de ese
proyecto separado y **no contaminaría la arquitectura Android nativa**.

## 10. Sincronización

### Sync Engine con cola local

`SyncOperation` — campos: `id`, `entity`, `entity_id`, `operation`, `payload`, `created_at`,
`status`, `retry_count`, `last_attempt_at`, `last_error`.

Estados: `PENDING`, `PROCESSING`, `SYNCED`, `FAILED`, `CONFLICT`.

### Flujo con conectividad

```
Internet disponible → WorkManager → SyncWorker → leer operaciones pendientes
→ procesar → enviar a Supabase → recibir respuesta → actualizar Room → marcar sincronizada
```

### Flujo sin conectividad

```
guardar localmente → PENDING → esperar conectividad
```

### Reintentos

Backoff apropiado; **no bombardear Supabase**. Errores temporales → `retry`; errores
permanentes → `FAILED`; conflictos → `CONFLICT`. **El usuario no debe perder una operación
porque se fue Internet.**

### Conflictos

La arquitectura se diseña **para** conflictos, usando `updated_at`, `version`, `operation id`
y timestamps. **No sobrescribir datos silenciosamente**: ante un conflicto importante,
registrar, preservar datos, resolver según reglas y evitar pérdida.

### WorkManager

Para sincronización pendiente, reintentos, operaciones diferibles y mantenimiento local.

## 11. Supabase

**Un único proyecto Supabase para la V1**, usado como **BACKEND CLOUD**.

Componentes: PostgreSQL, Auth, Storage, PostgREST. **Realtime solo si realmente aporta valor**
y no puede resolverse razonablemente con sincronización; **Edge Functions solo cuando sean
necesarias**. No mantener conexiones innecesarias.

### Coste

Diseñar para **COSTE = 0 inicialmente**: GitHub Free + Supabase Free + Android Studio +
Kotlin + Jetpack + Room + WorkManager. Evitar polling continuo, consultas innecesarias,
realtime en exceso, imágenes gigantes, datos duplicados, archivos innecesarios y Edge
Functions innecesarias. **Si aparece una necesidad de pago: evaluar primero la alternativa
gratuita. No activar servicios de pago automáticamente.**

### Auth

**Supabase Auth**. No almacenar contraseñas manualmente. Inicialmente **email/password**, con
arquitectura preparada para OTP y teléfono si se decide después. Gestión correcta de sesión:
login, logout, expiración, restauración y **estado offline** — el usuario no puede quedar
permanentemente bloqueado porque el servidor no responde temporalmente.

### Modelo de datos (migraciones)

`profiles`, `drivers`, `vehicles`, `service_areas`, `driver_availability`, `bookings`,
`reviews`, `favorites`, `driver_plans`, `subscriptions`, `notifications`, `app_config`,
`audit_logs`, `sync_metadata`. La lista puede ajustarse tras el análisis de relaciones reales.

Cada tabla debe tener: **UUID, timestamps, foreign keys, constraints, índices y RLS**.

### RLS (obligatoria en tablas sensibles)

- Conductor: ✅ modificar su propio perfil — ❌ modificar otro conductor.
- Pasajero: ✅ acceder a sus reservas — ❌ acceder a reservas privadas de otros.
- Admin: ✅ administrar recursos autorizados.
- **No crear políticas excesivamente amplias sin justificación.**

### Credenciales

**Nunca** guardar en GitHub: `service role key`, secretos privados ni credenciales de
administrador. La app móvil usa solo la **credencial pública** apropiada para el cliente.
Configurar credenciales mediante un **mecanismo de build adecuado para Android** y documentar
claramente la diferencia entre **PUBLIC CONFIG** y **SECRET CONFIG** (Supabase advierte que las
apps móviles no reciben variables de entorno como una app web).

### Configuración remota y Storage

`app_config` para elementos no críticos: mensajes, planes, promociones, flags, versión
recomendada, mantenimiento. **Nunca confiar en configuración remota para seguridad.**
Fotos: comprimir, limitar tamaño, validar MIME, evitar duplicados, thumbnails solo si hacen
falta.

## 12. Seguridad

- **RLS en todas las tablas sensibles**; autorización real en backend.
- **Android Keystore, cifrado y almacenamiento seguro** cuando corresponda; tokens protegidos.
- **Logging** con niveles `DEBUG / INFO / WARN / ERROR`. En producción **no registrar**
  contraseñas, tokens, claves ni datos personales innecesarios.
- **Manejo de errores humano**: nunca mostrar `NullPointerException`, `HTTP 500` o
  `SocketException` al usuario. Ejemplo de mensaje correcto: *"No pudimos conectar ahora. Tus
  datos siguen guardados en el dispositivo."* Los detalles técnicos van a logs.
- **Privacidad**: guardar solo lo necesario, no registrar ubicación permanente de todos los
  usuarios, no recopilar datos sin motivo.
- **Permisos mínimos**: teléfono, red, notificaciones y cámara para foto; ubicación solo
  después. No solicitar permisos innecesarios.
- **Repo limpio**: sin `.env`, sin secretos, sin release keys privadas, sin datos de
  producción. **Keystore fuera del código** (alias, password y firma manejados externamente y
  documentados; el agente no debe inventar ni filtrar una clave de firma).
- **Detección proactiva**: ante vulnerabilidad crítica, credencial expuesta, política RLS
  insegura, fuga de datos o dependencia comprometida, **priorizar la mitigación**. Los arreglos
  técnicos reversibles se corrigen automáticamente; revocar credenciales o tocar producción
  requiere explicar el riesgo y **solicitar autorización**.

## 13. Android

- **Verificar antes de modificar**: Android Studio, JDK, Gradle, Android SDK, Build Tools,
  emulador y dispositivo físico si existe. **Documentar las versiones utilizadas.**
- **`minSdk` / `targetSdk` / `compileSdk`**: se fijan según las versiones realmente soportadas
  por las herramientas y dependencias elegidas. **No inventar valores**; verificar
  documentación actual antes de fijarlos.
- **Rendimiento para teléfonos económicos**: evitar recomposiciones innecesarias, imágenes
  pesadas, consultas grandes, operaciones bloqueantes en la UI y trabajo pesado en el
  *main thread*.
- **Accesibilidad**: content descriptions, tamaños adecuados, contraste, textos legibles,
  navegación clara, feedback visible. Compose responsive para distintos teléfonos y navegación
  segura.
- **Branding**: icono propio, simple, reconocible, moderno, visible a tamaño pequeño. **No
  copiar logos existentes.**
- **Splash**: mostrar `MOVA` + eslogan, sin mantenerlo innecesariamente.
- **Builds**: `debug` y `release`; la release debe poder producir **APK** y preferentemente
  **AAB** cuando el flujo de distribución lo requiera.
- **Criterio de producción** (cadena completa que el proyecto debe pasar):

```
ANDROID STUDIO → SYNC → BUILD → TEST → INSTALL → RUN
→ OFFLINE TEST → ONLINE TEST → SUPABASE TEST → RELEASE BUILD
```

## 14. PWA

**No es requisito del núcleo.** MOVA es una app Android nativa y la sección 94 del Mega Prompt
lo declara textualmente: *"No desarrollar una PWA paralela simplemente por obligación del prompt
anterior."*

Regla adoptada:

- V1 = **solo Android nativo**. No se construye PWA.
- Si en el futuro se considera útil una versión web, será un **proyecto/capa adicional
  separado** que **no contamine la arquitectura Android nativa**, y requerirá decisión del
  propietario.
- La app **no depende de WebView**; una web externa se abre con navegador o Custom Tab.

## 15. GitHub

Uso de GitHub: repositorio, commits, ramas, issues, releases, Actions y artefactos.
**No se usa como base de datos** y **no almacena datos de pasajeros o conductores**.

Contenido del repo: `source`, `docs`, `migrations`, `tests`, `workflows`.
**Nunca**: `.env`, secretos, release keys privadas, datos de producción.

**Versionado**: `MAJOR.MINOR.PATCH` (p. ej. `1.0.0`, `1.0.1`, `1.1.0`, `2.0.0`), coherente con
`versionCode` y `versionName` de Android.

**Commits** con mensajes claros y consistentes:

```
chore: initialize Android project
feat: add Room database
feat: add Supabase authentication
feat: add driver profiles
feat: add booking flow
feat: add offline synchronization
feat: add driver schedule
fix: resolve booking sync conflict
```

**Ramas**: `main`, `develop`, `feature/*`, `fix/*` **si la complejidad lo justifica**. No crear
ramas innecesarias.

**GitHub Actions**: workflows de build, test y lint sobre pull request; artefactos debug APK y
release; workflow de release **controlado**. Secretos siempre por **GitHub Secrets**, nunca en
código. **No publicar automáticamente una versión de producción sin autorización.**

**Disciplina**: tras cambios importantes → `git status`, commit coherente y actualización de
`PROJECT_STATUS.md`. **No perder trabajo.**

## 16. Actualizaciones

La idea antigua de "descargar código nativo desde GitHub" queda **completamente reemplazada**.
MOVA es nativa, por lo que:

| Tipo de cambio | Mecanismo |
| --- | --- |
| Kotlin, Compose, permisos, AndroidManifest, SDK, dependencias nativas, Room, WorkManager, capacidades Android | **Nueva APK/AAB** |
| Textos, planes, mensajes, promociones, parámetros, flags | **Supabase, sin reinstalar** |

**Update check**: la app conoce `currentVersion`, `minimumSupportedVersion` y `latestVersion`.
Si hay actualización nativa, mostrar 🔄 *Nueva versión disponible*. **No instalar
silenciosamente una APK** sin el mecanismo de distribución/autorización apropiado.

**Rollback**: releases reversibles, conservar artefactos anteriores en GitHub Releases cuando
corresponda y **no eliminar automáticamente la última versión estable**.

**Google Play**: preparar el proyecto, pero **la publicación final requiere autorización
explícita del propietario**.

## 17. Modelo comercial

- **Gratuito para pasajeros** inicialmente.
- Los conductores pueden pagar por **VISIBILIDAD / SUSCRIPCIÓN**.
- **No cobrar comisión obligatoria por viaje en la V1.**
- Planes `FREE` / `PRO` / `PREMIUM` configurados **remotamente en Supabase**, con campos
  `name, price, currency, duration_days, featured, active, features`. **Precios nunca
  hardcodeados.**
- Ranking comercial equilibrado: los conductores gratuitos **no deben desaparecer**.
- **Pagos**: no implementar una pasarela compleja al inicio. Registrar únicamente
  `subscription, status, amount, currency, start_date, end_date, payment_reference`. El
  mecanismo real de pago se decide después.

> ⚠️ **Límite de autonomía aplicable.** El agente puede **preparar e implementar el mecanismo
> configurable**, pero **no puede fijar como definitivos** el modelo de negocio, precios,
> comisiones, políticas para conductores, condiciones de uso, tratamiento de datos personales
> ni estrategia comercial. **Esas decisiones son del propietario** (Límites §8).
> `PENDIENTE DE DECISIÓN`: precios, moneda y método de cobro reales.

## 18. Reglas de desarrollo

1. **INSPECCIONA → IMPLEMENTA → PRUEBA → CORRIGE → DOCUMENTA**, trabajando sobre el
   repositorio real. Nada de respuestas teóricas.
2. **Regla anti-dummy**: no crear botones que no hagan nada; no usar `TODO`, `Coming Soon` ni
   `alert(...)` como sustituto de funcionalidad. Los elementos futuros deben estar
   explícitamente identificados.
3. **Regla anti-mock**: sin datos simulados en producción. Mocks solo para tests, desarrollo y
   demos controladas.
4. **Regla de verificación**: nunca decir *"compila"* sin compilar, *"Supabase funciona"* sin
   comprobar la conexión, *"GitHub configurado"* sin verificar el repo, *"offline funciona"* sin
   prueba real. **La evidencia válida es CÓDIGO + PRUEBA + VERIFICACIÓN**; una respuesta de IA
   no es evidencia.
5. **No asumir APIs**: cuando una API, SDK, librería o política pueda haber cambiado,
   **consultar la documentación oficial vigente** (Android Developers, Supabase Docs, GitHub
   Docs, docs de la dependencia).
6. **No perder datos** y **no introducir costes innecesarios**.
7. **Construir de forma incremental**: cada fase debe dejar el proyecto mejor que la anterior.
8. **Errores y bloqueos**: nunca ocultar un error; nunca afirmar "Completado" sin verificar.
   Formato obligatorio de reporte:

   ```
   BLOQUEO
   Problema:            ...
   Causa:               ...
   Qué puedo solucionar automáticamente: ...
   Qué necesito del propietario:         ...
   ```

   Y **continuar siempre con las tareas independientes**.
9. **Credencial faltante**: no inventarla, no buscarla por medios no autorizados, no
   imprimirla. Reportar `Credencial requerida / Para / Lugar donde debe configurarse` y seguir
   desarrollando todo lo demás.

### Pruebas exigidas

| Tipo | Cobertura |
| --- | --- |
| **Unitarias** | casos de uso, validaciones, estados, sincronización, ranking, reservas |
| **Room** | inserción, actualización, eliminación, consultas, persistencia |
| **Sincronización** | online, offline, reserva offline, cerrar app, abrir app, volver online, WorkManager, Supabase responde, Supabase no responde, reintento, conflicto |
| **Apagón** | usuario crea operación sin Internet → operación guardada → teléfono apagado → encendido → Room intacto → vuelve Internet → WorkManager → Sync. **No perder información** |

### Documentación exigida

`README.md` + `docs/`: `ARCHITECTURE.md`, `ANDROID.md`, `DATABASE.md`, `SUPABASE.md`,
`OFFLINE.md`, `SYNC.md`, `SECURITY.md`, `RELEASE.md`, `GITHUB.md`, `ADMIN.md`, `DRIVER.md`,
`PRODUCT.md`, `DECISIONS.md`, `ROADMAP.md`, `TESTING.md`.

Además: `PROJECT_STATUS.md` (Estado / Completado / En desarrollo / Pendiente / Problemas
conocidos / Próxima fase, actualizado durante el desarrollo), `CHANGELOG.md`
(`## [x.y.z]` con Added / Fixed / Changed), `docs/DECISIONS.md` (decisiones de arquitectura,
librerías, Supabase, Room, sincronización y distribución) y `FINAL_AUDIT.md` (revisión de
Android, Kotlin, Compose, Room, WorkManager, Supabase, RLS, Offline, Sincronización,
Seguridad, GitHub, CI/CD, UX, Rendimiento y Documentación).

## 19. Límites de autonomía

### 19.1 Puede hacer sin pedir permiso

Crear y modificar archivos; crear carpetas y módulos; instalar dependencias de desarrollo
razonables; ejecutar comandos locales, tests, lint y builds; corregir errores de compilación;
refactorizar; crear migraciones SQL; crear documentación y scripts; configurar Git local; crear
commits y ramas; crear workflows de GitHub Actions; analizar logs; optimizar consultas; mejorar
UX/UI; crear datos ficticios de desarrollo; ejecutar pruebas offline; revisar seguridad básica;
**preparar releases**; proponer y aplicar decisiones técnicas de bajo riesgo **cuando sean
reversibles**.

> El agente debe **preferir actuar** antes que pedir permiso por cada cambio pequeño. No
> preguntar cosas como *"¿Quieres que cree una carpeta utils?"*.

### 19.2 Principios rectores

- **Reversibilidad**: ante dos opciones equivalentes, elegir la reversible, segura, barata,
  fácil de probar y fácil de deshacer.
- **Mínimo privilegio**: siempre el menor nivel de permisos necesario. Nunca solicitar acceso
  administrativo total, permisos de producción ni credenciales de servicio si basta una
  solución con menos privilegio.
- **Decisiones técnicas autónomas** (arquitectura, estructura de carpetas, nombres internos,
  refactorización, librerías, patrones, optimización, testing) si son razonables, reversibles y
  compatibles con los objetivos — **y documentando las relevantes**.
- **Entornos**: distinguir siempre `DEVELOPMENT` / `STAGING` / `PRODUCTION`. **Nunca asumir que
  una base de datos es de desarrollo** si existe posibilidad razonable de que contenga datos
  reales. Antes de una operación potencialmente destructiva: comprobar entorno, proyecto,
  configuración y destino.
- **Supabase**: preferir `ADD → MIGRATE → DEPRECATE → REMOVE` en lugar de eliminar directamente.
- **Internet y servicios externos**: puede consultar documentación técnica pública; **no** crear
  cuentas externas, aceptar contratos, introducir datos personales, realizar pagos ni activar
  servicios de pago sin autorización.
- **IA**: puede usarla para generar código, revisar, documentar, testear y analizar — pero
  **debe verificar el resultado**.

### 19.3 Regla final

> *"Actúa solo cuando la acción sea técnicamente segura, reversible y esté dentro del alcance
> del proyecto. Detente únicamente ante acciones financieras, legales, destructivas,
> irreversibles, de producción crítica o que requieran una credencial/autorización del
> propietario."*

```
AUTÓNOMO PARA CONSTRUIR   +   CONTROLADO PARA DECIDIR
```

El propietario conserva **siempre** el control final sobre: dinero, cuentas, datos reales,
producción, publicación, decisiones empresariales, asuntos legales y credenciales.

### 19.4 Registro de conflictos y precedencia

Detectados al cruzar ambos documentos. **Ninguno se resuelve en silencio**: se indica la
precedencia y el motivo.

| # | Severidad | Conflicto | Resolución y precedencia |
| --- | --- | --- | --- |
| C1 | **CRÍTICO** | Mega §19/§124 exigen **un proyecto Supabase** para la V1; Límites §15 prohíbe **crear cuentas externas** y §2 prohíbe **activar servicios con facturación** sin autorización. | **Gana Límites.** El agente **no crea** el proyecto Supabase. Prepara todo el código, migraciones y RLS offline-friendly y **solicita al propietario** el proyecto + `SUPABASE_URL` + `anon key`. Bloquea Fase 2 en adelante hasta recibir credenciales. |
| C2 | **CRÍTICO** | El entorno de ejecución disponible **no puede compilar ni verificar** (sin JDK/Android SDK/Gradle ni red), mientras Mega §111/§112/§114 exigen evidencia real de build, test e instalación. | **Ganan Límites §16 y Mega §111.** Está **prohibido** declarar "compila" o "funciona" sin evidencia. Las builds se verifican donde exista el toolchain (Android Studio del propietario o GitHub Actions). Cualquier entrega sin verificar se marca como **no verificada**. |
| C3 | **ALTO** | Mega §113 Fase 2 y §23 piden crear **y aplicar** migraciones + RLS; Límites §5 exige **detenerse y pedir autorización** ante operaciones destructivas sobre datos reales y §3 prohíbe inventar credenciales. | **Gana Límites.** Se **escriben** migraciones en `supabase/migrations/` (autónomo y reversible). **Aplicarlas** a un proyecto real requiere credenciales y confirmación de entorno; cualquier `DROP`/`TRUNCATE`/`DELETE` masivo se detiene. |
| C4 | **ALTO** | Límites §1/§4 permiten "preparar releases" y "crear **releases de desarrollo**"; Límites §2/§9 y Mega §93/§106 exigen autorización para publicar, distribuir ampliamente una APK o activar una release pública. | **Se aplica la distinción, no la contradicción.** Release de desarrollo / pre-release / artefacto = autónomo. Release pública, distribución amplia, producción y Google Play = **autorización explícita**. Gana Límites en caso de duda. |
| C5 | **ALTO** | Mega §114/§123 exigen **APK y AAB preparados**; Mega §91 y Límites §3 prohíben inventar o filtrar la **clave de firma**, que hoy no existe. | **Gana Límites.** Build **debug** verificable de forma autónoma. Release **firmada** = BLOQUEO hasta que el propietario aporte keystore, alias y passwords fuera del código. |
| C6 | **ALTO** | Expectativas heredadas de **PWA / IndexedDB / web** frente a Mega §4, §94, §95 y §125 (nativo puro, sin WebView como núcleo). | **Gana el Mega Prompt** (aquí no hay choque con Límites): **Android nativo**, Room en lugar de IndexedDB, **sin PWA en V1**. Una capa web futura sería proyecto separado con autorización. |
| C7 | **MEDIO** | Límites §1 permite "instalar dependencias de desarrollo razonables"; Mega §2 y §67 exigen **mínimo de tecnologías** y preguntarse primero si Android/Jetpack ya lo resuelve. | **Se combinan.** La autonomía para añadir dependencias queda **acotada** por la política minimalista y por la reversibilidad. Toda dependencia nueva se registra en `docs/DECISIONS.md`. |
| C8 | **MEDIO** | Mega §46 pide notificaciones push preparadas "investigando costes"; Límites §2/§15 prohíben contratar o activar servicios de pago y crear cuentas externas. | **Gana Límites.** V1 = **solo notificaciones locales**. Push queda como abstracción sin proveedor contratado. |
| C9 | **MEDIO** | Mega §71 admite un **panel web separado** de administración; Mega §4 prohíbe frameworks web **como núcleo de la app**. | **No hay contradicción real** (la prohibición es sobre el núcleo Android). Es una decisión de producto: `PENDIENTE DE DECISIÓN` — admin en Android vs. panel web. |
| C10 | **MEDIO** | Mega §108 propone ramas `develop` / `feature/*`; Límites §4 prohíbe borrar ramas importantes y hacer force-push destructivo. Además, **esta sesión de trabajo está fijada a una única rama**, `arena/01a062b2-mova`. | **Gana Límites.** Se trabaja sobre la rama asignada y se integra a `main` por PR. No se borra nada ni se reescribe historial. El modelo de ramas completo se activa cuando el flujo de trabajo lo permita. |
| C11 | **MEDIO** — ✅ **RESUELTO** | Mega §8 propone `com.mova.santaclara`; el repositorio real usaba `com.example.mova`. Cambiar `applicationId` después de publicar es costoso. | **Resuelto por el propietario (2026-09-02): `com.mova.app`.** Ver `docs/DECISIONS.md` → D-001. Renombrado y verificado en CI. |
| C12 | **BAJO** | Mega §1 permite "crear datos ficticios de desarrollo" (Límites §1) frente a la regla anti-mock en producción (Mega §110). | **Compatible.** Datos ficticios solo en `DEVELOPMENT`/tests/demos controladas, separados por entorno. |
| C13 | **BAJO** | Mega §9 fija ~200 líneas por archivo, incluidos "archivos de configuración cuando resulte razonable". | **Compatible**, con criterio: no fragmentar absurdamente para cumplir el número. |

## 20. Acciones que requieren autorización

**Nunca sin autorización explícita del propietario:**

- **Dinero**: gastar dinero, crear suscripciones de pago, activar servicios con facturación,
  comprar dominios o infraestructura, **cambiar un plan de Supabase a uno de pago**, contratar
  servicios externos, realizar pagos, crear obligaciones financieras.
- **Legal / identidad**: publicar comercialmente bajo la identidad del propietario, firmar
  contratos, aceptar términos legales en su nombre, registrar marca o empresa, crear cuentas
  financieras, acceder a información bancaria, solicitar documentos oficiales de identidad,
  enviar comunicaciones comerciales masivas, crear cuentas con datos personales no facilitados
  expresamente para ese fin.
- **Datos y producción**: eliminar datos reales, eliminar un repositorio, force-push destructivo
  sobre ramas protegidas, rotar o revocar credenciales de producción, modificar DNS de
  producción de forma irreversible, cambiar configuraciones críticas de producción con riesgo de
  pérdida de datos.
- **Publicación**: publicar en Google Play, activar una release pública, distribuir ampliamente
  una APK, cambiar producción. (Preparar APK, AAB, release notes, screenshots, metadata y
  assets **sí** es autónomo.)
- **Supabase destructivo**: `DROP TABLE` con datos de producción, `DELETE` masivo, `TRUNCATE`,
  migración destructiva o cambio irreversible de esquema → **DETENERSE Y PEDIR AUTORIZACIÓN**.
- **Credenciales**: si falta una, **detener solo la tarea que depende de ella**, continuar con
  todo lo demás e informar exactamente qué falta y para qué.

**Sí preguntar, por ejemplo:** *"Necesito una credencial de producción"* o *"esta migración
eliminaría datos existentes"*. **No preguntar**, por ejemplo: *"¿creo una carpeta utils?"*.

## 21. Criterios de éxito

MOVA MVP estará listo cuando se verifique **todo** lo siguiente:

```
☑ Android Studio abre el proyecto      ☑ pasajero puede reservar
☑ Gradle sincroniza                    ☑ conductor puede aceptar
☑ APK compila                          ☑ reserva puede completarse
☑ app inicia                           ☑ reseña funciona
☑ Compose funciona                     ☑ Room funciona
☑ registro funciona                    ☑ Supabase funciona
☑ login funciona                       ☑ RLS funciona
☑ roles funcionan                      ☑ offline funciona
☑ conductor puede crear perfil         ☑ sync funciona
☑ conductor puede crear vehículo       ☑ WorkManager funciona
☑ conductor puede configurar agenda    ☑ recuperación tras reinicio funciona
☑ pasajero puede buscar                ☑ GitHub funciona
☑ pasajero puede ver conductor         ☑ CI funciona
                                       ☑ documentación existe
```

**Primer conductor real** — el sistema debe permitirle: crear cuenta → crear perfil →
seleccionar triciclo/taxi → añadir vehículo → configurar horario → recibir reserva → aceptar →
completar → recibir valoración.

**Entregable final del repositorio**: Android nativo, Kotlin, Jetpack Compose, Room, DataStore
cuando corresponda, WorkManager, Supabase, Auth, PostgreSQL, RLS, perfiles, conductores,
vehículos, agenda, reservas, favoritos, reseñas, planes, administración, Offline First, Sync
Queue, recuperación, Git, GitHub, GitHub Actions, tests, documentación, APK, AAB preparado,
changelog y auditoría.

**Criterio último:** *"HACER QUE MOVA FUNCIONE EN EL MUNDO REAL."* Sin prototipos falsos, sin
pseudocódigo, sin web disfrazada de APK, sin clon de Uber.

## 22. Roadmap

| Fase | Contenido | Estado actual (inspección del repo, 2026-09-02) |
| --- | --- | --- |
| **0 — AUDITORÍA** | Analizar repo, Android Studio, Kotlin, Gradle, SDK, Git, Supabase y archivos existentes | ✅ **Hecha** (este documento) |
| **1 — BOOTSTRAP** | Proyecto Android, Kotlin, Compose, navegación, arquitectura base, Git, README | 🟡 Parcial: Android Studio generó el proyecto (Kotlin + Compose + theme). **Falta** navegación, arquitectura por capas y `README.md` |
| **2 — DATA** | Room, entidades, DAOs, repositories, Supabase, migraciones, RLS | ⬜ Pendiente. **Bloqueada parcialmente por C1/C3** (credenciales) |
| **3 — AUTH** | Login, registro, sesión, perfiles, roles | ⬜ Pendiente — requiere C1 |
| **4 — CONDUCTORES** | Perfil, vehículo, disponibilidad, verificación | ⬜ Pendiente |
| **5 — PASAJERO** | Inicio, búsqueda, filtros, perfiles, favoritos | ⬜ Pendiente |
| **6 — RESERVAS** | Creación, aceptación, rechazo, cancelación, completado, historial | ⬜ Pendiente |
| **7 — AGENDA** | Calendario, disponibilidad, bloqueos, reservas | ⬜ Pendiente |
| **8 — OFFLINE** | Room como fuente local, Sync Queue, WorkManager, reintentos, conflictos | ⬜ Pendiente |
| **9 — REVIEWS** | Valoración, comentarios, puntuaciones | ⬜ Pendiente |
| **10 — PLANES** | FREE / PRO / PREMIUM + configuración remota | ⬜ Pendiente — precios `PENDIENTE DE DECISIÓN` |
| **11 — ADMIN** | Dashboard, conductores, usuarios, reservas, planes, reseñas, configuración | ⬜ Pendiente — soporte `PENDIENTE DE DECISIÓN` (C9) |
| **12 — QA** | Pruebas completas | ⬜ Pendiente |
| **13 — GITHUB** | Actions, builds, tests, releases | ⬜ Pendiente |
| **14 — RELEASE** | APK / AAB si corresponde | ⬜ Pendiente — release firmada bloqueada por C5 |

No intentar construir todo simultáneamente: **construcción incremental**, comenzando por la
fase que corresponda al estado real del proyecto.

## 23. Riesgos detectados

### 23.1 Hallazgos reales del repositorio (verificados)

Estado: **1 solo commit** (`bfff038`, *"Add files via upload"*, autor `Junmoxia41`, 40 archivos)
sobre `main`. Contenido: los dos `.docx` + plantilla **New Project de Android Studio**
(Empty Activity con Compose). No hay desarrollo propio todavía.

| # | Severidad | Hallazgo | Evidencia | Impacto / acción |
| --- | --- | --- | --- | --- |
| R1 | **ALTO** | **No existe `.gitignore`** y **`local.properties` está versionado** | `git ls-files` incluye `local.properties`; el propio fichero dice *"should NOT be checked into Version Control Systems"*. Contiene `sdk.dir=C:\Users\airienrr\AppData\Local\Android\Sdk` | Riesgo de **filtrar secretos** en cuanto se añada `SUPABASE_ANON_KEY` u otras claves (Mega §22, §90). **No contiene secretos hoy** (verificado). Acción: crear `.gitignore` y desindexar `local.properties` |
| R2 | **ALTO** | **El entorno disponible no puede construir ni verificar**: sin JDK (`java: command not found`), sin Android SDK (`ANDROID_HOME` vacío, no existe `/usr/lib/android-sdk`), sin Gradle y **sin red saliente** desde el shell (`curl` a `services.gradle.org`, `repo1.maven.org` y `supabase.com` devuelve `000`) | Comprobado en la sesión | Impide cumplir Mega §112/§114 aquí. Mitigación: builds en Android Studio del propietario o en **GitHub Actions**; nada se declarará "compilado" sin evidencia (C2) |
| R3 | **MEDIO** | `versionName = "1.0"` **no sigue** `MAJOR.MINOR.PATCH` (Mega §61) | `app/build.gradle.kts` | Corregir a `1.0.0` y mantener coherencia con `versionCode` |
| R4 | **MEDIO** | **Sin permiso `INTERNET`** en el manifiesto | `app/src/main/AndroidManifest.xml` | Imprescindible para Supabase; se añadirá en Fase 2 |
| R5 | **MEDIO** — ✅ **RESUELTO** | `applicationId` / `namespace` era `com.example.mova` | `app/build.gradle.kts` | Decidido `com.mova.app` antes de cualquier publicación (C11 / D3). Verificado en CI |
| R6 | **MEDIO** | `app/build.gradle.kts` aplica `android.application` + `kotlin.compose`, **sin aplicar explícitamente el plugin de Kotlin Android** | `build.gradle.kts` y `app/build.gradle.kts` | Verificar contra la documentación oficial de **AGP 9.4** si el soporte de Kotlin es integrado (Mega §105: *NO ASUMIR*). **No verificado aquí** por R2 |
| R7 | **BAJO** | Versiones muy recientes: **AGP 9.4.0, Gradle 9.6.0, Kotlin 2.2.10, Compose BOM 2026.02.01, `compileSdk`/`targetSdk` 37, `minSdk` 24, toolchain JVM 25** con `sourceCompatibility` 11 | `gradle/libs.versions.toml`, `gradle/wrapper/gradle-wrapper.properties`, `gradle/gradle-daemon-jvm.properties` | Comprobar **compatibilidad real con supabase-kt y Ktor** (Mega §66, §68) antes de la Fase 2 |
| R8 | **BAJO** | Optimización/R8 **deshabilitada** en `release` (`optimization { enable = false }`) y `allowBackup="true"` | `app/build.gradle.kts`, `AndroidManifest.xml` | Revisar antes de cualquier release real |
| R9 | **BAJO** | Solo existen los tests de ejemplo de la plantilla (`ExampleUnitTest`, `ExampleInstrumentedTest`) | `app/src/test/...`, `app/src/androidTest/...` | Sustituir por tests reales en las fases 6–12 |
| R10 | **BAJO** | Faltan por completo `README.md`, `docs/`, `CHANGELOG.md`, `PROJECT_STATUS.md`, `.github/`, `supabase/`, `LICENSE` | `git ls-files` | Requisitos explícitos de Mega §8, §101–§104 y criterio de éxito "documentación existe" |

### 23.2 Riesgos de proyecto

| Riesgo | Descripción | Mitigación |
| --- | --- | --- |
| **Coste inesperado** | Realtime, Storage, Edge Functions o un plan de Supabase de pago romperían el objetivo de coste 0 | Diseño frugal, Realtime solo si aporta valor, alternativa gratuita primero, **nunca** activar pagos |
| **Pérdida de datos del usuario** | Una reserva offline mal gestionada pierde confianza definitivamente | Sync Queue persistente, prueba de apagón obligatoria, conflictos sin sobrescritura silenciosa |
| **RLS mal configurada** | Fuga de datos de pasajeros/conductores | RLS desde la migración inicial, sin políticas amplias sin justificación, revisión de seguridad |
| **Dependencia del propietario** | Sin credenciales de Supabase ni keystore, el avance se detiene en Fase 2/3 y en la release firmada | Todo lo independiente se construye igual; bloqueos reportados con el formato `BLOQUEO` |
| **Sobre-ingeniería** | Arquitectura gigante que no llega a funcionar | MVP real, mínimo de dependencias, archivo ≤ ~200 líneas, regla anti-dummy/anti-mock |
| **Supuestos técnicos obsoletos** | Versions/APIs asumidas sin verificar | Consultar documentación oficial vigente antes de fijar `minSdk`/`targetSdk` y elegir supabase-kt |
| **Datos personales de conductores reales** | Registro de personas reales implica tratamiento de datos y términos legales | El agente **no** acepta términos legales ni crea cuentas con datos personales; decisión del propietario |

## 24. Decisiones pendientes

Todas requieren **decisión del propietario**. Ninguna se asumirá como definitiva.

| # | Decisión | Por qué no la toma el agente | Bloquea |
| --- | --- | --- | --- |
| D1 | **Proyecto Supabase**: quién lo crea, URL y `anon key` (PUBLIC CONFIG), y confirmación de que el proyecto es de desarrollo | Límites §15 (no crear cuentas externas) y §2 (no activar servicios con facturación) | Fases 2–14 |
| D2 | **Entorno real**: ¿existe ya un proyecto Supabase con **datos reales**? ¿hay `STAGING` y `PRODUCTION` separados? | Límites §6 (nunca asumir que una BD es de desarrollo) | Aplicación de migraciones |
| ~~D3~~ | ~~**`applicationId` / `namespace`**~~ — ✅ **RESUELTO el 2026-09-02: `com.mova.app`** (decisión del propietario; ver `docs/DECISIONS.md` → D-001) | — | Cerrada |
| D4 | **Keystore de release**: keystore, alias y passwords, gestionados fuera del código (GitHub Secrets / almacén del propietario) | Límites §3 y Mega §91: el agente no inventa ni filtra claves de firma | Fase 14 (release firmada) |
| D5 | **Modelo de administración**: admin dentro de la app Android o **panel web separado** (C9) | Mega §71 lo deja explícitamente al análisis; implica alcance y posiblemente un segundo proyecto | Fase 11 |
| D6 | **Precios, moneda y método de pago** de `FREE / PRO / PREMIUM`, y comisión | Límites §8: el modelo de negocio y los precios son del propietario | Fase 10 (solo el mecanismo es configurable) |
| D7 | **Push notifications**: proveedor, requisitos y coste reales | Límites §2/§15 y Mega §46: no añadir Firebase por costumbre ni activar servicios de pago | Post-V1 |
| D8 | **Modelo de ramas**: activar `develop` + `feature/*` o mantener flujo simple con PR a `main` (C10) | Depende del flujo de trabajo y de las ramas protegidas del repo | Fase 13 |
| D9 | **Convención de tags/versiones en Git**: si se publican tags `vX.Y.Z` y con qué cadencia | Publicación de referencias en el repo; Mega §61 fija el esquema pero no la política de tags | Fase 13/14 |
| D10 | **Términos de uso y política de privacidad** para conductores y pasajeros reales | Límites §2: el agente no acepta términos legales en nombre del propietario | Primer conductor real |
| D11 | **`indexedDB` / capa web**: se confirma que **no** hay PWA en V1 (sección 14). ¿Se aprueba definitivamente ese descarte? | Mega §94 ya lo descarta, pero la expectativa apareció fuera de los documentos; conviene confirmación explícita | Nada (V1) |
| D12 | **Licencia del proyecto**: `LICENSE` presente en la estructura propuesta pero sin contenido definido | Decisión legal del propietario | Entrega final |

---

### Anexo A — Trazabilidad

| Tema | Límites de Autonomía | Mega Prompt |
| --- | --- | --- |
| Autonomía general | §1, §12, §17 | §1, §118 |
| Autorización / dinero / legal | §2, §15 | §117 |
| Credenciales | §3 | §22, §64, §91, §120 |
| GitHub | §4 | §60, §61, §63, §64, §90, §106, §107, §108 |
| Supabase y datos | §5, §6 | §19–§24, §69, §70 |
| Decisiones técnicas / de producto | §7, §8 | §67, §104 |
| Publicación | §9 | §92, §93 |
| Seguridad | §10 | §24, §55, §56, §82, §83, §97 |
| Errores y bloqueos | §11 | §119 |
| Reversibilidad / mínimo privilegio | §13, §14 | §117 |
| Evidencia y verificación | §16 | §111, §112, §122 |
| Offline y sincronización | — | §10, §11, §12, §15, §16, §17, §18, §33, §52, §53, §86, §87, §96 |
| PWA / WebView / nativo | — | §4, §94, §95, §125 |
| Actualizaciones | — | §59, §62, §63 |
| Roadmap y éxito | — | §113, §114, §115, §116, §123 |

### Anexo B — Método de esta consolidación

1. Extracción íntegra del texto de ambos `.docx` (comprobado: sin imágenes, sin encabezados ni
   pies, notas al pie y comentarios vacíos).
2. Verificación de cobertura: **17/17** secciones de Límites y **126/126** secciones (0–125) del
   Mega Prompt, sin huecos de numeración.
3. Inspección directa del repositorio (`git ls-files`, `git log`, Gradle, manifiesto, fuentes).
4. Comprobación del entorno de ejecución (JDK, Android SDK, Gradle, red, `gh auth status`).
5. Cruce documento-a-documento para detectar conflictos y precedencias.
6. Redacción consolidada: sin duplicidades, con relaciones explícitas y sin requisitos
   inventados.

**Ningún archivo de código, configuración, Supabase, GitHub ni infraestructura fue modificado
para producir este documento.**
