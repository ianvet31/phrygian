# Architecture Documentation

## Overview

Phrygian is a Flutter-based guitar tuner application designed to run on both iOS and Android platforms. The app provides real-time visual feedback to help users tune their guitar strings to standard tuning.

## Application Structure

### Core Components

#### 1. GuitarTunerApp (StatelessWidget)
- Root application widget
- Configures Material Design theme
- Sets up the app title and home screen

#### 2. TunerScreen (StatefulWidget)
- Main screen of the application
- Manages the tuner interface and user interactions

#### 3. _TunerScreenState (State)
- Manages the application state including:
  - Listening status
  - Current note detection
  - Frequency measurement
  - Tuning accuracy (in cents)
  - Status messages

### State Management

The app uses Flutter's built-in `setState()` mechanism for state management:
- `_isListening`: Boolean indicating if the tuner is active
- `_currentNote`: String representing the detected note (e.g., "E2", "A2")
- `_frequency`: Double storing the detected frequency in Hz
- `_cents`: Double indicating how far off-tune (in cents) the note is
- `_statusMessage`: String providing user feedback

### Standard Guitar Tuning

The app supports standard guitar tuning with the following frequencies:
- E2 (Low E): 82.41 Hz
- A2: 110.00 Hz
- D3: 146.83 Hz
- G3: 196.00 Hz
- B3: 246.94 Hz
- E4 (High E): 329.63 Hz

### UI Components

#### Visual Indicators
1. **Guitar Strings Display**: Shows all six strings with visual tuning indicators
2. **Note Display**: Large circular display showing the current detected note
3. **Frequency Display**: Shows the detected frequency in Hz
4. **Cents Display**: Shows deviation from perfect tuning
5. **Color Coding**:
   - Green: In tune (< 5 cents deviation)
   - Orange: Close (5-15 cents deviation)
   - Red: Out of tune (> 15 cents deviation)

#### User Controls
- **Start/Stop Button**: Toggles the tuner on/off
- Changes color based on state (blue when stopped, red when active)

## Platform-Specific Configuration

### Android
- **Minimum SDK**: 21 (Android 5.0 Lollipop)
- **Target SDK**: 34 (Android 14)
- **Permissions**: RECORD_AUDIO (for microphone access)
- **Main Activity**: FlutterActivity in Kotlin

### iOS
- **Deployment Target**: iOS 12.0+
- **Permissions**: Microphone usage description in Info.plist
- **App Delegate**: Swift-based FlutterAppDelegate

## Dependencies

### Production Dependencies
- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons
- `permission_handler`: Cross-platform permission handling
- `pitch_detector_dart`: Audio pitch detection (for future implementation)
- `flutter_mic`: Microphone access (for future implementation)

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Dart linting rules

## Future Enhancements

### Audio Processing
Currently, the app includes a placeholder for pitch detection. Future versions will implement:
1. Real-time audio capture from the device microphone
2. FFT (Fast Fourier Transform) for frequency analysis
3. Pitch detection algorithms to identify the fundamental frequency
4. Noise filtering and signal processing

### Potential Features
- Different tuning modes (Drop D, Open G, etc.)
- Chromatic tuner mode for all notes
- Visual waveform display
- Tuning history and accuracy tracking
- Support for other instruments (bass, ukulele, etc.)

## Testing

The app includes widget tests that verify:
- App initialization and UI rendering
- Presence of all guitar note displays
- Button functionality
- Initial state correctness

## Build and Run

### Prerequisites
- Flutter SDK 3.0 or higher
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)

### Commands
```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

## Performance Considerations

- The app uses periodic timers for simulated pitch detection
- Real implementation would use streams for audio data
- UI updates are throttled through setState to prevent excessive redraws
- Audio processing will run on a separate isolate in the future to prevent UI blocking
