# Phrygian - Guitar Tuner App

A basic guitar tuner app built with Flutter that runs on iOS and Android.

## Features

- **Standard Guitar Tuning**: Supports all 6 strings (E, A, D, G, B, E)
- **Visual Feedback**: 
  - Color-coded tuning indicators (green = in tune, orange = close, red = off)
  - Real-time frequency display
  - Cents deviation from target note
- **Cross-Platform**: Works on both iOS and Android devices
- **Microphone Permission**: Requests and handles microphone permissions appropriately

## Guitar String Frequencies

- **E2** (Low E): 82.41 Hz
- **A2**: 110.00 Hz
- **D3**: 146.83 Hz
- **G3**: 196.00 Hz
- **B3**: 246.94 Hz
- **E4** (High E): 329.63 Hz

## Setup

1. Make sure you have Flutter installed (Flutter 3.0+ required)
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run the app:
   - For Android: `flutter run -d android`
   - For iOS: `flutter run -d ios`

## Dependencies

- `flutter`: Core Flutter framework
- `permission_handler`: Handle microphone permissions on iOS and Android
- `pitch_detector_dart`: Pitch detection library (for future real audio implementation)
- `flutter_mic`: Microphone access (for future real audio implementation)

## Usage

1. Launch the app
2. Tap the "Start Tuner" button
3. Grant microphone permission when prompted
4. Play a guitar string
5. The app will display:
   - The detected note
   - Current frequency
   - How many cents sharp or flat you are
   - Visual indicator showing tuning accuracy

## Note

The current implementation includes a demo mode placeholder. For production use, the pitch detection functionality would need to be fully implemented using the microphone input and audio processing libraries.

## Permissions

### Android
The app requires the `RECORD_AUDIO` permission which is declared in `AndroidManifest.xml`.

### iOS
The app requires microphone access with usage description in `Info.plist`.

## License

MIT