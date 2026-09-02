# MOVA STATUS

## Estado

**Fase 1 — BOOTSTRAP verificada en CI.** Repositorio saneado, paquete `com.mova.app`, documentación
completa, esquema Supabase escrito y **pipeline de compilación en verde**.
Todavía no hay capa de datos (Room) ni UI propia.

**Última verificación real**: GitHub Actions run
[`33651715254`](https://github.com/Junmoxia41/MOVA/actions/runs/33651715254) sobre `c248d1a` —
`testDebugUnitTest` ✅ · `lintDebug` ✅ · `assembleDebug` ✅ · artefacto `mova-debug-apk`
(11 253 992 bytes). Esto confirma además que AGP 9.4.0 + Gradle 9.6.0 + Kotlin 2.2.10 +
`compileSdk`/`targetSdk` 37 + toolchain JDK 25 son compatibles entre sí.

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

- **Fase 2 — DATA**: Room, entidades, DAOs y repositories (siguiente incremento, con
  verificación en CI).

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
- **Estado**: el propietario ha confirmado que creará el proyecto y facilitará
  `SUPABASE_URL` y `SUPABASE_ANON_KEY`. **Aún no se han recibido.**

## Próxima fase

**Fase 2 — DATA** con verificación en CI: Room, entidades, DAOs, `MovaDatabase`,
repositories y el cliente Supabase tras una interfaz (para que la app funcione antes de
recibir las credenciales).
