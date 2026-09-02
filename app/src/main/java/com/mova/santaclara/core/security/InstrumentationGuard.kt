package com.mova.santaclara.core.security

import android.os.Build

/**
 * Guardas simples de seguridad local.
 * En esta fase solo se instrumenta lo básico; el cifrado/token storage se añadirá
 * en fases posteriores (Android Keystore, EncryptedSharedPreferences, etc.).
 */
object InstrumentationGuard {

    val isEmulator: Boolean
        get() = Build.FINGERPRINT.contains("generic") ||
            Build.MODEL.contains("Emulator") ||
            Build.MODEL.contains("Android SDK built for") ||
            Build.MANUFACTURER.contains("Genymotion")
}
