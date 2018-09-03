buildscript {
	repositories {
		maven("https://dl.bintray.com/jetbrains/kotlin-native-dependencies")
		maven("https://dl.bintray.com/kotlin/kotlin-eap/")
	}
}

plugins {
    id("org.jetbrains.kotlin.konan").version("0.9-rc1-3632")
}

repositories {
	maven("https://dl.bintray.com/jetbrains/kotlin-native-dependencies")
	maven("https://dl.bintray.com/kotlin/kotlin-eap/")
}
        
konanArtifacts { program("HelloWorld") }
