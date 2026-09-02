# SEGURIDAD

## Clasificación de datos (§97)

`PUBLIC` · `AUTHENTICATED` · `PRIVATE` · `ADMIN` — con políticas y almacenamiento acordes.

## Row Level Security

Toda tabla sensible lleva RLS (§24). La autorización real vive en el backend, nunca solo en la
UI. Ver `SUPABASE.md`.

## Credenciales

| Regla | Detalle |
| --- | --- |
| En el repo | Nada de `.env`, secretos, claves de firma ni datos de producción (§90) |
| En la app | Solo la credencial pública de cliente |
| `service_role` | **Nunca** en GitHub ni en el cliente (§22) |
| Keystore | Fuera del código; alias y passwords gestionados externamente (§91) |
| CI | Secretos por **GitHub Secrets** (§64) |

El agente **no inventa ni filtra** una clave de firma. Si falta, lo reporta y continúa con lo
demás (Límites §3).

## Almacenamiento local (§56)

Android Keystore, cifrado y almacenamiento seguro cuando corresponda; tokens protegidos.
**Sin criptografía casera.**

## Logging (§55)

Niveles `DEBUG` · `INFO` · `WARN` · `ERROR`. En producción **nunca** se registran contraseñas,
tokens, claves ni datos personales innecesarios.

## Errores de cara al usuario (§54)

Nunca se muestran `NullPointerException`, `HTTP 500` o `SocketException`. Mensajes humanos:

> "No pudimos conectar ahora. Tus datos siguen guardados en el dispositivo."

El detalle técnico va a logs.

## Privacidad (§82)

Solo la información necesaria. Sin ubicación permanente de los usuarios. Sin recopilar datos
sin motivo. Sin historial de llamadas (§42).

## Permisos (§98)

Mínimos y justificados. Nada de permisos "por si acaso".

## Respuesta ante incidentes (Límites §10)

Ante vulnerabilidad crítica, credencial expuesta, RLS insegura, fuga de datos o dependencia
comprometida: **mitigar primero**. Los arreglos técnicos reversibles se aplican; revocar
credenciales o afectar producción requiere explicar el riesgo y pedir autorización.
