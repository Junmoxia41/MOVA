# ADMINISTRACIÓN

## Rol ADMIN (§25)

- Aprobar y suspender conductores.
- Gestionar usuarios, planes, reseñas, zonas y configuración.
- Revisar reservas y métricas.

La autorización real está protegida por **backend/RLS**, no por la interfaz (§24).

## Verificación de conductores (§38)

Estados `PENDING → VERIFIED → REJECTED → SUSPENDED`. **Solo ADMIN** verifica.
El distintivo público es 🛡️ VERIFICADO.

## Auditoría (§83)

Toda acción administrativa importante queda en `audit_logs`: **quién, qué, cuándo, resultado**.

## Métricas (§81)

Usuarios, conductores, reservas, conversiones, reseñas y planes. Métricas básicas: sin sistema
analítico pesado.

## Soporte

`PENDIENTE DE DECISIÓN` (§71 / D5 de la especificación): la administración puede ser una
sección dentro de la app Android **o** un panel web separado. La decisión depende del análisis
de implementación y corresponde al propietario. Hasta entonces se desarrolla la sección
`feature/admin` en Android, que es la opción reversible.

## Configuración remota (§58)

Desde `app_config`: mensajes, planes, promociones, flags, versión recomendada y mantenimiento.
Nunca se usa para decisiones de seguridad.
