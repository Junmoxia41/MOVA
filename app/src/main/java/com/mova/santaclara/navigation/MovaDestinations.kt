package com.mova.santaclara.navigation

/**
 * Rutas conceptuales de MOVA (Mega Prompt §51). Se ampliarán en fases posteriores.
 */
object MovaDestinations {
    const val SPLASH = "splash"
    const val HOME = "home"
    const val SEARCH = "search"
    const val BOOKINGS = "bookings"
    const val FAVORITES = "favorites"
    const val PROFILE = "profile"
    const val SETTINGS = "settings"

    fun driver(id: String) = "driver/$id"
}
