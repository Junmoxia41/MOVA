# GITHUB

## Para qué se usa (§60)

Repositorio, commits, ramas, issues, releases, Actions y artefactos.
**No se usa como base de datos** y no almacena datos de pasajeros ni conductores.

## Contenido del repo (§90)

Incluye: source, docs, migrations, tests, workflows.
Excluye: `.env`, secretos, release keys privadas, datos de producción, `local.properties`,
keystores.

## Ramas (§108)

`main` · `develop` · `feature/*` · `fix/*`, **si la complejidad lo justifica**.
Sin ramas innecesarias. Prohibido borrar ramas importantes, borrar la rama principal o
reescribir historial de forma destructiva (Límites §4).

## Commits (§107)

Mensajes claros y en imperativo:

```
chore: initialize Android project
feat: add Room database
feat: add Supabase authentication
feat: add offline synchronization
fix: resolve booking sync conflict
```

Disciplina (§121): tras cambios importantes → `git status`, commit coherente y actualización
de `PROJECT_STATUS.md`.

## GitHub Actions (§64, §106)

Workflows de build, test y lint sobre pull request, con artefactos debug APK.
Secretos siempre por **GitHub Secrets**. **Nunca se publica automáticamente una versión de
producción.**

Estado: `.github/workflows/android-ci.yml` **publicado y en verde**. Ejecuta
`testDebugUnitTest`, `lintDebug` y `assembleDebug` en cada push, sube el APK debug como
artefacto y, cuando algo falla, **publica las últimas 120 líneas del log como comentario del
commit** — único canal de diagnóstico legible desde el entorno del agente, porque los logs y
artefactos de Actions viven en un blob externo inaccesible.

> Publicar el workflow requirió que el propietario concediera permiso `workflows` a la
> GitHub App: el primer push fue rechazado con
> `refusing to allow a GitHub App to create or update workflow ... without 'workflows' permission`.
