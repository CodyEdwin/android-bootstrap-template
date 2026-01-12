#!/bin/bash

# =============================================================================
# Project Verification Script
# =============================================================================
# This script verifies that the Android Auto-Bootstrap Template
# is properly configured and ready for building.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "Android Bootstrap Template Verification"
echo "=========================================="
echo ""

# Check for required files
check_file() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        echo "✓ $description: $file"
        return 0
    else
        echo "✗ $description: $file (MISSING)"
        return 1
    fi
}

# Check for required directories
check_directory() {
    local dir=$1
    local description=$2
    
    if [ -d "$dir" ]; then
        echo "✓ $description: $dir"
        return 0
    else
        echo "✗ $description: $dir (MISSING)"
        return 1
    fi
}

echo "Checking project structure..."
echo ""

# Critical files
FILES_OK=true

check_file "gradlew" "Gradle wrapper script" || FILES_OK=false
check_file "gradle/wrapper/gradle-wrapper.jar" "Gradle wrapper JAR" || FILES_OK=false
check_file "gradle/wrapper/gradle-wrapper.properties" "Gradle wrapper properties" || FILES_OK=false
check_file "settings.gradle" "Gradle settings file" || FILES_OK=false
check_file "build.gradle" "Root build file" || FILES_OK=false
check_file "app/build.gradle" "App module build file" || FILES_OK=false

echo ""

# Check app source files
check_file "app/src/main/AndroidManifest.xml" "Android Manifest" || FILES_OK=false
check_file "app/src/main/java/com/example/helloworld/MainActivity.java" "Main Activity" || FILES_OK=false
check_file "app/src/main/res/layout/activity_main.xml" "Main layout" || FILES_OK=false
check_file "app/src/main/res/values/strings.xml" "Strings resource" || FILES_OK=false
check_file "app/src/main/res/values/colors.xml" "Colors resource" || FILES_OK=false
check_file "app/src/main/res/values/themes.xml" "Themes resource" || FILES_OK=false

echo ""

# Check configuration files
check_file "gradle.properties" "Gradle properties" || FILES_OK=false
check_file ".gitignore" "Git ignore file" || FILES_OK=false
check_file "README.md" "Documentation" || FILES_OK=false
check_file "scripts/install-sdk.sh" "SDK installation script" || FILES_OK=false

echo ""

# Verify gradle-wrapper.properties content
echo "Checking Gradle version configuration..."
if grep -q "gradle-8.5" gradle/wrapper/gradle-wrapper.properties; then
    echo "✓ Gradle 8.5 configured"
else
    echo "✗ Gradle version mismatch"
    FILES_OK=false
fi

echo ""

# Verify Java toolchain configuration
echo "Checking Java toolchain configuration..."
if grep -q "ADOPTIUM" app/build.gradle; then
    echo "✓ Eclipse Temurin JDK configured"
else
    echo "✗ JDK configuration not found"
    FILES_OK=false
fi

if grep -q "JavaLanguageVersion.of(17)" app/build.gradle; then
    echo "✓ Java 17 configured"
else
    echo "✗ Java version not configured"
    FILES_OK=false
fi

echo ""

# Verify Android SDK configuration
echo "Checking Android SDK configuration..."
if grep -q "compileSdk 34" app/build.gradle; then
    echo "✓ Android SDK 34 configured"
else
    echo "✗ Android SDK version not configured"
    FILES_OK=false
fi

echo ""

# Summary
echo "=========================================="
if [ "$FILES_OK" = true ]; then
    echo "✓ All checks passed!"
    echo ""
    echo "Project is ready for building."
    echo ""
    echo "To build the project, run:"
    echo "  ./gradlew assembleDebug"
    echo ""
    echo "The first build will automatically download:"
    echo "  - Gradle 8.5 (if not present)"
    echo "  - Eclipse Temurin JDK 17"
    echo "  - Android SDK 34"
    echo "  - Required SDK components"
    exit 0
else
    echo "✗ Some checks failed!"
    echo ""
    echo "Please review the missing files above."
    exit 1
fi
