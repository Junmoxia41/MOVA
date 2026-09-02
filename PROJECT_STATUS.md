# MOVA STATUS

## Estado

**Fase 2 — DATA en curso, verificada en CI.** Base de datos Room 3 operativa con su primera
entidad, capa de dominio con tests reales y pipeline en verde.
Falta el resto de entidades, los repositories y la UI propia.

**Última verificación real**: GitHub Actions run
[`33656287736`](https://github.com/Junmoxia41/MOVA/actions/runs/33656287736) sobre `193bb37` —
`testDebugUnitTest` ✅ (**8 tests ejecutados, 0 fallidos**, medido parseando los XML de
resultados, no inferido) · `lintDebug` ✅ · `assembleDebug` ✅ · `mova-debug-apk`
13 936 422 bytes (el salto desde 11,25 MB es el SQLite bundled empaquetado).

Toolchain confirmado compatible: AGP 9.4.0 + Gradle 9.6.0 + Kotlin 2.2.10 + **KSP 2.3.11** +
Room 3.0.2 + `compileSdk`/`targetSdk` 37 + JDK 25.

Versión del proyecto: `1.0.0` (`versionCode` 1) — nada publicado aún.

## Completado

- **Fase 0 — Auditoría**: análisis completo de los dos documentos normativos y del repositorio.
  Resultado en `docs/MOVA_SPECIFICATION.md` (24 secciones, 13 conflictos, 10 hallazgos,
  12 decisiones pendientes).
- **Higiene del repositorio**: creado `.gitignore`; `local.properties` desindexado de Git
  (Mega Prompt §90).
- **Identidad**: paquete movido de `com.example.mova` a `com.mova.santaclara` (§8) y
  `versionName` corregido a `1.0.0` siguiendo `MAJOR.MINOR.PATCH` (§61).
- **Permisos**: `INTERNET` y `ACCESS_NETWORK_STATE` en el manifiesto (§3, §52).
- **Documentación**: `README.md`, `PROJECT_STATUS.md`, `CHANGELOG.md` y 15 documentos en
  `docs/` (§101–§104).
- **Esquema Supabase**: 7 migraciones en `supabase/migrations/` con las **14 tablas** del §23,
  RLS en todas (§24), guards por trigger para `verification_status`, transiciones de reserva y
  una reseña por reserva completada. Seed de desarrollo en `supabase/seed/`.
  Comprobado estáticamente: 14/14 tablas, 14/14 con RLS, todas las funciones referenciadas
  existen y están definidas antes de usarse.
- **CI operativa** (Fase 13 adelantada): `.github/workflows/android-ci.yml` compila, testea y
  pasa lint en cada push, y publica el log como comentario del commit cuando falla.

## En desarrollo

- **Fase 2 — DATA**: quedan las entidades restantes (vehicles, bookings, availability,
  reviews, favorites, sync_operations), sus DAOs y los repositories.

## Añadido en Fase 2

- **Room 3.0.2** (`androidx.room3`) + **KSP 2.3.11** + `sqlite-bundled` 2.7.0.
- `MovaDatabase` con `BundledSQLiteDriver` y consultas en `Dispatchers.IO` (§48, §88).
- `DriverEntity` + `DriverDao`: la UI observa Room, que es la fuente de verdad (§12).
- Capa `domain`: `Driver`, `VerificationStatus`, `Availability`, `SyncStatus` y mappers que
  no conocen Room (§5).
- `AppContainer` manual y `MovaApplication` registrada; **sin red en el arranque** (§10).
- **PUBLIC CONFIG de Supabase** inyectada en `BuildConfig` desde `secrets.properties` o
  variables de entorno, nunca desde Git (§22). Si falta, compila con cadena vacía.
- Job de CI `Supabase connectivity` que comprueba el endpoint REST y reporta qué tablas
  del esquema responden.

## Pendiente

- **Fase 1 (resto)**: navegación Compose y arquitectura por capas en el código.
- **Fase 2 — DATA**: Room, entidades, DAOs, repositories, aplicación de migraciones.
- **Fases 3–14**: auth, conductores, pasajero, reservas, agenda, offline/sync, reseñas,
  planes, admin, QA, release.

## Problemas conocidos

### RESUELTO — Verificación de compilación

El entorno del agente sigue sin JDK, Android SDK ni red para descargarlos
(`dl.google.com`, `repo1.maven.org` y `services.gradle.org` no responden desde aquí), pero el
problema está resuelto por otra vía: **GitHub Actions compila y prueba cada push**.
Los logs de Actions viven en un blob externo igualmente inaccesible, así que el workflow
publica las últimas 120 líneas como **comentario del commit** cuando falla; ese es el canal de
diagnóstico que se usa para iterar.

### RESUELTO — Permiso `workflows` en la GitHub App

Concedido por el propietario. El workflow ya está publicado y en verde.

### ABIERTO — Credenciales de Supabase

- **Credencial requerida**: `SUPABASE_URL` y `SUPABASE_ANON_KEY` (PUBLIC CONFIG) de un proyecto
  de desarrollo.
- **Para**: cliente Supabase en la app (Auth, PostgREST, Storage).
- **Lugar donde debe configurarse**: `local.properties` (no versionado) → inyectado a
  `BuildConfig` en tiempo de build.
- **Por qué falta**: crear el proyecto Supabase implica crear una cuenta externa y posiblemente
  activar facturación, lo que exige autorización explícita (Límites §2 y §15). El agente no lo
  crea por su cuenta.
- **Qué sí se pudo hacer**: migraciones, RLS, seeds y todo el código que no depende de ellas.
- **Estado**: credenciales **recibidas** el 2026-09-02 (URL + clave `sb_publishable_…`,
  configuración pública de cliente). Están en `secrets.properties`, que **no está versionado**
  (`git check-ignore` lo confirma y `git status` queda vacío).
- **Qué sigue faltando**: la comprobación de conectividad en CI necesita los secrets
  `SUPABASE_URL` y `SUPABASE_ANON_KEY` en *Settings → Secrets and variables → Actions*.
  La GitHub App no puede crearlos (`403` en `/actions/secrets/public-key`).
  Hasta entonces el job se **omite** limpiamente en lugar de fallar.
- **No verificado**: ni la URL ni la clave se han validado contra el servidor. El entorno del
  agente no alcanza `*.supabase.co` (error SSL de egress). Tampoco se han aplicado las
  migraciones: PostgREST no ejecuta DDL y no hay conexión Postgres ni Management API.

## Próxima fase

Terminar **Fase 2**: resto de entidades y DAOs, repositories sobre Room y el cliente Supabase
tras una interfaz. En paralelo, aplicar las migraciones al proyecto (lo ejecuta el propietario
en el SQL Editor, o se automatiza cuando exista un canal con permisos).
