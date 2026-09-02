import java.util.Properties

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.compose)
    alias(libs.plugins.ksp)
}

/**
 * PUBLIC CONFIG (Mega Prompt §22).
 *
 * Orden de resolución: variables de entorno (CI) > secrets.properties > local.properties > vacío.
 * Ninguno de esos ficheros está versionado. La SECRET CONFIG (service_role key, secretos
 * privados) nunca pasa por aquí ni viaja en la app.
 *
 * Si falta la credencial se compila igual con cadena vacía: la app debe detectar
 * "no configurado" en lugar de romperse (Límites §3).
 */
fun publicConfig(key: String): String {
    System.getenv(key)?.takeIf { it.isNotBlank() }?.let { return it }
    for (name in listOf("secrets.properties", "local.properties")) {
        val file = rootProject.file(name)
        if (!file.exists()) continue
        val value = Properties().apply { file.inputStream().use(::load) }.getProperty(key)
        if (!value.isNullOrBlank()) return value.trim()
    }
    return ""
}

android {
    namespace = "com.mova.app"
    compileSdk {
        version = release(37)
    }

    defaultConfig {
        applicationId = "com.mova.app"
        minSdk = 24
        targetSdk = 37
        versionCode = 1
        // Mega Prompt §61 — MAJOR.MINOR.PATCH, coherente con versionCode
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        buildConfigField("String", "SUPABASE_URL", "\"${publicConfig("SUPABASE_URL")}\"")
        buildConfigField("String", "SUPABASE_ANON_KEY", "\"${publicConfig("SUPABASE_ANON_KEY")}\"")
    }

    buildTypes {
        release {
            optimization {
                enable = false
            }
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    buildFeatures {
        compose = true
        buildConfig = true
    }
}

// Room exporta el esquema para poder probar migraciones (Mega Prompt §85)
ksp {
    arg("room.schemaLocation", "$projectDir/schemas")
}

dependencies {
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.activity.compose)
    implementation(libs.androidx.compose.material3)
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.ui.graphics)
    implementation(libs.androidx.compose.ui.tooling.preview)
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.lifecycle.runtime.ktx)

    // Room 3: fuente de verdad local (§11, §12). Requiere KSP y un SQLiteDriver.
    implementation(libs.androidx.room3.runtime)
    implementation(libs.androidx.sqlite.bundled)
    ksp(libs.androidx.room3.compiler)

    testImplementation(libs.junit)
    androidTestImplementation(platform(libs.androidx.compose.bom))
    androidTestImplementation(libs.androidx.compose.ui.test.junit4)
    androidTestImplementation(libs.androidx.espresso.core)
    androidTestImplementation(libs.androidx.junit)
    debugImplementation(libs.androidx.compose.ui.test.manifest)
    debugImplementation(libs.androidx.compose.ui.tooling)
}
