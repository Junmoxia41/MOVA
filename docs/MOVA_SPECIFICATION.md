# MOVA — ESPECIFICACIÓN CONSOLIDADA

> **Documento de referencia maestro.** Consolida la información procedente de:
> - 🔐 **LÍMITES DE AUTONOMÍA DEL AGENTE** (documento de gobernanza).
> - 🚕 **MOVA — MEGA PROMPT MAESTRO DE DESARROLLO** (documento técnico-producto).
>
> Cuando exista conflicto entre ambos, prevalece el documento de **LÍMITES DE AUTONOMÍA** en todo lo referente a permisos, gastos, producción, datos reales y publicación. En lo técnico-producto, prevalece el Mega Prompt, salvo que introduzca una acción reservada al propietario.
>
> **Regla de no invención:** este documento refleja lo que ambos textos indican. Lo que no esté definido se marca como `PENDIENTE DE DECISIÓN`.

---

## 1. Objetivo

MOVA es una plataforma local de movilidad que conecta **pasajeros** con **conductores independientes**, ofreciendo un sistema sencillo para descubrir, contactar, reservar y organizar servicios de transporte.

- **Ubicación inicial:** Santa Clara, Villa Clara, Cuba.
- **Tipo de producto inicial:** Directorio + Reservas + Agenda + Gestión de conductores + Movilidad local.
- **Visión de plataforma:** no es una copia de Uber, Didi ni Cabify; es una solución local con identidad propia, orientada a la realidad cubana.
- **Eslogan provisional:** *"Tu ciudad. Tu ruta. Tu movimiento."*

---

## 2. Producto

### Tipos de servicios iniciales
- 🚕 Taxi
- 🛺 Triciclo
- 🏍️ Moto
- 🚗 Auto
- 🚐 Van
- 📦 Transporte de carga
- 🚐 Viajes programados
- 🛣️ Viajes intermunicipales

### Servicios diferidos (arquitectura preparada, no implementados en V1)
- Tracking GPS continuo.
- Pagos integrados.
- Mapas en tiempo real.
- Push remoto.

### Principios rectores del producto
- MVP real + arquitectura escalable.
- Prioridad: **Funcionalidad > Estabilidad > Seguridad > Mantenibilidad > Escala**.
- No introducir tecnologías innecesarias.
- Optimizar para teléfonos económicos.

---

## 3. Usuarios y roles

| Rol | Capacidades principales |
|---|---|
| **VISITANTE** | Explorar, buscar, ver perfiles públicos, ver vehículos, consultar zonas, llamar. No requiere cuenta. |
| **PASAJERO** | Reservar, cancelar, favoritos, historial, reseñas, perfil. |
| **CONDUCTOR** | Administrar perfil, vehículo, disponibilidad, agenda, reservas, estadísticas. |
| **ADMIN** | Aprobar y suspender conductores, gestionar usuarios/planes/zonas, gestionar reseñas, revisar reservas y métricas, configuración de plataforma. |

> La autorización real de cada rol se protege vía RLS en Supabase + verificación de rol en la app.

---

## 4. Funcionalidades (V1)

### Núcleo del producto
- **Autenticación:** email/password (OTP/teléfono preparados para futuro).
- **Perfiles de conductor** con verificación.
- **Vehículos** asociados a conductor (TAXI, TRICYCLE, MOTORCYCLE, CAR, VAN, CARGO, OTHER).
- **Disponibilidad:** AVAILABLE / BUSY / OFF_DUTY / UNAVAILABLE.
- **Agenda del conductor** (horario, disponibilidad, reservas, bloqueos, vista día/semana).
- **Búsqueda y filtros** (nombre, tipo de vehículo, zona, disponibilidad).
- **Reservas** con estados: PENDING / ACCEPTED / REJECTED / CANCELLED / COMPLETED / EXPIRED.
- **Favoritos** (Room inmediato + Supabase cuando sincronice).
- **Reseñas** (solo tras reserva completada; rating, puntualidad, trato, vehículo, comentario).
- **Llamar / Contactar** vía Intent (marcador) o WhatsApp como opción, nunca como requisito.
- **Planes** (FREE, PRO, PREMIUM) — precios configurables remotamente, no hardcodeados.
- **Administración** (vía app Android o panel web — decisión pendiente).
- **Notificaciones locales** (estados de reserva); push remoto solo preparado, no implementado en V1.
- **Verificación del conductor** (PENDING / VERIFIED / REJECTED / SUSPENDED).
- **Auditoría** (quién / qué / cuándo / resultado) sobre acciones administrativas.

### Excluido de V1
- Pagos reales / pasarela.
- Tracking GPS continuo.
- Mapas en tiempo real / Google Maps obligatorio.
- Push remoto.
- Modelo de comisión obligatoria por viaje.

---

## 5. Arquitectura

### Capas
```
                 MOVA
                  │
           Jetpack Compose
                  │
             ViewModels
                  │
              Use Cases
                  │
             Repositories
              /        \
             /          \
          Room       Supabase
              \        /
               \      /
              Sync Engine
                  │
             WorkManager
                  │
             Offline First
```

### Estructura propuesta
```
mova/
├── app/
│   └── src/main/java/com/mova/santaclara/
│       ├── core/        (common, network, connectivity, logging, security)
│       ├── data/        (local/room, dao, remote/supabase, repository, sync)
│       ├── domain/      (model, usecase)
│       ├── feature/     (auth, home, search, driver, passenger, booking, schedule,
│       │                 favorites, reviews, profile, admin)
│       ├── navigation/
│       └── MainActivity.kt
├── supabase/
│   ├── migrations/
│   ├── seed/
│   └── functions/
├── docs/
├── tests/
├── .github/workflows/
├── gradle/
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── .gitignore
├── README.md
├── CHANGELOG.md
├── PROJECT_STATUS.md
└── LICENSE
```

> Esta estructura puede mejorarse si existe una alternativa técnicamente superior, manteniendo la separación de responsabilidades.

### Regla de tamaño
- Ningún archivo de código debería superar ~200 líneas (Kotlin, SQL, configs, scripts).
- Si crece, dividir / extraer componentes / separar responsabilidades.
- No fragmentar absurdamente solo para cumplir el número.

---

## 6. Tecnologías permitidas (Stack obligatorio)

- **Lenguaje:** Kotlin.
- **IDE:** Android Studio.
- **UI:** Jetpack Compose (Material 3 cuando sea apropiado).
- **Arquitectura:** MVVM + Clean Architecture ligera.
- **Persistencia local:** Room (fuente de verdad para la UI).
- **Preferencias/flags:** DataStore.
- **Trabajos persistentes:** WorkManager.
- **Conectividad:** Android Connectivity APIs.
- **Backend:** Supabase (PostgreSQL, Auth, Storage, PostgREST).
- **Realtime:** solo si aporta valor real y el consumo lo justifica.
- **Edge Functions:** solo cuando sean necesarias.
- **Control de versiones:** Git + GitHub.
- **CI/CD:** GitHub Actions.
- **Cliente Supabase Android:** supabase-kt (verificar versiones actuales compatibles entre Kotlin, supabase-kt, Ktor y Android).

### Política de dependencias
- Mantener el número de dependencias bajo.
- Antes de añadir una librería, preguntar: *¿Android/Jetpack ya resuelve esto?* Si sí, preferir la solución nativa.

---

## 7. Tecnologías prohibidas

No se utilizarán como framework principal:

- Flutter
- React Native
- React
- Next.js
- Vue
- Angular
- Ionic
- Cordova
- Capacitor
- **WebView como núcleo de la aplicación**

MOVA no se construirá como una web empaquetada. Debe ser **Android nativo**.

Tampoco se debe:
- Usar Firebase "porque es habitual" — evaluar alternativa real.
- Añadir sistemas analíticos pesados.
- Usar SharedPreferences como base de datos principal.
- Usar DataStore para grandes colecciones.
- Implementar criptografía casera.

---

## 8. Offline First

**Regla central:** la app debe seguir funcionando sin Internet.

Cuando no haya conexión, MOVA debe poder:
- Abrir.
- Mostrar datos disponibles localmente.
- Consultar información almacenada.
- Ver reservas.
- Consultar agenda.
- Modificar operaciones permitidas.
- Registrar cambios.
- Colocar operaciones pendientes en cola.

Flujo conceptual: **Local First → Cloud Sync**.

Indicadores visuales en UI:
- 🟠 Sin conexión (discreto, no bloqueante).
- 🟠 Pendiente de sincronización.
- 🟢 Sincronizada.
- 🔴 No sincronizada (pero conservando la información).

---

## 9. IndexedDB — PENDIENTE DE DECISIÓN

**MOVA es una aplicación Android nativa.** IndexedDB es una tecnología del navegador/web y **no forma parte del núcleo del producto**.

El prompt del propietario menciona IndexedDB en el listado de temas a entender; sin embargo, tanto el Mega Prompt (secciones 94, 95) como los Límites de Autonomía son explícitos en que MOVA es una app Android nativa, que no se debe construir como web empaquetada y que **una PWA no es requisito del núcleo**.

> **Decisión recomendada (alineada con los dos documentos):** IndexedDB no aplica al cliente Android nativo. La persistencia local es **Room** (no IndexedDB). Si en el futuro se desarrolla una capa PWA/web complementaria, esa capa sí podría usar IndexedDB, pero sería un proyecto separado y nunca contaminará la arquitectura Android nativa.

---

## 10. Sincronización

### Entidad `SyncOperation`
- Campos: `id`, `entity`, `entity_id`, `operation`, `payload`, `created_at`, `status`, `retry_count`, `last_attempt_at`, `last_error`.
- Estados: `PENDING`, `PROCESSING`, `SYNCED`, `FAILED`, `CONFLICT`.

### Flujo online
```
Internet disponible
   ↓
WorkManager
   ↓
SyncWorker
   ↓
leer operaciones pendientes
   ↓
procesar
   ↓
enviar a Supabase
   ↓
recibir respuesta
   ↓
actualizar Room
   ↓
marcar sincronizada
```

### Flujo offline
```
guardar localmente
   ↓
PENDING
   ↓
esperar conectividad
```

### Reintentos
- Backoff apropiado. No bombardear Supabase.
- Errores temporales → retry.
- Errores permanentes → `FAILED`.
- Conflictos → `CONFLICT`.

### Conflictos
- Diseñar la arquitectura para conflictos.
- Usar `updated_at`, `version`, `operation id`, timestamps.
- No sobrescribir datos silenciosamente.
- Cuando exista un conflicto importante: registrar, preservar datos, resolver según reglas, evitar pérdida.

### Prueba de apagón (obligatoria)
El usuario debe poder: crear operación → sin Internet → operación guardada → apagar teléfono → encender → Room intacto → vuelve Internet → WorkManager → Sync. **No perder información.**

---

## 11. Supabase

- **Un único proyecto Supabase** para la V1.
- Uso previsto: PostgreSQL + Auth + Storage + PostgREST (+ Realtime solo si aporta, + Edge Functions solo si necesario).
- **Coste objetivo inicial: 0.** Diseñar evitando:
  - Polling continuo.
  - Consultas innecesarias.
  - Realtime en exceso.
  - Imágenes gigantes.
  - Datos duplicados.
  - Archivos innecesarios.
  - Edge Functions innecesarias.

### Migraciones
Tablas iniciales previstas (ajustables tras análisis):
- `profiles`
- `drivers`
- `vehicles`
- `service_areas`
- `driver_availability`
- `bookings`
- `reviews`
- `favorites`
- `driver_plans`
- `subscriptions`
- `notifications`
- `app_config`
- `audit_logs`
- `sync_metadata`

Cada tabla debe tener: UUID, timestamps, foreign keys, constraints, índices, RLS.

### Estrategia de migraciones
Preferir siempre: **ADD → MIGRATE → DEPRECATE → REMOVE**, en lugar de eliminar directamente.

---

## 12. Seguridad

### Reglas fundamentales
- **No inventar credenciales** ni obtenerlas por medios no autorizados.
- **No escribir secretos en el código** ni en el repositorio.
- **No mostrar secretos completos en logs.**
- **No guardar en GitHub:** service role key, secretos privados, credenciales de administrador, `.env`, release keys privadas, datos de producción.
- **La app móvil solo usará la credencial pública** apropiada para el cliente.
- Configurar credenciales mediante mecanismo de build adecuado para Android.
- Documentar diferencia entre `PUBLIC CONFIG` y `SECRET CONFIG`.

### Row Level Security (RLS)
- **Todas las tablas sensibles** deben usar RLS.
- Ejemplos:
  - Conductor: ✅ modificar su propio perfil / ❌ modificar otro conductor.
  - Pasajero: ✅ acceder a sus reservas / ❌ acceder a reservas privadas de otros.
  - Admin: ✅ administrar recursos autorizados.
- No crear políticas excesivamente amplias sin justificación.

### Clasificación de datos
- `PUBLIC` / `AUTHENTICATED` / `PRIVATE` / `ADMIN` — aplicar políticas y almacenamiento de acuerdo con ello.

### Seguridad local
Cuando corresponda: Android Keystore, cifrado, almacenamiento seguro, tokens protegidos. **No implementar criptografía casera.**

### Logging
- Niveles: DEBUG, INFO, WARN, ERROR.
- En producción **NO registrar**: contraseñas, tokens, claves, datos personales innecesarios.

### Privacidad
- Guardar solamente información necesaria.
- No registrar ubicación permanente de todos los usuarios.
- No recopilar datos sin motivo.

### Respuesta ante incidentes
Si se detecta: vulnerabilidad crítica, credencial expuesta, política RLS insegura, fuga de datos, dependencia comprometida → **priorizar la mitigación**. Corregir automáticamente problemas técnicos reversibles; para revocar credenciales o afectar producción, explicar el riesgo y solicitar autorización.

---

## 13. Android

- **App nativa Android**, Android Studio, Kotlin, Jetpack Compose.
- **minSdk / targetSdk / compileSdk:** verificar versiones actualmente soportadas por herramientas y dependencias elegidas; no inventar valores.
- Versiones coherentes de `versionCode` y `versionName`, en formato `MAJOR.MINOR.PATCH`.
- Permisos: usar solo los necesarios. No solicitar permisos innecesarios.
- Hardware usado en V1: teléfono, red, notificaciones, cámara (para foto), ubicación **solo preparada para futuro**.
- **No usar WebView** como núcleo; si en el futuro alguna función requiere web externa, usar navegador/Custom Tab.

### Estado actual del repositorio
- Proyecto Android Studio recién inicializado (`com.example.mova`).
- Compose activo, Material3, sin Room, sin Supabase, sin WorkManager, sin DataStore aún.
- Sin código de producto (solo `MainActivity` con Greeting "Hello Android!").
- `local.properties` contiene ruta local de SDK de Windows; no debe commitearse (debe estar en `.gitignore`).
- Gradle 9.6.0, AGP 9.4.0, Kotlin 2.2.10, JDK 11, Compose BOM 2026.02.01.

---

## 14. PWA

**No es requisito del núcleo.** MOVA es Android nativo.

- No desarrollar una PWA paralela simplemente por obligación.
- Si posteriormente se considera útil una versión web, deberá tratarse como **proyecto/capa adicional**, no contaminando la arquitectura Android nativa.
- **WebView queda prohibido como núcleo de la app.**

---

## 15. GitHub

### Usos permitidos
- Repositorio de código fuente.
- Commits, ramas, issues.
- Releases (de desarrollo) y artefactos.
- GitHub Actions (CI/CD).
- Documentación técnica.

### Usos prohibidos
- **No usar GitHub como base de datos.**
- No almacenar datos de pasajeros o conductores.
- No incluir `.env`, secretos, release keys privadas, datos de producción.

### Operaciones permitidas por el agente
- Crear ramas, commits, PRs, workflows.
- Crear releases de desarrollo.
- Preparar artefactos (APK debug, AAB, etc.).

### Operaciones prohibidas por el agente
- Borrar el repositorio.
- Borrar la rama principal.
- Sobrescribir historial de forma destructiva.
- Eliminar ramas importantes.
- Publicar secretos.
- Modificar permisos de la organización o cuenta sin autorización.
- Force-push destructivo sobre ramas protegidas.

### Estrategia de ramas (si la complejidad lo justifica)
- `main`
- `develop`
- `feature/*`
- `fix/*`

(Si el proyecto no lo justifica, no crear ramas innecesarias.)

---

## 16. Actualizaciones

### Cambios nativos (requieren nueva APK/AAB)
Cambios en Kotlin, Compose, permisos, AndroidManifest, SDK, dependencias nativas, Room, WorkManager o capacidades Android.

### Cambios configurables (llegan sin reinstalar)
Textos, planes, mensajes, promociones, parámetros, flags — gestionados vía tabla `app_config` en Supabase.

### Update check
- La app puede conocer: `currentVersion`, `minimumSupportedVersion`, `latestVersion`.
- Si hay nueva versión nativa: mostrar `🔄 Nueva versión disponible`.
- **No instalar silenciosamente una APK** sin mecanismo de distribución/autorización apropiado.

### Rollback
- Releases reversibles.
- Conservar artefactos anteriores en GitHub Releases cuando corresponda.
- No eliminar automáticamente la última versión estable.

---

## 17. Modelo comercial

- **V1 gratuita para pasajeros.**
- Los conductores podrán pagar por: **visibilidad / suscripción** (planes FREE, PRO, PREMIUM).
- **No cobrar comisión obligatoria por viaje en V1.**
- Precios no hardcodeados: configurar remotamente mediante Supabase.
- Sin pasarela de pago en V1; el sistema registrará únicamente: `subscription`, `status`, `amount`, `currency`, `start_date`, `end_date`, `payment_reference`. Mecanismo real de pago se decidirá posteriormente.
- **No debe convertirse en clon de Uber/Didi/Cabify**; reglas de distribución equilibradas (los conductores gratuitos no deben desaparecer completamente).

### Metas comerciales iniciales (validación)
1. 5 conductores.
2. 20 conductores.
3. 50+ conductores.
4. Después: expansión a otras localidades.

---

## 18. Reglas de desarrollo

### Límite de tamaño
~200 líneas por archivo (Kotlin, SQL, configs).

### Commits
Mensajes claros, p. ej.:
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

### Documentación obligatoria
- `README.md`
- `docs/`: ARCHITECTURE, ANDROID, DATABASE, SUPABASE, OFFLINE, SYNC, SECURITY, RELEASE, GITHUB, ADMIN, DRIVER, PRODUCT, DECISIONS, ROADMAP, TESTING.
- `PROJECT_STATUS.md` (estado, completado, en desarrollo, pendiente, problemas, próxima fase).
- `CHANGELOG.md` (Added / Fixed / Changed por versión).
- `docs/DECISIONS.md` (registro de decisiones importantes: arquitectura, librerías, Supabase, Room, sync, distribución).
- `FINAL_AUDIT.md` al cierre (auditoría completa).

### Reglas de calidad
- **Anti-Dummy:** no crear botones que no hagan nada, ni usar `TODO` / `Coming Soon` / `alert(...)` como sustituto de funcionalidad real.
- **Anti-Mock:** no usar datos simulados en producción; mocks solo para tests, desarrollo, demos controladas.
- **Regla de verificación:** nunca decir "Compila" / "Supabase funciona" / "GitHub configurado" / "Offline funciona" sin haberlo verificado. La evidencia válida es **Código + Prueba + Verificación**.
- **Optimización:** evitar recomposiciones innecesarias, imágenes pesadas, consultas grandes, operaciones bloqueantes en UI, trabajo pesado en main thread.
- **Accesibilidad:** content descriptions, tamaños, contraste, textos legibles, navegación clara, feedback visible.
- **Manejo de errores humano:** nunca mostrar `NullPointerException`, `HTTP 500`, `SocketException` al usuario; mostrar mensajes humanos y registrar detalles técnicos en logs.

### Pruebas obligatorias
- **Unitarias:** casos de uso, validaciones, estados, sincronización, ranking, reservas.
- **Room:** inserción, actualización, eliminación, consultas, persistencia.
- **Sincronización:** online, offline, crear reserva offline, cerrar/abrir app, volver online, WorkManager, Supabase responde/no responde, reintento, conflicto.
- **Apagón:** definida en la sección de sincronización.

---

## 19. Límites de autonomía

El agente tiene **autonomía amplia** para desarrollar MOVA, pero respetando estrictamente:

### Puede actuar sin pedir confirmación
- Crear y modificar archivos del proyecto.
- Crear carpetas y módulos.
- Instalar dependencias razonables.
- Ejecutar comandos, tests, lint, builds.
- Corregir errores de compilación.
- Refactorizar.
- Crear migraciones SQL.
- Crear documentación y scripts.
- Configurar Git local.
- Crear commits, ramas, workflows, releases de desarrollo.
- Analizar logs, optimizar consultas.
- Mejorar UX/UI.
- Crear datos ficticios de desarrollo.
- Ejecutar pruebas offline.
- Revisar seguridad básica.
- Proponer decisiones técnicas de bajo riesgo y aplicarlas si son reversibles.

### Regla general
> *"Actúa solo cuando la acción sea técnicamente segura, reversible y esté dentro del alcance del proyecto. Detenerte únicamente ante acciones financieras, legales, destructivas, irreversibles, de producción crítica o que requieran una credencial/autorización del propietario."*

> El objetivo: **AUTÓNOMO PARA CONSTRUIR, CONTROLADO PARA DECIDIR.**

---

## 20. Acciones que requieren autorización explícita

El agente **NO debe** realizar sin autorización:

### Dinero, contratos, legal
- Gastar dinero o crear obligaciones financieras.
- Crear una suscripción de pago, activar servicio con facturación.
- Comprar dominio, infraestructura.
- Cambiar un plan de Supabase a uno de pago.
- Contratar servicios externos, realizar pagos.
- Publicar comercialmente bajo la identidad del propietario.
- Firmar contratos, aceptar términos legales en nombre del propietario.
- Registrar marca, registrar empresa, crear cuentas financieras.
- Acceder a información bancaria.
- Solicitar documentos oficiales de identidad.
- Enviar comunicaciones comerciales masivas.
- Crear cuentas con datos personales no proporcionados específicamente para ello.

### Producción, datos y credenciales
- Eliminar datos reales.
- Eliminar un repositorio.
- Force-push destructivo sobre ramas protegidas.
- Rotar o revocar credenciales de producción sin autorización.
- Modificar DNS de producción de forma irreversible.
- Cambiar configuraciones críticas de producción con riesgo de pérdida de datos.

### Publicación
- Publicar en Google Play.
- Activar una release pública.
- Distribuir ampliamente una APK.
- Cambiar producción.

### Operaciones destructivas sobre Supabase
- `DROP TABLE` con datos de producción.
- `DELETE` masivo.
- `TRUNCATE`.
- Migración destructiva.
- Cambio irreversible de esquema.

### Ante bloqueo o credencial faltante
- No inventar, no obtener por medios no autorizados, no escribir en código, no mostrar secretos.
- Detener **únicamente** la tarea dependiente de esa credencial.
- Continuar con todo lo que pueda desarrollarse sin ella.
- Informar exactamente qué credencial falta y para qué se necesita.

### Ante error o bloqueo
Formato obligatorio:
```
BLOQUEO
Problema: ...
Causa: ...
Qué puedo solucionar automáticamente: ...
Qué necesito del propietario: ...
```
Y continuar con las tareas independientes.

---

## 21. Criterios de éxito (MVP)

MOVA MVP se considerará listo cuando se cumplan **todos** los puntos:

- ☑ Android Studio abre el proyecto.
- ☑ Gradle sincroniza.
- ☑ APK compila.
- ☑ La app inicia.
- ☑ Compose funciona.
- ☑ Registro funciona.
- ☑ Login funciona.
- ☑ Roles funcionan.
- ☑ Conductor puede crear perfil.
- ☑ Conductor puede crear vehículo.
- ☑ Conductor puede configurar agenda.
- ☑ Pasajero puede buscar.
- ☑ Pasajero puede ver conductor.
- ☑ Pasajero puede reservar.
- ☑ Conductor puede aceptar.
- ☑ Reserva puede completarse.
- ☑ Reseña funciona.
- ☑ Room funciona.
- ☑ Supabase funciona.
- ☑ RLS funciona.
- ☑ Offline funciona.
- ☑ Sincronización funciona.
- ☑ WorkManager funciona.
- ☑ Recuperación tras reinicio funciona.
- ☑ GitHub funciona.
- ☑ CI funciona.
- ☑ Documentación existe.

---

## 22. Roadmap (Fases)

| Fase | Nombre | Entregables |
|---|---|---|
| **0** | Auditoría | Analizar repo, Android Studio, Kotlin, Gradle, SDK, Git, Supabase, archivos existentes. |
| **1** | Bootstrap | Proyecto Android, Kotlin, Compose, navegación, arquitectura base, Git, README. |
| **2** | Data | Room, entidades, DAOs, repositories, Supabase, migraciones, RLS. |
| **3** | Auth | Login, registro, sesión, perfiles, roles. |
| **4** | Conductores | Perfil, vehículo, disponibilidad, verificación. |
| **5** | Pasajero | Inicio, búsqueda, filtros, perfiles, favoritos. |
| **6** | Reservas | Creación, aceptación, rechazo, cancelación, completado, historial. |
| **7** | Agenda | Calendario, disponibilidad, bloqueos, reservas. |
| **8** | Offline | Room como fuente local, Sync Queue, WorkManager, reintentos, conflictos. |
| **9** | Reviews | Valoración, comentarios, puntuaciones. |
| **10** | Planes | FREE, PRO, PREMIUM, configuración remota. |
| **11** | Admin | Dashboard, conductores, usuarios, reservas, planes, reseñas, configuración. |
| **12** | QA | Pruebas completas. |
| **13** | GitHub | Actions, builds, tests, releases. |
| **14** | Release | APK / AAB (preparación; publicación requiere autorización). |

---

## 23. Conflictos detectados entre documentos

Se revisaron los dos documentos en busca de contradicciones reales. Resultado:

### CRÍTICOS
- *No se detectaron contradicciones críticas bloqueantes.* Ambos documentos son internamente coherentes en lo esencial: el Mega Prompt manda técnicamente; los Límites de Autonomía mandan en permisos, gastos, producción y publicación.

### ALTOS
- **IndexedDB / PWA en el prompt del usuario vs. naturaleza nativa del producto.** El usuario lista "PWA" e "IndexedDB" como temas a entender. Sin embargo, el Mega Prompt (sección 94) establece que una PWA **no es requisito del núcleo** y que la app debe ser Android nativa (sección 95: no WebView como núcleo). Los Límites de Autonomía no contradicen esto. **Resolución adoptada:** IndexedDB no aplica al cliente Android nativo; persistencia local = Room. Si se abordara una capa web futura, sería proyecto separado, sin contaminar la arquitectura Android. Ver sección 9 de este documento.

### MEDIOS
- **Publicación en Google Play / release pública.** El Mega Prompt (sección 14) dice preparar AAB/APK; los Límites de Autonomía (sección 9) dicen que publicar requiere autorización. **No hay conflicto real:** el Mega Prompt describe la preparación técnica; los Límites exigen autorización para la acción de publicar. Se respeta la jerarquía Límites > Mega Prompt.
- **Operaciones de Supabase.** El Mega Prompt permite crear tablas/índices/migraciones/RLS; los Límites exigen detenerse ante operaciones destructivas sobre datos reales. **No hay conflicto:** se ejecutan migraciones no destructivas (`ADD → MIGRATE → DEPRECATE → REMOVE`) y se requiere autorización ante `DROP`/`DELETE` masivo/`TRUNCATE`.
- **Decisiones de producto (precios, comisiones, políticas).** El Mega Prompt propone planes, pero los Límites indican que las decisiones empresariales finales (precios, comisiones, modelo de negocio) corresponden al propietario. **No hay conflicto:** el agente puede preparar la implementación y dejar precios configurables remotamente, sin asumir definitivos.

### BAJOS
- **Versiones SDK y dependencias.** El Mega Prompt pide no inventar valores; el repositorio actual usa `minSdk 24`, `targetSdk 37`, `compileSdk 37`, AGP 9.4.0, Kotlin 2.2.10, Gradle 9.6.0. Ambos documentos coinciden en verificar documentación oficial antes de fijar versiones. No hay conflicto; queda como **verificación continua** en próximas fases.

> **Criterio de prioridad:** ante cualquier duda entre un detalle técnico del Mega Prompt y una restricción de los Límites, prevalece el documento de Límites. Ante ambigüedad técnica, prevalece el Mega Prompt siempre que no active una acción reservada al propietario.

---

## 24. Decisiones pendientes

`PENDIENTE DE DECISIÓN` — ítems que los documentos no fijan y requieren acuerdo del propietario:

1. **Panel de administración:** ¿app Android de admin, panel web separado, o ambos? (Mega Prompt sección 71).
2. **Pasarela de pago real:** mecanismo final para cobrar suscripciones de conductores (Mega Prompt sección 41).
3. **Push remoto:** si se decide más adelante, qué proveedor/alternativa concreta y sus costes (Mega Prompt sección 46).
4. **Mapas:** cuándo y con qué proveedor (OpenStreetMap, etc.) cuando se introduzca (Mega Prompt sección 44).
5. **GPS / tracking:** momento y alcance de su activación (Mega Prompt sección 45).
6. **Notificaciones:** canal exacto para los estados de reserva (locales confirmados, push remoto pendiente).
7. **Branding / icono:** versión definitiva del icono MOVA (actualmente hay un icono genérico generado por Android Studio).
8. **Teléfonos / OTP:** cuándo y si se activa autenticación por OTP (preparada, no implementada).
9. **Project ID / URL de Supabase:** credencial necesaria para activar la integración real; debe ser proporcionada por el propietario (Límites, sección 3).
10. **Keystore de release:** el agente no debe inventar ni filtrar la clave de firma; el propietario debe aportar keystore + alias + password cuando se vaya a generar APK/AAB firmada (Mega Prompt sección 91).
11. **`local.properties` con ruta de SDK de Windows:** debe asegurarse de que este archivo quede en `.gitignore` antes de cualquier commit.
12. **Renombrado de paquete:** el proyecto actual usa `com.example.mova`; el Mega Prompt propone `com.mova.santaclara`. Decidir antes de la primera release para evitar migraciones costosas.
13. **Estrategia de build/configuración para credenciales públicas Supabase en Android:** el Mega Prompt (sección 22) advierte que las apps móviles no reciben variables de entorno como una app web; debe definirse el mecanismo concreto (build flavors, `local.properties` ignorado por git, `BuildConfig`, etc.).

---

## 25. Estado actual del repositorio (auditoría)

> Resumen de lo que existe **hoy** en el repo, para situar la siguiente fase de desarrollo.

- **Rama activa:** `main`.
- **Remoto:** `origin` → `https://github.com/Junmoxia41/MOVA.git`.
- **Últimos commits:** tres commits "Add files via upload" — sin mensajes semánticos.
- **Stack Gradle:** Gradle 9.6.0, AGP 9.4.0, Kotlin 2.2.10, JDK 11, Compose BOM 2026.02.01.
- **Configuración Android:** `compileSdk 37`, `targetSdk 37`, `minSdk 24`, `versionCode 1`, `versionName "1.0"`.
- **Build types:** `release` con `optimization { enable = false }` (placeholder).
- **Paquete actual:** `com.example.mova` (candidato a renombrar a `com.mova.santaclara`).
- **Código de producto:** solo `MainActivity` con `Greeting("Android")` — proyecto recién inicializado.
- **Estructura de carpetas:** solo `app/src/main/java/com/example/mova/...` con `ui/theme/` (Color, Theme, Type) — no existe aún la estructura `core/data/domain/feature` propuesta por el Mega Prompt.
- **Recursos:** iconos por defecto de Android Studio (no branding MOVA), tema `Theme.MOVA` definido.
- **Tests:** un test unitario y un instrumentado generados por plantilla, sin contenido real.
- **Documentación:** no existe `README.md`, ni `docs/`, ni `CHANGELOG.md`, ni `PROJECT_STATUS.md`. Este documento es la **primera** pieza de documentación.
- **Archivos sensibles detectados:**
  - `local.properties` contiene `sdk.dir` apuntando a `C:\Users\airienrr\AppData\Local\Android\Sdk` — **no debe commitearse**.
  - No existe `.gitignore` explícito en la raíz (revisar; debe añadirse si falta).
- **Supabase / WorkManager / Room / DataStore / navegación:** no presentes.
- **Workflows de GitHub Actions:** no existen.

---

## 26. Próximo paso recomendado (orientativo, no autorizado)

Cuando el propietario autorice pasar a la fase de implementación, el orden natural es:

1. **Fase 0 — Auditoría** ya completada en parte con este documento.
2. Renombrar paquete a `com.mova.santaclara` (decisión 12).
3. Crear `.gitignore` adecuado (incluir `local.properties`, `*.keystore`, `*.jks`, `secrets/`, `.env*`).
4. Configurar la rama `develop` y el modelo de ramas.
5. Iniciar **Fase 1 — Bootstrap**: estructura de carpetas `core/data/domain/feature`, navegación Compose, splash, branding mínimo.
6. Continuar con **Fase 2 — Data** y siguientes según el roadmap, siempre respetando los Límites de Autonomía.

> **Recordatorio:** nada de esto se ejecuta todavía. La presente etapa es de análisis y documentación.

---

*Fin de la especificación consolidada.*
