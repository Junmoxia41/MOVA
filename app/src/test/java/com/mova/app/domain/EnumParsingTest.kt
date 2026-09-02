package com.mova.app.domain

import com.mova.app.domain.model.Availability
import com.mova.app.domain.model.SyncStatus
import com.mova.app.domain.model.VerificationStatus
import org.junit.Assert.assertEquals
import org.junit.Test

/** Los valores nulos y vacíos del servidor no deben romper el parsing (§54). */
class EnumParsingTest {

    @Test
    fun `verification acepta el valor exacto e ignora mayúsculas`() {
        assertEquals(VerificationStatus.VERIFIED, VerificationStatus.from("VERIFIED"))
        assertEquals(VerificationStatus.REJECTED, VerificationStatus.from("rejected"))
    }

    @Test
    fun `verification trata null y vacío como PENDING`() {
        assertEquals(VerificationStatus.PENDING, VerificationStatus.from(null))
        assertEquals(VerificationStatus.PENDING, VerificationStatus.from(""))
    }

    @Test
    fun `availability trata lo desconocido como UNAVAILABLE, el valor más restrictivo`() {
        assertEquals(Availability.AVAILABLE, Availability.from("AVAILABLE"))
        assertEquals(Availability.UNAVAILABLE, Availability.from(null))
        assertEquals(Availability.UNAVAILABLE, Availability.from("volando"))
    }

    @Test
    fun `syncStatus cubre los tres estados de la UI offline`() {
        assertEquals(SyncStatus.SYNCED, SyncStatus.from("SYNCED"))
        assertEquals(SyncStatus.FAILED, SyncStatus.from("FAILED"))
        assertEquals(SyncStatus.PENDING_SYNC, SyncStatus.from(null))
    }
}
