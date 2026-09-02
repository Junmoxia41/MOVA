package com.mova.app.domain.model

/**
 * Disponibilidad declarada por el conductor (Mega Prompt §29).
 * No es GPS: es un estado que el conductor afirma.
 */
enum class Availability {
    AVAILABLE,
    BUSY,
    OFF_DUTY,
    UNAVAILABLE,
    ;

    companion object {
        fun from(raw: String?): Availability =
            entries.firstOrNull { it.name.equals(raw, ignoreCase = true) } ?: UNAVAILABLE
    }
}
