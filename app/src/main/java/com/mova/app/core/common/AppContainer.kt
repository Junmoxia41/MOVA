package com.mova.app.core.common

import android.content.Context
import com.mova.app.data.local.room.MovaDatabase

/**
 * Contenedor de dependencias manual (docs/DECISIONS.md → D-003).
 *
 * Sin Hilt ni Dagger: el grafo es pequeño y §2/§67 piden el mínimo de tecnologías.
 * [database] es lazy para no abrir SQLite antes de que haga falta (§88).
 */
class AppContainer(context: Context) {

    val database: MovaDatabase by lazy { MovaDatabase.build(context) }

    val driverDao by lazy { database.driverDao() }
}
