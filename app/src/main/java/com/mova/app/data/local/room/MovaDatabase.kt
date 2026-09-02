package com.mova.app.data.local.room

import android.content.Context
import androidx.room3.Database
import androidx.room3.Room
import androidx.room3.RoomDatabase
import androidx.sqlite.driver.bundled.BundledSQLiteDriver
import com.mova.app.data.local.room.dao.DriverDao
import com.mova.app.data.local.room.entity.DriverEntity
import kotlinx.coroutines.Dispatchers

/**
 * Base de datos local de MOVA (Mega Prompt §48).
 *
 * Room 3 exige un [androidx.sqlite.SQLiteDriver]: se usa el bundled para tener la misma
 * versión de SQLite en todos los dispositivos (Android económicos incluidos, §88).
 */
@Database(
    entities = [DriverEntity::class],
    version = 1,
    exportSchema = true,
)
abstract class MovaDatabase : RoomDatabase() {

    abstract fun driverDao(): DriverDao

    companion object {
        const val NAME: String = "mova.db"

        fun build(context: Context): MovaDatabase =
            Room.databaseBuilder<MovaDatabase>(context, NAME)
                .setDriver(BundledSQLiteDriver())
                .setQueryCoroutineContext(Dispatchers.IO)
                .build()
    }
}
