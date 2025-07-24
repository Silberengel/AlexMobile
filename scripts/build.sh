#!/bin/bash

# Alex Reader Build Script
# This script helps with building and deploying the Nostr e-reader app

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists flutter; then
        print_error "Flutter is not installed. Please install Flutter first."
        exit 1
    fi
    
    if ! command_exists dart; then
        print_error "Dart is not installed. Please install Dart first."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Clean project
clean_project() {
    print_status "Cleaning project..."
    flutter clean
    flutter pub get
    print_success "Project cleaned"
}

# Generate code
generate_code() {
    print_status "Generating code..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_success "Code generation completed"
}

# Run tests
run_tests() {
    print_status "Running tests..."
    flutter test
    print_success "Tests completed"
}

# Build for Android
build_android() {
    print_status "Building for Android..."
    
    # Check if Android SDK is available
    if ! command_exists adb; then
        print_warning "Android SDK not found. Make sure ANDROID_HOME is set."
    fi
    
    flutter build apk --release
    print_success "Android build completed"
}

# Build for iOS
build_ios() {
    print_status "Building for iOS..."
    
    # Check if Xcode is available (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command_exists xcodebuild; then
            print_error "Xcode not found. Please install Xcode first."
            exit 1
        fi
    else
        print_warning "iOS builds are only supported on macOS"
        return
    fi
    
    flutter build ios --release
    print_success "iOS build completed"
}

# Run the app
run_app() {
    print_status "Running the app..."
    flutter run
}

# Analyze code
analyze_code() {
    print_status "Analyzing code..."
    flutter analyze
    print_success "Code analysis completed"
}

# Format code
format_code() {
    print_status "Formatting code..."
    dart format lib/
    print_success "Code formatting completed"
}

# Show help
show_help() {
    echo "Alex Reader Build Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  clean       - Clean the project and get dependencies"
    echo "  generate    - Generate code (Isar, Riverpod)"
    echo "  test        - Run tests"
    echo "  analyze     - Analyze code for issues"
    echo "  format      - Format code"
    echo "  android     - Build Android APK"
    echo "  ios         - Build iOS app"
    echo "  run         - Run the app in debug mode"
    echo "  all         - Clean, generate, analyze, and build for both platforms"
    echo "  help        - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 clean"
    echo "  $0 generate"
    echo "  $0 android"
    echo "  $0 all"
}

# Main script logic
main() {
    case "${1:-help}" in
        "clean")
            check_prerequisites
            clean_project
            ;;
        "generate")
            check_prerequisites
            generate_code
            ;;
        "test")
            check_prerequisites
            run_tests
            ;;
        "analyze")
            check_prerequisites
            analyze_code
            ;;
        "format")
            check_prerequisites
            format_code
            ;;
        "android")
            check_prerequisites
            clean_project
            generate_code
            build_android
            ;;
        "ios")
            check_prerequisites
            clean_project
            generate_code
            build_ios
            ;;
        "run")
            check_prerequisites
            clean_project
            generate_code
            run_app
            ;;
        "all")
            check_prerequisites
            clean_project
            generate_code
            analyze_code
            build_android
            build_ios
            print_success "All tasks completed!"
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Run main function with all arguments
main "$@" 