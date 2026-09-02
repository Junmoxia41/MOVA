# ROADMAP

Fases definidas por el Mega Prompt §113. Regla: **no construir todo a la vez**; empezar por la
fase que corresponda al estado real del proyecto.

| Fase | Contenido | Estado |
| --- | --- | --- |
| **0 — AUDITORÍA** | Repo, entorno, Git, Supabase, archivos existentes | ✅ Completa (`docs/MOVA_SPECIFICATION.md`) |
| **1 — BOOTSTRAP** | Proyecto Android, Kotlin, Compose, navegación, arquitectura base, Git, README | 🟡 En curso: proyecto, README y docs listos; faltan navegación y capas en código |
| **2 — DATA** | Room, entidades, DAOs, repositories, Supabase, migraciones, RLS | 🟡 Migraciones y RLS escritas; falta Room y aplicar el esquema |
| **3 — AUTH** | Login, registro, sesión, perfiles, roles | ⬜ Pendiente (requiere credenciales) |
| **4 — CONDUCTORES** | Perfil, vehículo, disponibilidad, verificación | ⬜ Pendiente |
| **5 — PASAJERO** | Inicio, búsqueda, filtros, perfiles, favoritos | ⬜ Pendiente |
| **6 — RESERVAS** | Creación, aceptación, rechazo, cancelación, completado, historial | ⬜ Pendiente |
| **7 — AGENDA** | Calendario, disponibilidad, bloqueos, reservas | ⬜ Pendiente |
| **8 — OFFLINE** | Room como fuente local, Sync Queue, WorkManager, reintentos, conflictos | ⬜ Pendiente |
| **9 — REVIEWS** | Valoración, comentarios, puntuaciones | ⬜ Pendiente |
| **10 — PLANES** | FREE / PRO / PREMIUM + configuración remota | ⬜ Pendiente (precios: decisión del propietario) |
| **11 — ADMIN** | Dashboard, conductores, usuarios, reservas, planes, reseñas, configuración | ⬜ Pendiente (soporte: decisión pendiente) |
| **12 — QA** | Pruebas completas | ⬜ Pendiente |
| **13 — GITHUB** | Actions, builds, tests, releases | 🟡 Workflow escrito, sin publicar (permiso `workflows`) |
| **14 — RELEASE** | APK / AAB | ⬜ Pendiente (release firmada requiere keystore del propietario) |

## Criterio de salida del MVP (§114)

Se cumple cuando **todo** lo siguiente esté verificado: Android Studio abre el proyecto ·
Gradle sincroniza · APK compila · app inicia · Compose funciona · registro y login funcionan ·
roles funcionan · el conductor crea perfil, vehículo y agenda · el pasajero busca, ve y reserva ·
el conductor acepta · la reserva se completa · la reseña funciona · Room, Supabase, RLS,
offline, sync y WorkManager funcionan · la recuperación tras reinicio funciona · GitHub y CI
funcionan · la documentación existe.

## Hito comercial (§116)

**Primer conductor real** en Santa Clara → 5 conductores → 20 → 50+.
