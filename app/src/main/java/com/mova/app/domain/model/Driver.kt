package com.mova.app.domain.model

/**
 * Conductor (Mega Prompt §27). Modelo de dominio: no conoce Room ni Supabase.
 *
 * [rating] y [reviewCount] son derivados del servidor; en local son la última copia conocida.
 */
data class Driver(
    val id: String,
    val profileId: String,
    val displayName: String,
    val photoUrl: String?,
    val phone: String?,
    val description: String?,
    val verificationStatus: VerificationStatus,
    val active: Boolean,
    val planId: String?,
    val rating: Double,
    val reviewCount: Int,
    val version: Int,
    val createdAt: Long,
    val updatedAt: Long,
    val syncStatus: SyncStatus,
) {
    /** Solo un conductor verificado y activo es visible públicamente (§24, §97). */
    val isPubliclyVisible: Boolean
        get() = verificationStatus == VerificationStatus.VERIFIED && active
}
