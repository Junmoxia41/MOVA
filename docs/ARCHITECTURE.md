# MOVA — Arquitectura

## Visión general

MOVA es una app **Android nativa** con arquitectura **Clean Architecture ligera** + **MVVM**,
y un modelo **Offline First** (Local First → Cloud Sync).

```text
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

## Capas

- **UI** — screens, components, navigation, state rendering (Jetpack Compose).
- **Domain** — modelos de dominio, casos de uso, reglas de negocio.
- **Data** — repositories, Room, DAOs, Supabase, DTOs, mappers, sincronización.
- **Core** — configuración, logging, conectividad, errores, utilidades, seguridad.

## Flujo de estado (unidireccional)

```text
UI → Evento → ViewModel → Use Case → Repository → Local/Remote → State → UI
```

## Reglas vigentes

- **Room es la fuente de verdad de la UI** para entidades con comportamiento offline.
- La UI no consulta Supabase directamente.
- Ningún archivo de código debería superar ~200 líneas (dividir si crece).
- No introducir dependencias innecesarias (preferir soluciones Android/Jetpack nativas).

## Estructura de carpetas propuesta

```text
app/src/main/java/com/mova/santaclara/
├── core/
│   ├── common/    network/  connectivity/  logging/  security/
├── data/
│   ├── local/room/  dao/  remote/supabase/  repository/  sync/
├── domain/
│   ├── model/  usecase/
├── feature/
│   ├── auth/  home/  search/  driver/  passenger/  booking/  schedule/
│   ├── favorites/  reviews/  profile/  admin/
├── navigation/
└── MainActivity.kt
```

> En esta fase están creadas las capas `core`, `navigation`, `feature/splash`, `feature/home` y `ui/theme`.
> `data` y `domain` se implementan en la Fase 2.
