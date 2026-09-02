package com.mova.app

import android.app.Application
import com.mova.app.core.common.AppContainer

/**
 * Punto de entrada de la aplicación: crea el contenedor una sola vez.
 *
 * Offline First (§10): no se hace red en el arranque. La app abre y muestra lo local
 * aunque no haya conexión ni credenciales configuradas.
 */
class MovaApplication : Application() {

    lateinit var container: AppContainer
        private set

    override fun onCreate() {
        super.onCreate()
        container = AppContainer(this)
    }
}
