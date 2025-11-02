# Phrygian - Guitar Tuner App 🎸

A beautiful, modern guitar tuner app built with Flutter that runs on both iOS and Android. Features a sleek dark theme with smooth animations and multiple tuning modes.

## ✨ Features

### **Multiple Tuning Modes**
- **Standard Tuning** (E A D G B E)
- **Drop D** (D A D G B E)
- **Half Step Down** (E♭ A♭ D♭ G♭ B♭ E♭)
- **Open G** (D G D G B D)
- **DADGAD** (D A D G A D)

### **Beautiful UI**
- 🌙 **Dark Theme**: Modern, eye-friendly dark interface
- 🎨 **Color-Coded Feedback**: 
  - 🟢 Green = Perfect (within ±5 cents)
  - 🟠 Orange = Close (within ±15 cents)
  - 🔴 Red = Out of tune (>15 cents)
- ✨ **Smooth Animations**: Pulsing in-tune indicator and fluid transitions
- 📊 **Visual Tuning Indicators**: Sliding dot shows exactly how sharp or flat each string is

### **User-Friendly Design**
- 📱 **Cross-Platform**: Works seamlessly on iOS and Android
- 🎯 **Real-Time Feedback**: Instant visual and numerical tuning feedback
- 📏 **Precision Display**: Shows frequency in Hz and deviation in cents
- 🎛️ **Easy Tuning Selection**: Quick access to different tuning modes

### **Technical Features**
- 🎤 **Microphone Permissions**: Proper handling with settings redirect
- 🎵 **Accurate Pitch Detection**: Prepared for real audio processing integration
- ⚡ **Performance**: Optimized with Material 3 design
- 🏗️ **Clean Architecture**: Well-organized code structure

## 🎯 How to Use

1. **Launch the app** on your iOS or Android device
2. **Grant microphone permission** when prompted
3. **Tap the gear icon** to select your desired tuning (Standard, Drop D, etc.)
4. **Tap "Start Tuning"** to activate the tuner
5. **Play a guitar string** near your device
6. **Watch the display**:
   - The large circle shows the detected note
   - Frequency is displayed in Hz
   - Cents show how far sharp (+) or flat (-) you are
   - String indicators light up and show tuning position
7. **Tune your guitar** based on the visual feedback
8. **Tap "Stop"** when finished

### Reading the Display

- **Central Circle**: Shows current note and tuning status
- **String Indicators**: Each string has a slider showing tuning position
  - Dot on left = too flat (tune up)
  - Dot in center = perfect tune
  - Dot on right = too sharp (tune down)
- **Status Messages**: Helpful hints like "tune up" or "tune down"

## 📂 Project Structure

```
lib/
├── constants/
│   └── app_colors.dart          # Color scheme and theme colors
├── models/
│   ├── tuning_model.dart        # Tuning configurations (Standard, Drop D, etc.)
│   └── pitch_result.dart        # Pitch detection result data structure
├── widgets/
│   ├── guitar_string_widget.dart    # Individual string display with tuning indicator
│   ├── note_display_widget.dart     # Large circular note display
│   └── tuning_selector.dart         # Bottom sheet for selecting tunings
├── screens/
│   └── tuner_screen.dart        # Main tuner screen
└── main.dart                    # App entry point and theme configuration
```

## 🚀 Setup

### Prerequisites
- Flutter SDK 3.0+ installed
- iOS development: Xcode and CocoaPods
- Android development: Android Studio and SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ianvet31/phrygian.git
   cd phrygian
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   For Android:
   ```bash
   flutter run -d android
   ```
   
   For iOS:
   ```bash
   flutter run -d ios
   ```

4. **Build release version**
   
   For Android:
   ```bash
   flutter build apk --release
   ```
   
   For iOS:
   ```bash
   flutter build ios --release
   ```

## 📦 Dependencies

- **flutter**: Core Flutter framework
- **permission_handler**: ^11.0.0 - Handle microphone permissions on iOS and Android

### Future Audio Processing (Reserved)
For production use with real audio input, consider these packages:
- **pitch_detector_dart**: ^1.0.0 - Pitch detection library
- **flutter_audio_capture**: Audio capture from microphone
- **fft**: Fast Fourier Transform for frequency analysis

## 🎨 Design Features

### Color Scheme
- **Primary Blue**: #1E88E5 - Main brand color
- **Accent Orange**: #FF6F00 - Highlights and accents
- **Dark Background**: #121212 - Main background
- **Surface**: #1E1E1E - Card and component backgrounds
- **Success Green**: #4CAF50 - In tune indicator
- **Warning Orange**: #FF9800 - Close to tune
- **Error Red**: #F44336 - Out of tune

### Animations
- Pulsing effect when string is perfectly in tune
- Smooth transitions between tuning states
- Animated position indicators
- Button scale animations on press

## 🔧 Development Notes

### Current Implementation
The app currently includes a **demo mode** that simulates pitch detection by cycling through guitar strings with random frequency variations. This allows testing the UI and user experience without real audio input.

### Production Implementation
To make this a fully functional tuner, you'll need to:

1. **Add audio capture** - Use `flutter_audio_capture` or similar
2. **Implement FFT** - Process audio samples to detect frequencies  
3. **Add pitch detection algorithm** - Convert frequencies to musical notes
4. **Optimize performance** - Handle real-time audio processing efficiently
5. **Add calibration** - Allow users to adjust A4 reference frequency (default 440Hz)

### Example Integration
```dart
// Replace _simulatePitchDetection() with real implementation:
void _startRealPitchDetection() {
  // 1. Capture audio from microphone
  // 2. Apply FFT to get frequency spectrum
  // 3. Detect fundamental frequency
  // 4. Match to closest note in current tuning
  // 5. Calculate cents deviation
  // 6. Update UI with setState()
}
```

## 📱 Permissions

### Android
The app requires the `RECORD_AUDIO` permission, declared in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

### iOS
Microphone access with usage description in `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to the microphone to detect guitar string frequencies for tuning.</string>
```

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

## 📄 License

MIT License - See LICENSE file for details

## 👨‍💻 Author

Ian Vet - [@ianvet31](https://github.com/ianvet31)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Music theory resources for accurate frequency calculations
- Guitar players everywhere for inspiration

---

**Note**: This app is currently in demo mode. Real pitch detection will be implemented in future updates.