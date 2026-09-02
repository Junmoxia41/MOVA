package com.mova.santaclara.core.network

/**
 * Configuración de red. En esta fase solo queda preparada la ubicación;
 * las credenciales reales de Supabase (Project URL / anon key) se inyectarán
 * mediante build config y NUNCA se hardcodean aquí (Mega Prompt §22).
 */
object ApiConfig {
    const val SUPABASE_URL = ""      // PENDIENTE DE DECISIÓN: aportar por el propietario.
    const val SUPABASE_ANON_KEY = ""
}
