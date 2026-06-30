plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_application_2"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    val releaseKeyPath = System.getenv("KEY_PATH")
    val releaseKeyAlias = System.getenv("KEY_ALIAS")
    val releaseStorePassword = System.getenv("KEY_STORE_PASSWORD")
    val releaseKeyPassword = System.getenv("KEY_PASSWORD")
    val hasReleaseSigning = listOf(
        releaseKeyPath,
        releaseKeyAlias,
        releaseStorePassword,
        releaseKeyPassword,
    ).all { !it.isNullOrBlank() }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // ─── Flutter Flavors ────────────────────────────────────────────────────
    flavorDimensions += "environment"

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Todo Dev")
            manifestPlaceholders["appIcon"] = "@mipmap/ic_launcher"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "Todo Staging")
            manifestPlaceholders["appIcon"] = "@mipmap/ic_launcher"
        }
        create("prod") {
            dimension = "environment"
            // Production: no suffix → clean bundle ID
            resValue("string", "app_name", "Todo App")
            manifestPlaceholders["appIcon"] = "@mipmap/ic_launcher"
        }
    }
    // ────────────────────────────────────────────────────────────────────────

    defaultConfig {
        applicationId = "com.example.flutter_application_2"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseSigning) {
                storeFile = file(releaseKeyPath!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
