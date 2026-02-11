#!/bin/bash

# Flutter Virtual Try-On Build Script
# This script builds the app for both Android and iOS platforms

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    print_success "Flutter is installed"
}

# Function to check Flutter doctor
check_flutter_doctor() {
    print_info "Checking Flutter doctor..."
    flutter doctor
}

# Function to clean project
clean_project() {
    print_info "Cleaning project..."
    flutter clean
    print_success "Project cleaned"
}

# Function to get dependencies
get_dependencies() {
    print_info "Getting dependencies..."
    flutter pub get
    print_success "Dependencies retrieved"
}

# Function to run code generation
run_codegen() {
    print_info "Running code generation..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_success "Code generation completed"
}

# Function to analyze code
analyze_code() {
    print_info "Analyzing code..."
    flutter analyze
    if [ $? -eq 0 ]; then
        print_success "Code analysis passed"
    else
        print_warning "Code analysis found issues"
    fi
}

# Function to run tests
run_tests() {
    print_info "Running tests..."
    flutter test
    if [ $? -eq 0 ]; then
        print_success "All tests passed"
    else
        print_error "Some tests failed"
        exit 1
    fi
}

# Function to build APK for Android
build_android_apk() {
    print_info "Building Android APK..."
    flutter build apk --release --split-per-abi
    print_success "Android APK built successfully"
    print_info "APK location: build/app/outputs/flutter-apk/"
}

# Function to build App Bundle for Android
build_android_bundle() {
    print_info "Building Android App Bundle..."
    flutter build appbundle --release
    print_success "Android App Bundle built successfully"
    print_info "Bundle location: build/app/outputs/bundle/release/"
}

# Function to build iOS app
build_ios() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Building iOS app..."
        flutter build ios --release --no-codesign
        print_success "iOS app built successfully"
        print_info "iOS build location: build/ios/iphoneos/"
    else
        print_warning "iOS build is only supported on macOS"
    fi
}

# Function to build iOS IPA
build_ios_ipa() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Building iOS IPA..."
        flutter build ipa --release
        print_success "iOS IPA built successfully"
        print_info "IPA location: build/ios/ipa/"
    else
        print_warning "iOS IPA build is only supported on macOS"
    fi
}

# Function to show help
show_help() {
    echo "Flutter Virtual Try-On Build Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup           Setup project (clean, get dependencies)"
    echo "  analyze         Run code analysis"
    echo "  test            Run tests"
    echo "  android-apk     Build Android APK"
    echo "  android-bundle  Build Android App Bundle"
    echo "  ios             Build iOS app (macOS only)"
    echo "  ios-ipa         Build iOS IPA (macOS only)"
    echo "  all-android     Build all Android formats"
    echo "  all-ios         Build all iOS formats (macOS only)"
    echo "  all             Build for all platforms"
    echo "  doctor          Check Flutter doctor"
    echo "  help            Show this help message"
    echo ""
}

# Main script logic
case "$1" in
    "setup")
        check_flutter
        clean_project
        get_dependencies
        ;;
    "analyze")
        check_flutter
        analyze_code
        ;;
    "test")
        check_flutter
        run_tests
        ;;
    "android-apk")
        check_flutter
        get_dependencies
        build_android_apk
        ;;
    "android-bundle")
        check_flutter
        get_dependencies
        build_android_bundle
        ;;
    "ios")
        check_flutter
        get_dependencies
        build_ios
        ;;
    "ios-ipa")
        check_flutter
        get_dependencies
        build_ios_ipa
        ;;
    "all-android")
        check_flutter
        get_dependencies
        analyze_code
        build_android_apk
        build_android_bundle
        ;;
    "all-ios")
        check_flutter
        get_dependencies
        analyze_code
        build_ios
        build_ios_ipa
        ;;
    "all")
        check_flutter
        clean_project
        get_dependencies
        analyze_code
        run_tests
        build_android_apk
        build_android_bundle
        build_ios
        build_ios_ipa
        ;;
    "doctor")
        check_flutter_doctor
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    *)
        if [ -z "$1" ]; then
            show_help
        else
            print_error "Unknown command: $1"
            show_help
            exit 1
        fi
        ;;
esac

print_success "Script execution completed!"