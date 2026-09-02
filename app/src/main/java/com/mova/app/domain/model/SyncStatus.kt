package com.mova.app.domain.model

/**
 * Estado de sincronización de una entidad local (Mega Prompt §15, §33).
 *
 * UI: PENDING_SYNC → 🟠 · SYNCED → 🟢 · FAILED → 🔴 (conservando siempre la información).
 */
enum class SyncStatus {
    PENDING_SYNC,
    SYNCED,
    FAILED,
    ;

    companion object {
        fun from(raw: String?): SyncStatus =
            entries.firstOrNull { it.name.equals(raw, ignoreCase = true) } ?: PENDING_SYNC
    }
}
