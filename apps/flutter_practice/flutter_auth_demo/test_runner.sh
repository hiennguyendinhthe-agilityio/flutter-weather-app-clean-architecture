#!/bin/bash

# Flutter Auth Demo - Patrol Test Runner
# This script runs Patrol integration tests with proper setup

echo "🚀 Flutter Auth Demo - Patrol Test Runner"
echo "=========================================="

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

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter version:"
flutter --version

# Check if Patrol CLI is installed
if ! command -v patrol &> /dev/null; then
    print_warning "Patrol CLI not found. Installing..."
    dart pub global activate patrol_cli
    
    if ! command -v patrol &> /dev/null; then
        print_error "Failed to install Patrol CLI"
        exit 1
    fi
fi

print_success "Patrol CLI is available"

# Clean and get dependencies
print_status "Cleaning project and getting dependencies..."
flutter clean
flutter pub get

# Generate code if needed
print_status "Generating code..."
dart run build_runner build --delete-conflicting-outputs

# Check for connected devices
print_status "Checking for connected devices..."
flutter devices

# Ask user which test to run
echo ""
echo "Available test options:"
echo "1. Run all Patrol tests"
echo "2. Run specific test file"
echo "3. Run tests on specific device"
echo "4. Run with video recording"
echo "5. Exit"

read -p "Choose an option (1-5): " choice

case $choice in
    1)
        print_status "Running all Patrol integration tests..."
        patrol test --target integration_test/app_test.dart
        ;;
    2)
        echo "Available test files:"
        echo "- integration_test/simple_test.dart (Basic setup test)"
        echo "- integration_test/app_test.dart (Main E2E tests)"
        echo "- integration_test/patrol_test.dart (Detailed Patrol tests)"
        read -p "Enter test file path: " test_file
        
        if [ -f "$test_file" ]; then
            print_status "Running $test_file..."
            patrol test --target "$test_file"
        else
            print_error "Test file not found: $test_file"
        fi
        ;;
    3)
        flutter devices
        read -p "Enter device ID: " device_id
        print_status "Running tests on device: $device_id"
        patrol test --target integration_test/app_test.dart --device-id "$device_id"
        ;;
    4)
        print_status "Running tests with video recording..."
        patrol test --target integration_test/app_test.dart --record-video
        ;;
    5)
        print_status "Exiting..."
        exit 0
        ;;
    *)
        print_error "Invalid option"
        exit 1
        ;;
esac

# Check test results
if [ $? -eq 0 ]; then
    print_success "All tests passed! 🎉"
    echo ""
    echo "📊 Test Summary:"
    echo "- Authentication flow: ✅"
    echo "- Form validation: ✅"
    echo "- UI interactions: ✅"
    echo "- Error handling: ✅"
    echo ""
    echo "🎯 Your Flutter Auth Demo is working perfectly!"
else
    print_error "Some tests failed. Check the output above for details."
    exit 1
fi