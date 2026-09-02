# TESTING

## Regla de verificación (§111)

Nunca se afirma *"compila"*, *"Supabase funciona"*, *"GitHub configurado"* u *"offline
funciona"* sin haberlo ejecutado. **La evidencia válida es CÓDIGO + PRUEBA + VERIFICACIÓN**;
una respuesta generada por IA no es evidencia (Límites §16).

## Matriz de pruebas

| Tipo | Cobertura | Fuente |
| --- | --- | --- |
| **Unitarias** | casos de uso, validaciones, estados, sincronización, ranking, reservas | §84 |
| **Room** | inserción, actualización, eliminación, consultas, persistencia | §85 |
| **Sincronización** | online, offline, reserva offline, cerrar app, abrir app, volver online, WorkManager, Supabase responde, Supabase no responde, reintento, conflicto | §86 |
| **Apagón** | operación offline → apagado → encendido → Room intacto → sync | §87 |
| **Instrumentadas** | flujo completo de reserva en dispositivo/emulador | §112 |

## Cadena de producción (§112)

```
ANDROID STUDIO → SYNC → BUILD → TEST → INSTALL → RUN
→ OFFLINE TEST → ONLINE TEST → SUPABASE TEST → RELEASE BUILD
```

## Ejecución

```bash
./gradlew testDebugUnitTest
./gradlew lintDebug
./gradlew assembleDebug
./gradlew connectedDebugAndroidTest   # requiere dispositivo o emulador
```

## Estado actual

Solo existen los tests de ejemplo de la plantilla (`ExampleUnitTest`,
`ExampleInstrumentedTest`). **Ninguna prueba se ha ejecutado todavía**: el entorno del agente
no puede compilar. Ver `PROJECT_STATUS.md` → BLOQUEO 1 y 2.

## Anti-mock (§110)

Sin datos simulados en producción. Mocks solo para tests, desarrollo y demos controladas,
separados por entorno.
