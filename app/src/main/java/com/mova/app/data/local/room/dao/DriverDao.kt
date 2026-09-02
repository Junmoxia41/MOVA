package com.mova.app.data.local.room.dao

import androidx.room3.Dao
import androidx.room3.Insert
import androidx.room3.OnConflictStrategy
import androidx.room3.Query
import com.mova.app.data.local.room.entity.DriverEntity
import kotlinx.coroutines.flow.Flow

/**
 * Acceso local a conductores. Room es la fuente de verdad de la UI (Mega Prompt §12):
 * la pantalla observa [observeVisible], no consulta Supabase.
 */
@Dao
interface DriverDao {

    /** Conductores visibles públicamente (§24): verificados y activos. */
    @Query(
        "SELECT * FROM drivers " +
            "WHERE verification_status = 'VERIFIED' AND active = 1 " +
            "ORDER BY rating DESC, review_count DESC, display_name COLLATE NOCASE ASC",
    )
    fun observeVisible(): Flow<List<DriverEntity>>

    /** Búsqueda por nombre, filtrable por zona/plán (§34). Consultas eficientes, no volcados. */
    @Query(
        "SELECT * FROM drivers " +
            "WHERE verification_status = 'VERIFIED' AND active = 1 " +
            "AND display_name LIKE '%' || :term || '%' " +
            "ORDER BY rating DESC",
    )
    fun search(term: String): Flow<List<DriverEntity>>

    @Query("SELECT * FROM drivers WHERE id = :id")
    fun observeById(id: String): Flow<DriverEntity?>

    @Query("SELECT * FROM drivers WHERE id = :id")
    suspend fun findById(id: String): DriverEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsertAll(drivers: List<DriverEntity>)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(driver: DriverEntity)

    /** Marca el resultado de la sincronización sin perder la información (§33). */
    @Query("UPDATE drivers SET sync_status = :status WHERE id = :id")
    suspend fun markSyncStatus(id: String, status: String)

    @Query("SELECT COUNT(*) FROM drivers")
    suspend fun count(): Int
}
