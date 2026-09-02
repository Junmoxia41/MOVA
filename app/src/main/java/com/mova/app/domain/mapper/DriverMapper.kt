package com.mova.app.domain.mapper

import com.mova.app.data.local.room.entity.DriverEntity
import com.mova.app.domain.model.Driver
import com.mova.app.domain.model.SyncStatus
import com.mova.app.domain.model.VerificationStatus

/**
 * Traducción entre la fila de Room y el modelo de dominio.
 *
 * Los enums desconocidos nunca lanzan excepción: se degradan a un valor seguro
 * (Mega Prompt §54 — el usuario no debe ver un fallo técnico por un dato raro).
 */
fun DriverEntity.toDomain(): Driver =
    Driver(
        id = id,
        profileId = profileId,
        displayName = displayName,
        photoUrl = photoUrl,
        phone = phone,
        description = description,
        verificationStatus = VerificationStatus.from(verificationStatus),
        active = active,
        planId = planId,
        rating = rating,
        reviewCount = reviewCount,
        version = version,
        createdAt = createdAt,
        updatedAt = updatedAt,
        syncStatus = SyncStatus.from(syncStatus),
    )

fun Driver.toEntity(): DriverEntity =
    DriverEntity(
        id = id,
        profileId = profileId,
        displayName = displayName,
        photoUrl = photoUrl,
        phone = phone,
        description = description,
        verificationStatus = verificationStatus.name,
        active = active,
        planId = planId,
        rating = rating,
        reviewCount = reviewCount,
        version = version,
        createdAt = createdAt,
        updatedAt = updatedAt,
        syncStatus = syncStatus.name,
    )
