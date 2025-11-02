# Quick Start Guide 🚀

## Run the App Immediately

```bash
# Make sure you're in the project directory
cd c:\Users\Ian\OneDrive\Desktop\phrygian

# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run
```

## What to Expect

When you run the app, you'll see:

1. **Dark theme** with professional blue/orange color scheme
2. **"Phrygian Tuner"** title at the top
3. **Standard tuning** displayed (E A D G B E)
4. **Gear icon** in top-right to change tuning modes
5. **Six string indicators** showing target frequencies
6. **Large circular display** in the center (shows "--" initially)
7. **"Start Tuning" button** at the bottom

## Try It Out

1. **Tap "Start Tuning"**
   - App will request microphone permission
   - Grant permission
   - Button changes to red "Stop"
   - Status changes to "Listening..."

2. **Watch the Demo**
   - In demo mode, strings will simulate tuning
   - You'll see colors change (red → orange → green)
   - Position dots slide on the string indicators
   - Central circle shows detected note
   - Frequency and cents are displayed

3. **Try Different Tunings**
   - Tap the gear icon (⚙️)
   - Select different tuning modes:
     - Standard (E A D G B E)
     - Drop D (D A D G B E)
     - Half Step Down
     - Open G
     - DADGAD
   - Watch string labels update

4. **Tap "Stop"** to deactivate

## Testing on Real Device

### Android
```bash
# Connect Android device via USB with USB debugging enabled
# OR start Android emulator
flutter run -d android
```

### iOS
```bash
# Connect iPhone/iPad via USB
# OR start iOS simulator
flutter run -d ios
```

## Build Release Version

### Android APK
```bash
flutter build apk --release
# APK will be in: build/app/outputs/flutter-apk/app-release.apk
```

### iOS
```bash
flutter build ios --release
# Then open in Xcode to archive and distribute
```

## Common Commands

```bash
# Check for issues
flutter analyze

# Run tests
flutter test

# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Check Flutter setup
flutter doctor
```

## Demo Mode Notice

⚠️ **Important**: The app currently runs in DEMO MODE
- Simulates pitch detection for UI testing
- Cycles through strings automatically
- Real microphone input not yet implemented

To make it functional, you'll need to integrate:
- Audio capture library
- FFT (Fast Fourier Transform)
- Pitch detection algorithm

See `IMPROVEMENTS.md` for details on implementation.

## Quick Customization

### Change Colors
Edit `lib/constants/app_colors.dart`:
```dart
static const Color primary = Color(0xFF1E88E5); // Change this!
static const Color accent = Color(0xFFFF6F00);  // And this!
```

### Add New Tuning
Edit `lib/models/tuning_model.dart`:
```dart
static const TuningModel myCustomTuning = TuningModel(
  name: 'My Tuning',
  description: 'Custom notes',
  notes: {
    'C2': 65.41,
    // ... add your notes
  },
);
```

### Adjust Tuning Tolerance
Edit `lib/constants/app_colors.dart`:
```dart
// Current: <5 cents = green, <15 = orange
// Change these values:
if (absCents < 5) return inTune;      // Make stricter: < 3
else if (absCents < 15) return close; // Make stricter: < 10
```

## Troubleshooting

### "No devices found"
```bash
# Check connected devices
flutter devices

# Start emulator
flutter emulators --launch <emulator_id>
```

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

### Permission issues (iOS)
- Check `ios/Runner/Info.plist` for microphone permission
- Ensure provisioning profile is set up

### Permission issues (Android)
- Check `android/app/src/main/AndroidManifest.xml`
- Ensure microphone permission is declared

## Next Steps

1. ✅ Run the app and explore the UI
2. ✅ Try different tuning modes
3. ✅ Read `IMPROVEMENTS.md` for what's been enhanced
4. 📖 Read `README.md` for full documentation
5. 🔧 Check `ARCHITECTURE.md` for code structure
6. 🎸 Integrate real audio processing (see suggestions in IMPROVEMENTS.md)

---

**Enjoy your beautiful new guitar tuner app!** 🎸✨
