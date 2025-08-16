import org.gradle.api.tasks.Delete
import org.gradle.api.tasks.compile.JavaCompile
import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Suppress Java compilation lint warnings
    tasks.withType<JavaCompile>().configureEach {
        options.compilerArgs.add("-Xlint:-options")
    }
}

// Define a custom global build directory
val newBuildDir: Directory = layout.buildDirectory.dir("../../build").get()
layout.buildDirectory.set(newBuildDir)

// Set subproject build directories
subprojects {
    layout.buildDirectory.set(newBuildDir.dir(name))
    evaluationDependsOn(":app") // Ensure app is evaluated first
}

// Register clean task
tasks.register<Delete>("clean") {
    delete(layout.buildDirectory)
}
