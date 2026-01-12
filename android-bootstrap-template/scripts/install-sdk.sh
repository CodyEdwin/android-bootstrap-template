#!/bin/bash

# =============================================================================
# Android SDK Auto-Installation Script
# =============================================================================
# This script downloads and installs the Android SDK with required components.
# It is automatically executed during Gradle build if the SDK is not found.
# =============================================================================

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOCAL_SDK_DIR="$PROJECT_DIR/local-sdk"
SDK_VERSION="34"
BUILD_TOOLS_VERSION="34.0.0"

# Detect OS
OS_TYPE="linux"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="mac"
elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]] || [[ "$OSTYPE" == "win32"* ]]; then
    OS_TYPE="win"
fi

echo "=========================================="
echo "Android SDK Auto-Installation"
echo "=========================================="
echo "OS Type: $OS_TYPE"
echo "Project Directory: $PROJECT_DIR"
echo "SDK will be installed to: $LOCAL_SDK_DIR"
echo ""

# Check if SDK is already installed
check_sdk_installed() {
    if [ ! -d "$LOCAL_SDK_DIR" ]; then
        return 1
    fi
    
    # Check for required components
    if [ ! -d "$LOCAL_SDK_DIR/platforms/android-$SDK_VERSION" ]; then
        return 1
    fi
    
    if [ ! -d "$LOCAL_SDK_DIR/build-tools/$BUILD_TOOLS_VERSION" ]; then
        return 1
    fi
    
    if [ ! -d "$LOCAL_SDK_DIR/platform-tools" ]; then
        return 1
    fi
    
    return 0
}

# Download command line tools
download_command_line_tools() {
    local url="https://dl.google.com/android/repository/commandlinetools"
    
    case "$OS_TYPE" in
        win)
            url="$url/win-13114758_latest.zip"
            ;;
        mac)
            url="$url/mac-13114758_latest.zip"
            ;;
        linux|*)
            url="$url/linux-13114758_latest.zip"
            ;;
    esac
    
    echo "Downloading Android Command Line Tools..."
    echo "URL: $url"
    
    local zip_file="$PROJECT_DIR/cmdline-tools.zip"
    
    curl -L -o "$zip_file" "$url"
    
    echo "Download complete."
    echo ""
    
    return 0
}

# Extract and install command line tools
extract_command_line_tools() {
    local zip_file="$PROJECT_DIR/cmdline-tools.zip"
    local temp_dir="$PROJECT_DIR/cmdline-tools-temp"
    
    echo "Extracting command line tools..."
    
    mkdir -p "$temp_dir"
    
    case "$OS_TYPE" in
        win)
            unzip -q "$zip_file" -d "$temp_dir"
            ;;
        *)
            unzip -q "$zip_file" -d "$temp_dir"
            ;;
    esac
    
    # Move to final location
    local cmdline_tools_dir="$LOCAL_SDK_DIR/cmdline-tools"
    
    if [ -d "$cmdline_tools_dir" ]; then
        rm -rf "$cmdline_tools_dir"
    fi
    
    # Find the extracted folder
    local extracted_folder=$(find "$temp_dir" -maxdepth 1 -type d -name "*cmdline-tools*" | head -n 1)
    
    if [ -n "$extracted_folder" ]; then
        mv "$extracted_folder" "$cmdline_tools_dir"
    else
        # Try alternative structure
        mkdir -p "$cmdline_tools_dir"
        if [ -d "$temp_dir/cmdline-tools" ]; then
            cp -r "$temp_dir/cmdline-tools/." "$cmdline_tools_dir/"
        fi
    fi
    
    # Clean up
    rm -rf "$temp_dir"
    rm -f "$zip_file"
    
    echo "Command line tools installed to: $cmdline_tools_dir"
    echo ""
    
    return 0
}

# Accept licenses and install SDK components
install_sdk_components() {
    local cmdline_tools_dir="$LOCAL_SDK_DIR/cmdline-tools"
    local sdk_manager="$cmdline_tools_dir/bin/sdkmanager"
    
    if [ "$OS_TYPE" = "win" ]; then
        sdk_manager="$cmdline_tools_dir/bin/sdkmanager.bat"
    fi
    
    # Make executable on Unix systems
    if [ "$OS_TYPE" != "win" ]; then
        chmod +x "$sdk_manager"
    fi
    
    echo "Installing Android SDK components..."
    echo ""
    
    # Create licenses directory
    mkdir -p "$LOCAL_SDK_DIR/licenses"
    
    # Accept licenses
    local licenses=(
        "24333f8a63b6825ea9c5514f83c2829b004d1fee"
        "d56f5187479451eabf01fb78af6dfcb131a6481e"
        "84831b9409646a918e30573bab4c9c91346d8abd"
    )
    
    for license in "${licenses[@]}"; do
        echo "$license" > "$LOCAL_SDK_DIR/licenses/$license"
    done
    
    # Components to install
    local components=(
        "platforms;android-$SDK_VERSION"
        "build-tools;$BUILD_TOOLS_VERSION"
        "platform-tools"
    )
    
    for component in "${components[@]}"; do
        echo "Installing: $component"
        
        # Install with license acceptance
        yes | "$sdk_manager" --sdk_root="$LOCAL_SDK_DIR" --install "$component" 2>/dev/null || \
        "$sdk_manager" --sdk_root="$LOCAL_SDK_DIR" --install "$component" --licenses --no_https 2>/dev/null || \
        true
    done
    
    echo ""
    echo "SDK components installed successfully."
    echo ""
    
    return 0
}

# Generate local.properties file
generate_local_properties() {
    local local_props_file="$PROJECT_DIR/local.properties"
    
    echo "Generating local.properties..."
    
    echo "sdk.dir=$LOCAL_SDK_DIR" > "$local_props_file"
    
    echo "local.properties created with SDK path: $LOCAL_SDK_DIR"
    echo ""
    
    return 0
}

# Main execution
main() {
    echo "Checking for existing SDK installation..."
    echo ""
    
    if check_sdk_installed; then
        echo "✓ Android SDK is already installed and configured."
        echo ""
        exit 0
    fi
    
    echo "Android SDK not found. Proceeding with installation..."
    echo ""
    
    # Download
    download_command_line_tools
    
    # Extract
    extract_command_line_tools
    
    # Install components
    install_sdk_components
    
    # Generate local.properties
    generate_local_properties
    
    echo "=========================================="
    echo "Android SDK Installation Complete"
    echo "=========================================="
    echo "SDK Location: $LOCAL_SDK_DIR"
    echo "Android API Level: $SDK_VERSION"
    echo "Build Tools: $BUILD_TOOLS_VERSION"
    echo ""
    echo "You can now build your Android project with:"
    echo "  ./gradlew assembleDebug"
    echo ""
}

# Run main function
main "$@"
