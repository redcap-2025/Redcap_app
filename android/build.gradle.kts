import org.gradle.api.file.Directory
import org.gradle.api.tasks.Delete

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Suppress Java compilation lint warnings (e.g., bootstrap classpath)
    tasks.withType<JavaCompile>().configureEach {
        options.compilerArgs.add("-Xlint:-options")
    }
}

// Define a custom global build directory
val newBuildDir: Directory = layout.buildDirectory.dir("../../build").get()
layout.buildDirectory.set(newBuildDir)

// Set subproject build directories
subprojects {
    val subprojectBuildDir: Directory = newBuildDir.dir(name)
    layout.buildDirectory.set(subprojectBuildDir)
}

// Optional: Ensure app module is evaluated first if needed
subprojects {
    evaluationDependsOn(":app")
}

// Register clean task
tasks.register<Delete>("clean") {
    delete(layout.buildDirectory)
}