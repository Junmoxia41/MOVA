package com.mova.app.domain

import com.mova.app.data.local.room.entity.DriverEntity
import com.mova.app.domain.mapper.toDomain
import com.mova.app.domain.mapper.toEntity
import com.mova.app.domain.model.SyncStatus
import com.mova.app.domain.model.VerificationStatus
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/** Pruebas unitarias del mapeo y de las reglas de dominio (Mega Prompt §84). */
class DriverMapperTest {

    private fun entity(
        verification: String = "VERIFIED",
        active: Boolean = true,
        sync: String = "SYNCED",
    ) = DriverEntity(
        id = "d-1",
        profileId = "p-1",
        displayName = "Yusbel",
        photoUrl = null,
        phone = "+5350000000",
        description = "Triciclo en Centro",
        verificationStatus = verification,
        active = active,
        planId = null,
        rating = 4.8,
        reviewCount = 12,
        version = 3,
        createdAt = 1_000L,
        updatedAt = 2_000L,
        syncStatus = sync,
    )

    @Test
    fun `el mapeo de ida y vuelta conserva todos los campos`() {
        val original = entity()

        val restored = original.toDomain().toEntity()

        assertEquals(original, restored)
    }

    @Test
    fun `un estado de verificación desconocido degrada a PENDING sin lanzar excepción`() {
        val driver = entity(verification = "INVENTADO").toDomain()

        assertEquals(VerificationStatus.PENDING, driver.verificationStatus)
    }

    @Test
    fun `un estado de sincronización desconocido degrada a PENDING_SYNC`() {
        val driver = entity(sync = "???").toDomain()

        assertEquals(SyncStatus.PENDING_SYNC, driver.syncStatus)
    }

    @Test
    fun `solo un conductor verificado y activo es visible públicamente`() {
        assertTrue(entity(verification = "VERIFIED", active = true).toDomain().isPubliclyVisible)
        assertFalse(entity(verification = "PENDING", active = true).toDomain().isPubliclyVisible)
        assertFalse(entity(verification = "SUSPENDED", active = true).toDomain().isPubliclyVisible)
        assertFalse(entity(verification = "VERIFIED", active = false).toDomain().isPubliclyVisible)
    }
}
