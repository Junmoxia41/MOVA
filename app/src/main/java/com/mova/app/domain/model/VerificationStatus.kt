package com.mova.app.domain.model

/** Estados de verificación de un conductor (Mega Prompt §38). Solo ADMIN los cambia. */
enum class VerificationStatus {
    PENDING,
    VERIFIED,
    REJECTED,
    SUSPENDED,
    ;

    companion object {
        /** Un valor desconocido del servidor no debe tumbar la app: se trata como PENDING. */
        fun from(raw: String?): VerificationStatus =
            entries.firstOrNull { it.name.equals(raw, ignoreCase = true) } ?: PENDING
    }
}
