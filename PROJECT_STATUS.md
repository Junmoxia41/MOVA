# MOVA STATUS

## Estado

**Fase 1 — BOOTSTRAP en curso.** Repositorio saneado, paquete renombrado y línea base de
documentación creada. Todavía no hay capa de datos ni UI propia.

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
- **Esquema Supabase**: migraciones iniciales en `supabase/migrations/` (§23) con RLS (§24).

## En desarrollo

- **Capa `core` y `domain`** (logging, conectividad, errores, modelos, casos de uso).

## Pendiente

- **Fase 1 (resto)**: navegación Compose y arquitectura por capas en el código.
- **Fase 2 — DATA**: Room, entidades, DAOs, repositories, aplicación de migraciones.
- **Fases 3–14**: auth, conductores, pasajero, reservas, agenda, offline/sync, reseñas,
  planes, admin, QA, CI, release.
- Workflow de GitHub Actions escrito en `.github/workflows/android-ci.yml` pero **sin publicar**
  (ver Problemas conocidos).

## Problemas conocidos

### BLOQUEO 1 — Sin verificación de compilación

- **Qué falta**: no se ha ejecutado ningún build ni test.
- **Por qué falta**: el entorno del agente no tiene JDK (`java: command not found`), ni Android
  SDK (`ANDROID_HOME` vacío), ni Gradle, y su red saliente está restringida a una lista blanca
  (`api.github.com` responde `200`; `dl.google.com` falla con error SSL; `repo1.maven.org` y
  `services.gradle.org` no responden). No se pueden descargar Gradle, el JDK ni dependencias.
- **Qué sí se pudo hacer**: todo el código, la configuración y la documentación.
- **Qué se necesita del propietario**: nada todavía; la vía prevista es GitHub Actions.

### BLOQUEO 2 — Permiso `workflows` en la GitHub App

- **Qué falta**: publicar `.github/workflows/android-ci.yml`.
- **Por qué falta**: el push fue rechazado con
  `refusing to allow a GitHub App to create or update workflow ... without 'workflows' permission`
  y la API devolvió `403 Resource not accessible by integration`.
- **Qué sí se pudo hacer**: el workflow está escrito y listo en el árbol de trabajo local.
- **Qué se necesita del propietario**: conceder permiso **`workflows` (write)** a la GitHub App
  de Arena sobre `Junmoxia41/MOVA`, o crear el fichero manualmente.

### BLOQUEO 3 — Credenciales de Supabase

- **Credencial requerida**: `SUPABASE_URL` y `SUPABASE_ANON_KEY` (PUBLIC CONFIG) de un proyecto
  de desarrollo.
- **Para**: cliente Supabase en la app (Auth, PostgREST, Storage).
- **Lugar donde debe configurarse**: `local.properties` (no versionado) → inyectado a
  `BuildConfig` en tiempo de build.
- **Por qué falta**: crear el proyecto Supabase implica crear una cuenta externa y posiblemente
  activar facturación, lo que exige autorización explícita (Límites §2 y §15). El agente no lo
  crea por su cuenta.
- **Qué sí se pudo hacer**: migraciones, RLS, seeds y todo el código que no depende de ellas.

## Próxima fase

**Fase 2 — DATA** en cuanto exista verificación de compilación: Room 2.8.x o 3.0.x (decisión
`D-002` en `docs/DECISIONS.md`), entidades, DAOs, `MovaDatabase` y repositories.
