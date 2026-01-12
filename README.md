# Android Bootstrap Template

A production-ready Android project template with automatic Java and Android SDK provisioning. This repository serves as a standardized foundation for Android development, eliminating the need for manual environment setup and ensuring consistent build configurations across different machines.

## Overview

This template provides a complete, out-of-the-box Android development environment that automatically downloads and configures the required dependencies during the Gradle build process. The project uses Gradle 8.5 with the Eclipse Temurin JDK 17 toolchain, targeting Android API Level 34 with Build Tools 34.0.0. The primary goal of this template is to enable developers to clone the repository and immediately begin building Android applications without spending time on environment configuration, version compatibility checks, or SDK installation procedures.

The template includes a sophisticated auto-provisioning mechanism embedded within the Gradle settings script. This mechanism detects missing dependencies and downloads them automatically before the build process begins. This approach ensures that the project remains self-contained and portable, making it ideal for team collaboration, CI/CD pipelines, and rapid prototyping scenarios where environment setup overhead must be minimized.

## Quick Start

To begin using this template for your Android projects, follow these steps to clone the repository and prepare your development environment. The entire process is designed to be straightforward and requires minimal manual intervention.

First, clone the repository to your local machine using Git. Open a terminal and execute the following command, replacing the repository URL with your fork or the original source if you have not yet created your own fork. The repository includes all necessary configuration files, build scripts, and template code to get you started immediately.

```bash
git clone https://github.com/yourusername/android-bootstrap-template.git
cd android-bootstrap-template
```

After cloning the repository, you have two options for building the project. The first option allows the auto-provisioning script to download the required SDK components during the first build. This approach requires an active internet connection but ensures that all dependencies are correctly installed without manual intervention.

```bash
./gradlew assembleDebug
```

The second option involves manually installing the Android SDK before running the build. This approach is useful when you already have the Android SDK installed on your system or when network restrictions prevent automatic downloads. To use an existing SDK installation, modify the `local.properties` file to point to your SDK directory before building.

Once the build completes successfully, you can find the generated APK file at `app/build/outputs/apk/debug/app-debug.apk`. This APK is ready for installation on Android devices running API Level 21 (Android 5.0) or higher.

## Project Structure

Understanding the project structure is essential for effectively utilizing this template and customizing it to meet your specific requirements. The repository follows standard Android project conventions while incorporating additional files and directories that support the automatic provisioning mechanism.

The root directory contains essential Gradle configuration files that define the build behavior for the entire project. The `build.gradle` file at this level configures the root build script, typically defining plugins and repositories used across all subprojects. The `settings.gradle` file is particularly important as it contains the auto-provisioning logic that ensures the Android SDK is available before the build begins. The `gradle.properties` file allows you to customize Gradle behavior, including memory allocation, caching options, and build performance parameters.

```
android-bootstrap-template/
├── .github/
│   └── workflows/
│       └── android.yml          # GitHub Actions CI/CD workflow
├── app/
│   ├── build.gradle             # App module build configuration
│   ├── proguard-rules.pro       # ProGuard optimization rules
│   └── src/
│       ├── main/
│       │   ├── AndroidManifest.xml
│       │   ├── java/
│       │   │   └── com/example/app/
│       │   │       ├── MainActivity.java
│       │   │       └── ...
│       │   └── res/
│       │       ├── drawable/
│       │       ├── layout/
│       │       ├── mipmap-*/
│       │       ├── values/
│       │       └── ...
│       └── test/                 # Unit tests
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── scripts/
│   └── install-sdk.sh           # Manual SDK installation script
├── build.gradle                 # Root build configuration
├── settings.gradle              # Project settings with auto-provisioning
├── gradle.properties            # Gradle system properties
├── gradlew                      # Gradle wrapper script (Linux/macOS)
├── gradlew.bat                  # Gradle wrapper script (Windows)
├── local.properties             # SDK location (generated)
└── README.md                    # This file
```

The `app/` directory contains the main application module. This is where you will implement your application logic, design user interfaces, and manage application resources. The `src/main/` subdirectory holds the primary source code and resources, while `src/test/` contains unit tests that verify the correctness of your code. The `build.gradle` file within the app module configures dependencies, build types, product flavors, and other module-specific settings.

The `.github/workflows/` directory contains GitHub Actions workflow files that automate the build and deployment process. The included `android.yml` workflow configures a complete CI/CD pipeline that sets up Java, downloads the Android SDK, builds the APK, and uploads the build artifacts. This workflow runs automatically on every push to the main branch and on all pull requests.

## Configuration Reference

### Gradle Configuration

The project uses Gradle 8.5 with the Android Gradle Plugin 8.1.0, which provides compatibility with Java 17 and Android API Level 34. The following code block shows the typical configuration for the root `build.gradle` file, including the plugin declarations and repository configuration.

```groovy
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id 'com.android.application' version '8.1.0' apply false
    id 'com.android.library' version '8.1.0' apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
```

The `app/build.gradle` file defines the application module configuration. This includes the application ID, version information, build types, and dependencies. The following example demonstrates a typical configuration for a new Android application.

```groovy
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.example.app'
    compileSdk 34

    defaultConfig {
        applicationId "com.example.app"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            minifyEnabled false
            debuggable true
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
```

### Auto-Provisioning Mechanism

The `settings.gradle` file contains an embedded `AndroidSdkBootstrap` class that manages the automatic download and configuration of the Android SDK. This mechanism runs before any Gradle tasks are executed, ensuring that the SDK is available when needed. The bootstrapper performs the following operations: it creates a `local.properties` file pointing to the SDK location, downloads the Android command-line tools if they are not present, accepts the SDK licenses, and installs the required SDK components including platform-tools, platforms, and build-tools.

The bootstrapper uses the Gradle project directory to store the downloaded SDK components in a `local-sdk` subdirectory. This approach keeps the SDK isolated from the system-wide installation and allows multiple projects to maintain their own SDK installations without conflicts. If you prefer to use a system-wide can either SDK installation, you set the `ANDROID_HOME` environment variable or create a `local.properties` file with the `sdk.dir` property pointing to your existing SDK directory.

## Creating New Android Projects

To create a new Android project based on this template, begin by forking or copying the repository to your own GitHub account or local machine. Then, modify the project configuration to match your application's requirements. The following steps guide you through the essential modifications needed to customize the template for your specific use case.

First, update the application identifier in `app/build.gradle` to reflect your application's package name. The application ID uniquely identifies your application on the Google Play Store and on user devices. Choose a package name that follows reverse domain notation, such as `com.yourcompany.yourapp`.

```groovy
defaultConfig {
    applicationId "com.yourcompany.yourapp"
    minSdk 21
    targetSdk 34
    versionCode 1
    versionName "1.0.0"
}
```

Next, modify the Android manifest file at `app/src/main/AndroidManifest.xml` to specify your application's main activity, required permissions, and other manifest attributes. The manifest declares the components that make up your application and provides the Android system with essential information about your app.

Then, update the `settings.gradle` file to reflect your project's name. The `rootProject.name` property determines the name of the Gradle project and appears in build output and IDE project views.

```groovy
rootProject.name = "YourAppName"
```

Finally, clean up the existing template code in the `app/src/main/java/` and `app/src/main/res/` directories. Replace the placeholder `MainActivity.java` with your application's main activity, update the launcher icons with your brand assets, and modify the string resources to match your application's content.

## Using GitHub Actions

The included GitHub Actions workflow automates the build process and ensures that your application is built consistently on every code change. The workflow configuration is located at `.github/workflows/android.yml` and performs the following operations on each push to the main branch.

The workflow sets up Java 17, caches Gradle dependencies for faster builds, downloads and configures the Android SDK, builds the debug APK, and uploads the generated APK as a workflow artifact. You can download the built APK from the Actions tab in your GitHub repository after each workflow run.

To customize the workflow for your specific requirements, you can modify the `android.yml` file. For example, to add release builds that are uploaded to GitHub releases, you can extend the workflow with additional steps that invoke the `assembleRelease` Gradle task and use the `softprops/action-gh-release` action to publish the release artifacts.

## Dependency Management

Managing dependencies correctly is crucial for maintaining a stable and maintainable Android project. This template uses the Gradle dependency management system to declare and resolve external libraries. Dependencies are declared in the `dependencies` block of `app/build.gradle` with different configurations that control how and when each dependency is included in your build.

The `implementation` configuration adds dependencies to the compile and runtime classpaths, making them available to your code during development and included in the final APK. Use this configuration for runtime dependencies such as AndroidX libraries, third-party SDKs, and utility libraries.

The `testImplementation` configuration adds dependencies that are only available during unit test compilation and execution. Use this for testing frameworks like JUnit, Mockito, and AndroidX Test.

The `androidTestImplementation` configuration adds dependencies for instrumented tests that run on Android devices or emulators. Use this for Espresso, UI Automator, and other testing frameworks that require the Android runtime environment.

When updating dependencies, always check for compatibility between the library version and your configured compile SDK, min SDK, and target SDK versions. Consult the library's documentation for version requirements and migration guides when upgrading major versions.

## Build Variants

Android projects often require multiple build variants to support different product flavors, build types, and configurations. This template supports standard debug and release builds out of the box, but you can extend the configuration to support additional variants.

Build types define how the build process packages your application. The debug build type enables debugging features and is optimized for development, while the release build type enables code shrinking, optimization, and signing. To add a custom build type, modify the `buildTypes` block in `app/build.gradle`.

Product flavors allow you to create different versions of your application for different markets, audiences, or distribution channels. For example, you might create free and paid flavors, or flavors for different API environments such as development, staging, and production.

## Troubleshooting

When encountering build issues, follow these troubleshooting steps to identify and resolve common problems. The Gradle build process provides detailed error messages that usually indicate the specific cause of failures.

If you encounter Java-related errors such as "unable to resolve class" or compatibility warnings, ensure that you are using the correct Java version. This template requires Java 17, which is automatically provisioned by the GitHub Actions workflow. On your local machine, verify that the `JAVA_HOME` environment variable points to a Java 17 installation or let the Gradle toolchain auto-provision the required JDK.

SDK-related errors typically indicate that the Android SDK components are missing or incorrectly configured. If automatic provisioning fails, you can manually run the `scripts/install-sdk.sh` script or download the Android command-line tools from the official Google repository and extract them to the `local-sdk/cmdline-tools` directory.

Gradle daemon issues can cause build failures or slow build performance. To resolve these issues, stop the daemon and clear the Gradle cache by running `./gradlew --stop` and then deleting the `~/.gradle/caches` directory.

Memory-related errors during build may require adjusting the Gradle memory allocation. Modify the `org.gradle.jvmargs` property in `gradle.properties` to increase the available heap size. A value of `-Xmx2048m` allocates 2 GB of memory to the Gradle daemon.

## Best Practices

Following established best practices ensures that your Android project remains maintainable, testable, and scalable as it grows. The following recommendations apply to projects created from this template and should guide your development decisions.

Maintain a clean separation of concerns in your codebase by organizing classes into logical packages based on their responsibility. Common package structures include `data/` for data access and repository implementations, `domain/` for business logic and use cases, `presentation/` for UI components and view controllers, and `di/` for dependency injection configurations.

Write comprehensive unit tests for your business logic and data processing code. Unit tests should be fast, deterministic, and isolated from Android framework dependencies. Use mocking frameworks to replace dependencies with test doubles when necessary.

Implement continuous integration from the beginning of your project. The included GitHub Actions workflow provides a foundation for automated testing and building. Extend this workflow to include static code analysis, unit test execution, and integration test runs on every pull request.

Version your project dependencies explicitly and review them regularly for security updates and performance improvements. Use tools like `gradlew dependencies` to analyze your dependency tree and identify potential conflicts or outdated versions.

Document significant architectural decisions and design patterns used in your project. This documentation helps team members understand the rationale behind implementation choices and reduces onboarding time for new contributors.

## Maintenance

Regular maintenance ensures that your project remains compatible with the latest Android platform features, security updates, and development tools. Schedule periodic reviews of your project's dependencies, build configuration, and target SDK version.

When updating the Android Gradle Plugin or Gradle version, review the official release notes for breaking changes and migration requirements. Test the updated configuration thoroughly before deploying changes to production branches.

Monitor the Android API level distribution statistics to make informed decisions about your minimum and target SDK versions. Supporting older API levels increases your potential audience but may require additional compatibility code for newer platform features.

Back up your project regularly and maintain a clean Git history by using meaningful commit messages and organizing related changes into logical commits. This practice simplifies code review, debugging, and reverting changes when necessary.

## License

This project is provided as a foundation for Android development and can be used, modified, and distributed according to your requirements. When building applications based on this template, ensure that you comply with the licenses of all included dependencies and third-party libraries.

The Android Open Source Project license applies to Android platform components. The Eclipse Public License applies to the Temurin JDK. Third-party libraries included in your application have their own license requirements that you must review and comply with.
