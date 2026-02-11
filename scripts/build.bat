@echo off
REM Flutter Virtual Try-On Build Script for Windows
REM This script builds the app for Android platform on Windows

setlocal enabledelayedexpansion

REM Colors for output (Windows)
set "INFO=[INFO]"
set "SUCCESS=[SUCCESS]"
set "WARNING=[WARNING]"
set "ERROR=[ERROR]"

REM Function to check if Flutter is installed
:check_flutter
where flutter >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo %ERROR% Flutter is not installed or not in PATH
    exit /b 1
)
echo %SUCCESS% Flutter is installed
goto :eof

REM Function to clean project
:clean_project
echo %INFO% Cleaning project...
call flutter clean
if %ERRORLEVEL% equ 0 (
    echo %SUCCESS% Project cleaned
) else (
    echo %ERROR% Failed to clean project
    exit /b 1
)
goto :eof

REM Function to get dependencies
:get_dependencies
echo %INFO% Getting dependencies...
call flutter pub get
if %ERRORLEVEL% equ 0 (
    echo %SUCCESS% Dependencies retrieved
) else (
    echo %ERROR% Failed to get dependencies
    exit /b 1
)
goto :eof

REM Function to analyze code
:analyze_code
echo %INFO% Analyzing code...
call flutter analyze
if %ERRORLEVEL% equ 0 (
    echo %SUCCESS% Code analysis passed
) else (
    echo %WARNING% Code analysis found issues
)
goto :eof

REM Function to run tests
:run_tests
echo %INFO% Running tests...
call flutter test
if %ERRORLEVEL% equ 0 (
    echo %SUCCESS% All tests passed
) else (
    echo %ERROR% Some tests failed
    exit /b 1
)
goto :eof

REM Function to build APK for Android
:build_android_apk
echo %INFO% Building Android APK...
call flutter build apk --release --split-per-abi
if %ERRORLEVEL% equ 0 (
    echo %SUCCESS% Android APK built successfully
    echo %INFO% APK location: build\app\outputs\flutter-apk\
) else (
    echo %ERROR% Failed to build Android APK
    exit /b 1
)
goto :eof

REM Function to build App Bundle for Android
:build_android_bundle
echo %INFO% Building Android App Bundle...
call flutter build appbundle --release
if %ERRORLEVEL% equ 0 (
    echo %SUCCESS% Android App Bundle built successfully
    echo %INFO% Bundle location: build\app\outputs\bundle\release\
) else (
    echo %ERROR% Failed to build Android App Bundle
    exit /b 1
)
goto :eof

REM Function to show help
:show_help
echo Flutter Virtual Try-On Build Script for Windows
echo.
echo Usage: %~nx0 [COMMAND]
echo.
echo Commands:
echo   setup           Setup project (clean, get dependencies)
echo   analyze         Run code analysis
echo   test            Run tests
echo   android-apk     Build Android APK
echo   android-bundle  Build Android App Bundle
echo   all-android     Build all Android formats
echo   all             Build for Android (Windows)
echo   doctor          Check Flutter doctor
echo   help            Show this help message
echo.
goto :eof

REM Main script logic
if "%1"=="setup" (
    call :check_flutter
    call :clean_project
    call :get_dependencies
) else if "%1"=="analyze" (
    call :check_flutter
    call :analyze_code
) else if "%1"=="test" (
    call :check_flutter
    call :run_tests
) else if "%1"=="android-apk" (
    call :check_flutter
    call :get_dependencies
    call :build_android_apk
) else if "%1"=="android-bundle" (
    call :check_flutter
    call :get_dependencies
    call :build_android_bundle
) else if "%1"=="all-android" (
    call :check_flutter
    call :get_dependencies
    call :analyze_code
    call :build_android_apk
    call :build_android_bundle
) else if "%1"=="all" (
    call :check_flutter
    call :clean_project
    call :get_dependencies
    call :analyze_code
    call :run_tests
    call :build_android_apk
    call :build_android_bundle
) else if "%1"=="doctor" (
    call flutter doctor
) else if "%1"=="help" (
    call :show_help
) else if "%1"=="" (
    call :show_help
) else (
    echo %ERROR% Unknown command: %1
    call :show_help
    exit /b 1
)

echo %SUCCESS% Script execution completed!
endlocal