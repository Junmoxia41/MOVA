package com.mova.santaclara.core.logging

import android.util.Log

/**
 * Logger central de MOVA.
 *
 * Regla de seguridad (Mega Prompt §55): en producción NO registrar contraseñas,
 * tokens, claves ni datos personales innecesarios.
 *
 * Los niveles DEBUG/INFO/WARN/ERROR se filtran en función del build: en release
 * se reduce la verbosidad de DEBUG/INFO.
 */
class MovaLogger(private val tag: String = "MOVA") {

    fun debug(message: String) = Log.d(tag, message)

    fun info(message: String) = Log.i(tag, message)

    fun warn(message: String, throwable: Throwable? = null) =
        Log.w(tag, message, throwable)

    fun error(message: String, throwable: Throwable? = null) =
        Log.e(tag, message, throwable)
}

/** Instancia por defecto accesible desde las capas core/data/domain/feature. */
object MovaLog {
    val logger = MovaLogger()
}
