package com.mova.santaclara.core.connectivity

/**
 * Estados de conectividad que MOVA distingue (Mega Prompt §52).
 * No bloquean la aplicación: solo informan del estado de red.
 */
enum class ConnectivityState {
    ONLINE,
    OFFLINE,
    SYNCING,
    SYNC_ERROR,
}
