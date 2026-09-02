# ARQUITECTURA

## Modelo

**MVVM + Clean Architecture ligera**, con flujo de estado unidireccional:

```
UI → Evento → ViewModel → Use Case → Repository → Local/Remote → State → UI
```

```
                    MOVA
                     │
          ┌──────────┴──────────┐
        UI                   DOMAIN
   Jetpack Compose        Use Cases
          └──────────┬──────────┘
                    DATA
          ┌──────────┴──────────┐
       LOCAL                 REMOTE
       Room                 Supabase
          └──────────┬──────────┘
                Sync Engine → WorkManager
```

## Capas

| Capa | Paquete | Responsabilidad | No hacer |
| --- | --- | --- | --- |
| UI | `feature/*`, `navigation` | Pantallas, componentes, render de estado | Lógica de negocio en composables |
| DOMAIN | `domain/model`, `domain/usecase` | Modelos y reglas de negocio | Depender de Room o Supabase |
| DATA | `data/*` | Repositories, Room, DAOs, Supabase, DTOs, mappers, sync | Exponer entidades Room a la UI |
| CORE | `core/*` | Config, logging, conectividad, errores, seguridad | Contener lógica de negocio |

**Regla de dependencia:** `UI → DOMAIN ← DATA`. DOMAIN no conoce el origen de los datos.

## Flujo de datos offline-first

```
Supabase → Sync → Room → ViewModel → Compose
```

**Room es la fuente de verdad de la UI.** Ninguna pantalla consulta Supabase directamente.
Ver `OFFLINE.md` y `SYNC.md`.

## Inyección de dependencias

**Contenedor manual** (`core/common/AppContainer`), creado en `MovaApplication`.
Se descarta Hilt/Dagger de momento: añaden dependencias y complejidad de build sin aportar
valor en el tamaño actual del proyecto (Mega Prompt §2 y §67: mínimo de tecnologías, preferir
lo nativo). Reevaluar si el grafo de dependencias crece.

## Reglas de código

- Ningún archivo debería superar **~200 líneas**; si crece, dividir.
- No crear clases artificiales para llenar carpetas: un caso de uso existe solo si hay lógica
  de negocio real.
- ViewModels por feature, nunca gigantes.
- `Flow` donde aporte valor; estados inmutables (`data class` + `copy`).
