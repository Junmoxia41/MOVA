package com.mova.app.data.local.room.entity

import androidx.room3.ColumnInfo
import androidx.room3.Entity
import androidx.room3.PrimaryKey

/**
 * Fila de `drivers` en Room. Espejo local de la tabla de Supabase (Mega Prompt §27).
 *
 * Los enums se guardan como texto para que el esquema sea legible y migrable.
 * [syncStatus] es local: no existe en el servidor.
 */
@Entity(tableName = "drivers")
data class DriverEntity(
    @PrimaryKey
    @ColumnInfo(name = "id")
    val id: String,
    @ColumnInfo(name = "profile_id")
    val profileId: String,
    @ColumnInfo(name = "display_name")
    val displayName: String,
    @ColumnInfo(name = "photo_url")
    val photoUrl: String?,
    @ColumnInfo(name = "phone")
    val phone: String?,
    @ColumnInfo(name = "description")
    val description: String?,
    @ColumnInfo(name = "verification_status")
    val verificationStatus: String,
    @ColumnInfo(name = "active")
    val active: Boolean,
    @ColumnInfo(name = "plan_id")
    val planId: String?,
    @ColumnInfo(name = "rating")
    val rating: Double,
    @ColumnInfo(name = "review_count")
    val reviewCount: Int,
    @ColumnInfo(name = "version")
    val version: Int,
    @ColumnInfo(name = "created_at")
    val createdAt: Long,
    @ColumnInfo(name = "updated_at")
    val updatedAt: Long,
    @ColumnInfo(name = "sync_status")
    val syncStatus: String,
)
