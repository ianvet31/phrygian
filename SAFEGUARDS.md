# Code Safeguards & Error Handling

## Overview
This document outlines the safeguards and error handling mechanisms implemented in the Phrygian guitar tuner app to ensure robust operation across all platforms.

---

## 🛡️ Platform Detection

### Web vs Mobile
```dart
if (kIsWeb) {
  // Use Web Audio API
  await _startWebAudio();
} else {
  // Use flutter_sound for Android/iOS
  _recorder = FlutterSoundRecorder();
  _actualSampleRate = defaultSampleRate; // Explicitly set to 44100 Hz
}
```

**Safeguard:** Platform-specific audio initialization ensures correct API usage.

---

## 🎤 Sample Rate Validation

### Web Audio Context
```dart
_actualSampleRate = (js_util.getProperty(_webAudioContext, 'sampleRate') as num).toInt();

// Validate sample rate
if (_actualSampleRate < 8000 || _actualSampleRate > 192000) {
  throw Exception('Invalid sample rate: $_actualSampleRate Hz');
}
```

**Safeguards:**
- ✓ Validates sample rate is within reasonable audio range (8-192 kHz)
- ✓ Prevents calculations with invalid/corrupt sample rates
- ✓ Throws clear error message for debugging

### Mobile
```dart
_actualSampleRate = defaultSampleRate; // 44100 Hz
await _recorder!.startRecorder(
  sampleRate: defaultSampleRate,
  // ...
);
```

**Safeguards:**
- ✓ Explicitly sets `_actualSampleRate` to match flutter_sound configuration
- ✓ Ensures pitch calculations use correct sample rate on mobile

---

## 🎵 Audio Processing Safeguards

### Input Validation
```dart
// Validate input buffer size
if (samples.length < bufferSize) {
  print('⚠️ Insufficient samples: ${samples.length} < $bufferSize');
  return null;
}
```

**Safeguard:** Prevents processing incomplete audio buffers.

### RMS Volume Check
```dart
final rms = math.sqrt(sumSquares / samples.length);

// If audio too quiet, skip detection
if (rms < 0.001) {
  return null;
}
```

**Safeguards:**
- ✓ Filters out silence/background noise
- ✓ Prevents false detections from noise floor
- ✓ Threshold lowered for web (0.001 vs 0.01) due to different input characteristics

### Period Range Validation
```dart
final int minPeriod = (_actualSampleRate / maxFrequency).round();
final int maxPeriod = (_actualSampleRate / minFrequency).round();

// Validate period range
if (minPeriod <= 0 || maxPeriod <= minPeriod) {
  print('❌ Invalid period range: $minPeriod to $maxPeriod');
  return null;
}
```

**Safeguards:**
- ✓ Ensures autocorrelation has valid search range
- ✓ Prevents divide-by-zero errors
- ✓ Catches corrupt sample rate issues early

### Correlation Strength Check
```dart
if (maxCorrelation < 0.01 || bestPeriod == 0) {
  return null;
}
```

**Safeguards:**
- ✓ Filters out weak/ambiguous pitch detections
- ✓ Prevents displaying unstable frequency readings
- ✓ Ensures only confident detections are shown

### Frequency Range Validation
```dart
final frequency = _actualSampleRate / bestPeriod;

// Filter out unrealistic frequencies
if (frequency < minFrequency || frequency > maxFrequency) {
  return null;
}
```

**Safeguards:**
- ✓ Rejects frequencies outside guitar range (60-1500 Hz)
- ✓ Prevents displaying nonsensical notes
- ✓ Catches calculation errors

---

## 🌐 Web Audio Error Handling

### Frame Processing
```dart
final callback = js_util.allowInterop((event) {
  if (!_isListening) return;
  
  try {
    // Get input buffer and convert samples
    // ...
    _onWebAudioData(samples);
  } catch (e) {
    print('⚠️ Error processing web audio frame: $e');
  }
});
```

**Safeguards:**
- ✓ Wraps audio frame processing in try-catch
- ✓ Prevents single frame errors from crashing the app
- ✓ Logs errors for debugging
- ✓ Continues processing subsequent frames

### Resource Cleanup
```dart
Future<void> stopListening() async {
  if (!_isListening) return;
  _isListening = false;
  
  // Stop web audio if running
  if (kIsWeb) {
    _webAudioTimer?.cancel();
    if (_webScriptProcessor != null) {
      js_util.callMethod(_webScriptProcessor, 'disconnect', []);
    }
    if (_webMediaStream != null) {
      final tracks = js_util.callMethod(_webMediaStream, 'getTracks', []);
      for (var track in tracks) {
        js_util.callMethod(track, 'stop', []);
      }
    }
    if (_webAudioContext != null) {
      js_util.callMethod(_webAudioContext, 'close', []);
    }
  }
}
```

**Safeguards:**
- ✓ Properly disconnects Web Audio nodes
- ✓ Stops all media stream tracks
- ✓ Closes AudioContext to free resources
- ✓ Prevents memory leaks
- ✓ Null checks before cleanup operations

---

## 📱 Mobile Audio Error Handling

### Permission Handling
```dart
final status = await Permission.microphone.request();
if (!status.isGranted) {
  print('❌ Microphone permission denied');
  throw Exception('Microphone permission denied');
}
```

**Safeguards:**
- ✓ Explicit permission request
- ✓ Clear error message if denied
- ✓ Prevents attempting to record without permission

### Stream Error Handling
```dart
_recorderSubscription = streamController.stream.listen(
  (data) {
    _onAudioData(data);
  },
  onError: _onError,
  onDone: () {
    print('🔇 Audio stream ended');
  },
);
```

**Safeguards:**
- ✓ onError callback catches stream errors
- ✓ onDone callback handles stream completion
- ✓ Prevents unhandled stream exceptions

### PCM16 Conversion Safety
```dart
List<double> _bytesToSamples(Uint8List bytes) {
  final samples = <double>[];
  for (int i = 0; i < bytes.length - 1; i += 2) {
    final signedSample = bytes[i] | (bytes[i + 1] << 8);
    final correctedSample = signedSample > 32767 
        ? signedSample - 65536 
        : signedSample;
    samples.add(correctedSample / 32768.0);
  }
  return samples;
}
```

**Safeguards:**
- ✓ Proper signed 16-bit integer handling
- ✓ Two's complement conversion for negative values
- ✓ Normalization to -1.0 to 1.0 range
- ✓ Prevents out-of-bounds array access

---

## 🎯 Summary

### Critical Safeguards
1. **Platform Detection** - Correct API for each platform
2. **Sample Rate Validation** - Ensures accurate frequency calculations
3. **Input Validation** - Filters invalid/insufficient data
4. **Error Isolation** - Prevents single errors from crashing app
5. **Resource Cleanup** - Prevents memory leaks
6. **Permission Handling** - Clear user feedback

### Error Recovery Strategy
- **Silent failures** for individual frames (logs warning, continues)
- **Throws exceptions** for critical errors (permission denied, invalid config)
- **Returns null** for weak/invalid detections (UI shows "listening...")

### Testing Recommendations
1. Test microphone permission denial on all platforms
2. Test with very quiet input (background noise)
3. Test with very loud input (distortion)
4. Test resource cleanup (start/stop repeatedly)
5. Test sample rate detection on different systems

---

## 📊 Error Categories

| Category | Handling | User Impact |
|----------|----------|-------------|
| No microphone permission | Exception + UI message | Cannot use app |
| Audio too quiet | Return null | Shows "listening..." |
| Invalid frequency | Return null | Shows "listening..." |
| Weak correlation | Return null | Shows "listening..." |
| Web audio frame error | Log + continue | Single frame skipped |
| Invalid sample rate | Exception + log | App won't start |

