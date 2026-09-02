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

Ejecutado en GitHub Actions run
[`33656287736`](https://github.com/Junmoxia41/MOVA/actions/runs/33656287736) (commit `193bb37`):

| Tarea | Resultado |
| --- | --- |
| `testDebugUnitTest` | ✅ **8 tests ejecutados, 0 fallidos, 0 errores, 0 omitidos** |
| `lintDebug` | ✅ success |
| `assembleDebug` | ✅ success — `mova-debug-apk`, 13 936 422 bytes |

El recuento no se infiere del paso en verde: un paso dedicado parsea los XML de
`app/build/test-results/testDebugUnitTest/` y lo publica como anotación. **Si no hay XML,
falla**: un paso que pasa sin ejecutar tests no es evidencia.

Suites actuales: `DriverMapperTest` (mapeo ida y vuelta, degradación de enums desconocidos,
regla de visibilidad pública) y `EnumParsingTest` (nulos, vacíos y valores inválidos).
Se eliminó `ExampleUnitTest` de la plantilla: `assertEquals(4, 2 + 2)` no prueba nada.

Pendiente: pruebas de Room (§85) y de sincronización (§86, §87), que requieren test
instrumentado o Robolectric.

> El entorno del agente no puede compilar en local (sin JDK, Android SDK ni red para
> descargarlos), así que **toda afirmación de compilación procede de un run de Actions**,
> nunca de una suposición.

## Anti-mock (§110)

Sin datos simulados en producción. Mocks solo para tests, desarrollo y demos controladas,
separados por entorno.
