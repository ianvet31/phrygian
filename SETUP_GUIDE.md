# Quick Setup Guide

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (version 3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **For Android Development:**
   - Android Studio with Android SDK
   - Android SDK Platform Tools
   - Accept Android licenses: `flutter doctor --android-licenses`

3. **For iOS Development (macOS only):**
   - Xcode (latest version recommended)
   - CocoaPods: `sudo gem install cocoapods`

## Installation Steps

### 1. Clone the Repository
```bash
git clone https://github.com/ianvet31/phrygian.git
cd phrygian
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Setup
```bash
flutter doctor
```

This command checks your environment and displays a report of the status of your Flutter installation. Fix any issues reported.

## Running the App

### On Android Device/Emulator

1. Connect an Android device via USB with USB debugging enabled, or start an Android emulator
2. Verify the device is connected:
   ```bash
   flutter devices
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### On iOS Device/Simulator (macOS only)

1. Open iOS Simulator or connect an iOS device
2. Verify the device is connected:
   ```bash
   flutter devices
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Building Release Versions

### Android APK
```bash
flutter build apk --release
```
The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Google Play)
```bash
flutter build appbundle --release
```

### iOS (macOS only)
```bash
flutter build ios --release
```

## Testing

Run the test suite:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## Troubleshooting

### Common Issues

1. **"flutter: command not found"**
   - Ensure Flutter is added to your PATH
   - Restart your terminal after installation

2. **Android license status unknown**
   ```bash
   flutter doctor --android-licenses
   ```

3. **CocoaPods issues (iOS)**
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Gradle build fails**
   - Ensure Java JDK is installed (version 11 or higher)
   - Clear Gradle cache: `cd android && ./gradlew clean`

5. **Dependencies not resolving**
   ```bash
   flutter pub cache repair
   flutter clean
   flutter pub get
   ```

## Development Tips

### Hot Reload
While the app is running, press `r` in the terminal to hot reload changes.

### Hot Restart
Press `R` (capital R) for a full restart.

### Debug Mode
The app runs in debug mode by default with `flutter run`. This enables hot reload and debugging features.

### Release Mode
For performance testing, run:
```bash
flutter run --release
```

### Analyze Code
```bash
flutter analyze
```

### Format Code
```bash
flutter format lib/
```

## IDE Setup

### VS Code
1. Install the Flutter extension
2. Install the Dart extension
3. Open the project folder
4. Use F5 to start debugging

### Android Studio / IntelliJ
1. Install Flutter plugin
2. Install Dart plugin
3. Open the project
4. Use the Run button or Shift+F10 to start

## Next Steps

Once the app is running:
1. Grant microphone permission when prompted
2. Tap "Start Tuner" to begin
3. Play a guitar string and watch the tuner respond

Note: The current version includes a demo mode. For production use with actual audio detection, additional implementation would be required.

## Getting Help

- Flutter documentation: https://flutter.dev/docs
- Flutter community: https://flutter.dev/community
- Report issues: https://github.com/ianvet31/phrygian/issues
