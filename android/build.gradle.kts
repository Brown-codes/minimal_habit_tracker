import com.android.build.gradle.BaseExtension
import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
    // "NUCLEAR" FIX: Force older versions of libraries that don't need lStar
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core-ktx:1.6.0")
            force("androidx.core:core:1.6.0")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    // Watch for the Android Library plugin
    pluginManager.withPlugin("com.android.library") {
        // Use BaseExtension (The "Parent" class that works for both old and new plugins)
        val android = extensions.findByType(com.android.build.gradle.BaseExtension::class.java)

        if (android != null) {
            // Use the raw method call instead of the property assignment
            // This is the most reliable way to force the version
            android.compileSdkVersion(36)

            // Fix the namespace
            if (android.namespace == null) {
                android.namespace = project.group.toString()
            }
        }
    }
}