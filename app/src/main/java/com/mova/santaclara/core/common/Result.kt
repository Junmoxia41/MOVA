package com.mova.santaclara.core.common

/**
 * Resultado genérico de las operaciones de repositorio/casos de uso.
 * Evita exponer excepciones técnicas a la UI (Mega Prompt §54).
 */
sealed class MovaResult<out T> {
    data class Success<T>(val data: T) : MovaResult<T>()
    data class Error(val code: ErrorCode, val message: String? = null) : MovaResult<Nothing>()
}

enum class ErrorCode {
    NETWORK,
    TIMEOUT,
    AUTH,
    NOT_FOUND,
    VALIDATION,
    CONFLICT,
    UNKNOWN,
}
