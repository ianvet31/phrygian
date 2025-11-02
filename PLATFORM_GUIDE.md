# Phrygian Guitar Tuner - Platform Guide

## 🎸 Overview
Phrygian is a cross-platform guitar tuner app that uses real-time pitch detection to help you tune your guitar accurately.

## 📱 Platform Support

### ✅ Web (Chrome, Edge, Firefox, Safari)
**Status:** Fully working and tested ✓

**Requirements:**
- Modern web browser with Web Audio API support
- Microphone access permission

**Running:**
```bash
flutter run -d chrome
# or
flutter run -d edge
```

**Features:**
- Automatic sample rate detection (typically 48000 Hz on Windows, 44100 Hz on Mac)
- Real-time pitch detection using Web Audio API
- No installation required

---

### ✅ Android
**Status:** Ready for testing on real device

**Requirements:**
- Android device with microphone
- Android 5.0 (API 21) or higher
- Microphone permission

**Running on emulator:**
```bash
flutter run
```
*Note: Android emulator has known audio input gain issues. Use a real device for accurate testing.*

**Running on real device:**
1. Enable USB debugging on your Android device
2. Connect via USB
3. Run: `flutter run`

**Features:**
- Uses flutter_sound with PCM16 codec
- Sample rate: 44100 Hz
- Same pitch detection algorithm as web

---

### ✅ iOS
**Status:** Ready for deployment (requires Mac + Xcode)

**Requirements:**
- Mac with Xcode installed
- iOS device with microphone
- iOS 11.0 or higher
- Microphone permission

**Running:**
1. Open project in Xcode: `open ios/Runner.xcworkspace`
2. Select your device
3. Build and run

Or from command line:
```bash
flutter run -d <device-id>
```

**Features:**
- Uses flutter_sound with PCM16 codec
- Sample rate: 44100 Hz
- Optimized for iOS microphone input

---

## 🎵 Supported Tunings
- **Standard** (E A D G B E)
- **Drop D** (D A D G B E)
- **Half Step Down** (D# G# C# F# A# D#)
- **Open G** (D G D G B D)
- **DADGAD** (D A D G A D)

## 🔧 Technical Details

### Pitch Detection Algorithm
- **Method:** Autocorrelation
- **Buffer Size:** 4096 samples (~93ms at 44.1kHz, ~85ms at 48kHz)
- **Frequency Range:** 60 Hz - 1500 Hz
- **Accuracy:** ±1 cent (0.01 semitones)

### Sample Rates by Platform
| Platform | Sample Rate | Set By |
|----------|-------------|---------|
| Web | 44100 Hz or 48000 Hz | System default (auto-detected) |
| Android | 44100 Hz | flutter_sound |
| iOS | 44100 Hz | flutter_sound |

### Audio Processing Flow
1. **Input:** Microphone captures audio
2. **Conversion:** Audio converted to PCM16 or Float32 samples
3. **Buffering:** Samples buffered to 4096 sample window
4. **Detection:** Autocorrelation finds dominant frequency
5. **Conversion:** Frequency mapped to musical note + cents offset
6. **Display:** Real-time visual feedback with color coding

---

## 🐛 Known Issues & Solutions

### Android Emulator
**Issue:** Very low audio input gain  
**Solution:** Use a real Android device for accurate pitch detection

### iOS Testing Without Mac
**Issue:** Cannot build iOS apps on Windows  
**Solution:** Use the web version or test on Android

### Microphone Permission Denied
**Issue:** App cannot access microphone  
**Solution:**
- **Web:** Click "Allow" when browser asks for permission
- **Android:** Grant permission in Settings > Apps > Phrygian > Permissions
- **iOS:** Grant permission in Settings > Privacy > Microphone

---

## 📊 Performance Tips

1. **Best Environment:** Quiet room with minimal background noise
2. **Microphone Position:** 6-12 inches from guitar
3. **Playing Technique:** Pluck string cleanly, let it ring
4. **Volume:** Medium volume works best (not too quiet, not too loud)

---

## 🚀 Building for Release

### Web
```bash
flutter build web --release
```
Deploy the `build/web` folder to any static hosting service.

### Android APK
```bash
flutter build apk --release
```
Find the APK in `build/app/outputs/flutter-apk/app-release.apk`

### iOS (requires Mac)
```bash
flutter build ios --release
```
Then archive and distribute via Xcode.

---

## 📝 License
Copyright © 2025 - Guitar Tuner App
