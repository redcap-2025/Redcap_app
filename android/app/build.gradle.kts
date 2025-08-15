import com.android.build.api.variant.AndroidComponentsExtension
import org.gradle.api.plugins.JavaPluginExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.redcap"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.redcap"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildTypes {
        // Release build type
        maybeCreate("release").apply {
            // ✅ Correct: Use `isMinifyEnabled` and `isShrinkResources`
            isMinifyEnabled = true
            isShrinkResources = true

            // Link to signing config
            signingConfig = signingConfigs.findByName("release")

            // ProGuard rules
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        // Debug build type
        maybeCreate("debug").apply {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.findByName("debug")
        }
    }

    // Optional: Enable viewBinding
    buildFeatures {
        viewBinding = false
    }
}

flutter {
    source = "../.."
}

// Kotlin compilation
tasks.withType<KotlinCompile> {
    kotlinOptions {
        jvmTarget = "1.8"
    }
}