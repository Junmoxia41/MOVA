# 🚕 MOVA

**Tu ciudad. Tu ruta. Tu movimiento.**

Plataforma local de movilidad (Santa Clara, Villa Clara, Cuba) que conecta **pasajeros** con **conductores independientes**. Es una **aplicación Android nativa** — no es un clon de Uber/Didi/Cabify, ni una web empaquetada.

> Documento de referencia maestro: [`docs/MOVA_SPECIFICATION.md`](docs/MOVA_SPECIFICATION.md)

---

## Stack

- **Android nativo** — Kotlin + Jetpack Compose (Material 3)
- **Arquitectura:** MVVM + Clean Architecture ligera (UI / Domain / Data / Core)
- **Persistencia local:** Room + DataStore
- **Trabajos persistentes:** WorkManager
- **Backend:** Supabase (PostgreSQL, Auth, Storage, PostgREST)
- **Offline First** (Local First → Cloud Sync) mediante Sync Engine
- **Control de versiones:** Git + GitHub · **CI/CD:** GitHub Actions

## Estado del proyecto

Ver [`PROJECT_STATUS.md`](PROJECT_STATUS.md) y [`CHANGELOG.md`](CHANGELOG.md).

## Estructura

```
app/src/main/java/com/mova/santaclara/
├── core/        (common, network, connectivity, logging, security)
├── data/        (local/room, remote/supabase, repository, sync)
├── domain/      (model, usecase)
├── feature/     (auth, home, search, driver, passenger, booking, ...)
├── navigation/
├── ui/theme/
└── MainActivity.kt

supabase/        (migrations, seed, functions)
docs/
.github/workflows/
```

## Fases de desarrollo

0. Auditoría ✅ · 1. Bootstrap ✅ · 2. Data · 3. Auth · 4. Conductores · 5. Pasajero · 6. Reservas · 7. Agenda · 8. Offline · 9. Reviews · 10. Planes · 11. Admin · 12. QA · 13. GitHub · 14. Release
