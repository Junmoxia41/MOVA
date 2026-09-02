# RELEASE Y ACTUALIZACIONES

## Versionado (§61)

`MAJOR.MINOR.PATCH`, coherente con `versionCode` y `versionName`.
Actual: `1.0.0` / `versionCode 1`.

## Tipos de cambio (§59)

| Cambio | Mecanismo |
| --- | --- |
| Kotlin, Compose, permisos, manifiesto, SDK, dependencias nativas, Room, WorkManager | **Nueva APK/AAB** |
| Textos, planes, mensajes, promociones, flags | **Supabase, sin reinstalar** |

## Comprobador de versión (§62)

La app conoce `currentVersion`, `minimumSupportedVersion` y `latestVersion`. Si hay
actualización nativa muestra 🔄 *Nueva versión disponible*.
**Nunca se instala una APK en silencio** sin el mecanismo de distribución autorizado.

## Rollback (§63)

Releases reversibles; artefactos anteriores conservados en GitHub Releases; **no se elimina
automáticamente la última versión estable**.

## Firma (§91)

La release firmada necesita keystore, alias y passwords gestionados **fuera del código**.
El agente no los inventa ni los filtra. `PENDIENTE DE DECISIÓN` (D4 de la especificación).

## Artefactos (§92)

`debug` y `release`. La release debe poder producir **APK** y preferentemente **AAB**.

## Autorizaciones (Límites §9)

Preparar APK, AAB, release notes, screenshots, metadata y assets es autónomo.
**Requieren autorización explícita**: publicar en Google Play, activar una release pública,
distribuir ampliamente una APK y cambiar producción.

## Google Play (§93)

El proyecto se prepara para Play; **la publicación final la decide el propietario**.
