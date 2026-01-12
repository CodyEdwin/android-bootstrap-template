# Android Auto-Bootstrap Template

A **complete, reusable Android project template** that automatically handles environment setup, including **Eclipse Temurin JDK 17** and **Android SDK 34** installation during the Gradle build process. This template is designed to work on any machine with just Git and a shell installed—no manual Android Studio installation required.

## Features

- **Automatic JDK Provisioning**: Uses Gradle Toolchains to automatically download and configure Eclipse Temurin JDK 17
- **Automatic Android SDK Setup**: Downloads and installs Android SDK with required components during build
- **Zero Manual Configuration**: No need to install Android Studio or manually set up environment variables
- **Cross-Platform Support**: Works on Windows, macOS, and Linux
- **Reusable Template**: Clone and customize for any new Android project
- **Hello World App**: Pre-configured with Material Design 3 UI

## Requirements

- **Git**: To clone the repository
- **Internet Connection**: Required to download JDK and Android SDK components
- **Operating System**: Windows 10+, macOS 10.15+, or Linux (Ubuntu 20.04+ recommended)
- **Disk Space**: At least 2GB free space for SDK and JDK installation

## Quick Start

### 1. Clone and Initialize

```bash
# Clone the repository
git clone https://github.com/yourusername/android-bootstrap-template.git
cd android-bootstrap-template

# (Optional) Initialize the Gradle wrapper if not included
# gradle wrapper --gradle-version 8.5
```

### 2. Build the Project

Run the Gradle wrapper to build the project:

```bash
# On Linux/macOS
./gradlew assembleDebug

# On Windows
gradlew.bat assembleDebug
```

### 3. What Happens During First Build

On the first build, the following will occur automatically:

1. **Gradle Wrapper Activation**: Downloads Gradle 8.5 if not present
2. **JDK Installation**: Downloads and installs Eclipse Temurin JDK 17 via Gradle Toolchains
3. **Android SDK Download**: Downloads Android Command Line Tools (~100MB)
4. **SDK Component Installation**: Installs:
   - Android Platform API 34
   - Build Tools 34.0.0
   - Platform Tools
5. **License Acceptance**: Automatically accepts all Android SDK licenses
6. **Project Compilation**: Builds the Hello World APK

### 4. Locate the APK

After successful compilation, find your APK at:

```
app/build/outputs/apk/debug/app-debug.apk
```

## Project Structure

```
android-bootstrap-template/
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar      # Gradle 8.5 wrapper
│       └── gradle-wrapper.properties
├── app/
│   ├── build.gradle                # App module configuration
│   └── src/main/
│       ├── java/com/example/helloworld/
│       │   └── MainActivity.java   # Main application code
│       ├── res/
│       │   ├── layout/activity_main.xml
│       │   ├── values/strings.xml, colors.xml, themes.xml
│       │   └── mipmap-*/ launcher icons
│       └── AndroidManifest.xml
├── scripts/
│   └── install-sdk.sh              # Manual SDK installation script
├── build.gradle                    # Root build configuration
├── settings.gradle                 # Gradle settings with SDK bootstrap
├── local.properties                # Auto-generated SDK path
├── gradlew                         # Unix build script
├── gradlew.bat                     # Windows build script
└── README.md                       # This file
```

## Configuration

### Changing Target Android Version

Edit `app/build.gradle` to modify the target SDK:

```groovy
android {
    compileSdk 34  // Change to your desired API level
    defaultConfig {
        targetSdk 34  // Change to your desired API level
    }
}
```

Then update the SDK version in `settings.gradle`:

```groovy
def sdkVersion = "34"  // Change to match your target SDK
def buildToolsVersion = "34.0.0"  // Update to match available build tools
```

### Changing Java Version

Edit `app/build.gradle` to use a different Java version:

```groovy
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(17)  // Change version number
        vendor = JvmVendorSpec.ADOPTIUM  // Temurin/Adoptium
    }
}
```

### Adding Dependencies

Add dependencies to `app/build.gradle`:

```groovy
dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    
    // Add your dependencies here
    implementation 'com.squareup.retrofit:retrofit:2.9.0'
    implementation 'com.squareup.okhttp3:okhttp:4.12.0'
}
```

## Gradle Tasks

Common Gradle tasks for this project:

```bash
# Build debug APK
./gradlew assembleDebug

# Build release APK
./gradlew assembleRelease

# Run unit tests
./gradlew test

# Run lint checks
./gradlew lint

# Clean build artifacts
./gradlew clean

# Get dependency tree
./gradlew dependencies

# Show all tasks
./gradlew tasks
```

## Troubleshooting

### Build Fails with Network Error

If the build fails due to network issues during SDK download:

1. Check your internet connection
2. Ensure you're not behind a firewall that blocks Google servers
3. Try running the manual installation script:

```bash
bash scripts/install-sdk.sh
```

### JAVA_HOME Not Set

The project uses Gradle Toolchains to automatically download JDK. If you encounter issues:

1. Ensure Java is not already installed in a non-standard location
2. Gradle will download JDK to `~/.gradle/jdks/` on first use
3. You can manually set `JAVA_HOME` if needed:

```bash
export JAVA_HOME=/path/to/your/jdk
./gradlew assembleDebug
```

### SDK License Acceptance Failed

If license acceptance fails during build:

1. Delete the `local-sdk/licenses/` folder
2. Run the build again, licenses will be re-accepted automatically
3. Or manually accept licenses:

```bash
yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --licenses
```

### Out of Disk Space

The Android SDK and JDK require significant disk space:

- Android SDK: ~1GB
- JDK: ~200MB
- Build cache: ~500MB

Ensure you have at least 2GB free space.

## How It Works

### JDK Auto-Provisioning

The project uses Gradle's Java Toolchain feature to automatically detect, download, and configure the correct JDK version:

```groovy
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(17)
        vendor = JvmVendorSpec.ADOPTIUM
    }
}
```

When Gradle runs, it checks for the specified JDK. If not found, it downloads Eclipse Temurin JDK 17 to the Gradle user home (`~/.gradle/jdks/`).

### Android SDK Bootstrap

The `settings.gradle` file contains an initialization script that:

1. **Checks for existing SDK**: Looks for `local.properties` with valid SDK path
2. **Downloads SDK**: If not found, downloads Android Command Line Tools
3. **Installs Components**: Uses `sdkmanager` to install required SDK components
4. **Generates Configuration**: Creates `local.properties` with SDK path

This ensures the SDK is available before any build tasks run.

## Customization Guide

### Changing the App Name

Edit `app/src/main/res/values/strings.xml`:

```xml
<string name="app_name">Your App Name</string>
```

### Changing the Package Name

1. Edit `app/build.gradle`:

```groovy
android {
    namespace 'com.yourcompany.yourapp'
}
```

2. Move the Java source folder:

```bash
mv app/src/main/java/com/example/helloworld \
   app/src/main/java/com/yourcompany/yourapp
```

3. Update the package declaration in `MainActivity.java`

### Adding New Screens

1. Create a new Activity class in `app/src/main/java/com/example/helloworld/`
2. Add it to `AndroidManifest.xml`:

```xml
<activity
    android:name=".NewActivity"
    android:exported="false" />
```

3. Create corresponding layout XML in `app/src/main/res/layout/`

## Contributing

This template is designed to be a starting point for your Android projects. Feel free to:

1. Fork and customize for your needs
2. Add features that benefit other developers
3. Report issues or suggest improvements

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Gradle](https://gradle.org/) - Build automation tool
- [Eclipse Temurin](https://adoptium.net/) - OpenJDK distribution
- [Android](https://developer.android.com/) - Mobile operating system
- [Material Design](https://material.io/) - Design system

## Version History

- **v1.0.0** - Initial release with Gradle 8.5, JDK 17, Android SDK 34
