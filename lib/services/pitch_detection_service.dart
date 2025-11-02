import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/pitch_result.dart';

// Conditional imports for web
import 'dart:html' as html;
import 'dart:js_util' as js_util;

/// Service for real-time pitch detection using autocorrelation
/// Works on Android, iOS, and Web
class PitchDetectionService {
  FlutterSoundRecorder? _recorder;
  final StreamController<PitchResult> _pitchController = StreamController<PitchResult>.broadcast();
  
  StreamSubscription? _recorderSubscription;
  Timer? _webAudioTimer; // For web audio processing
  dynamic _webAudioContext; // Web AudioContext
  dynamic _webMediaStream; // Web MediaStream
  dynamic _webScriptProcessor; // Web ScriptProcessorNode
  bool _isListening = false;
  List<double> _audioBuffer = [];
  
  // Audio configuration
  static const int defaultSampleRate = 44100;
  int _actualSampleRate = defaultSampleRate; // Will be updated with actual web audio sample rate
  static const int bufferSize = 4096; // ~93ms of audio
  static const double minFrequency = 60.0;  // Low E2 is ~82 Hz
  static const double maxFrequency = 1500.0; // Well above high E4
  
  Stream<PitchResult> get pitchStream => _pitchController.stream;
  bool get isListening => _isListening;
  
  /// Start listening to microphone and detecting pitch
  Future<void> startListening() async {
    if (_isListening) return;
    
    print('🎤 Requesting microphone permission...');
    
    // For web, use Web Audio API for real microphone input
    if (kIsWeb) {
      print('🌐 Running on web - using Web Audio API');
      await _startWebAudio();
      return;
    }
    
    // Request microphone permission (mobile)
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      print('❌ Microphone permission denied');
      throw Exception('Microphone permission denied');
    }
    
    print('✅ Microphone permission granted');
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    
    _isListening = true;
    _audioBuffer.clear();
    
    // Mobile uses the default sample rate (44100 Hz)
    _actualSampleRate = defaultSampleRate;
    
    try {
      // Create a stream controller for the recorder
      final streamController = StreamController<Uint8List>();
      
      // Start recording with streaming
      print('🎵 Starting audio recording at $_actualSampleRate Hz...');
      await _recorder!.startRecorder(
        toStream: streamController.sink,
        codec: Codec.pcm16,
        sampleRate: defaultSampleRate,
        numChannels: 1,
      );
      
      // Store subscription
      _recorderSubscription = streamController.stream.listen(
        (data) {
          _onAudioData(data);
        },
        onError: _onError,
        onDone: () {
          print('🔇 Audio stream ended');
        },
      );
      print('✅ Audio recording started successfully');
    } catch (e) {
      print('❌ Error starting audio recording: $e');
      _isListening = false;
      rethrow;
    }
  }
  
  /// Stop listening
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    print('🛑 Stopping audio stream...');
    _isListening = false;
    
    // Stop web audio if running
    if (kIsWeb) {
      _webAudioTimer?.cancel();
      _webAudioTimer = null;
      
      // Stop and cleanup Web Audio API objects
      if (_webScriptProcessor != null) {
        js_util.callMethod(_webScriptProcessor, 'disconnect', []);
        _webScriptProcessor = null;
      }
      if (_webMediaStream != null) {
        final tracks = js_util.callMethod(_webMediaStream, 'getTracks', []);
        for (var track in tracks) {
          js_util.callMethod(track, 'stop', []);
        }
        _webMediaStream = null;
      }
      if (_webAudioContext != null) {
        js_util.callMethod(_webAudioContext, 'close', []);
        _webAudioContext = null;
      }
      
      print('✅ Web audio stopped');
      return;
    }
    
    await _recorderSubscription?.cancel();
    _recorderSubscription = null;
    
    await _recorder?.stopRecorder();
    await _recorder?.closeRecorder();
    _recorder = null;
    
    _audioBuffer.clear();
  }
  
  /// Start Web Audio API for web platform
  Future<void> _startWebAudio() async {
    try {
      // Request microphone access
      final mediaDevices = js_util.getProperty(html.window.navigator, 'mediaDevices');
      final constraints = js_util.jsify({'audio': true});
      final streamPromise = js_util.callMethod(mediaDevices, 'getUserMedia', [constraints]);
      
      // Convert JS Promise to Dart Future
      _webMediaStream = await js_util.promiseToFuture(streamPromise);
      print('✅ Microphone access granted');
      
      // Create AudioContext
      final audioContextConstructor = js_util.getProperty(html.window, 'AudioContext');
      _webAudioContext = js_util.callConstructor(audioContextConstructor, []);
      
      // Get the actual sample rate from the AudioContext
      _actualSampleRate = (js_util.getProperty(_webAudioContext, 'sampleRate') as num).toInt();
      
      // Validate sample rate
      if (_actualSampleRate < 8000 || _actualSampleRate > 192000) {
        throw Exception('Invalid sample rate: $_actualSampleRate Hz');
      }
      
      print('✅ AudioContext created with sample rate: $_actualSampleRate Hz');
      
      // Create MediaStreamSource
      final source = js_util.callMethod(_webAudioContext, 'createMediaStreamSource', [_webMediaStream]);
      
      // Create ScriptProcessorNode (4096 buffer, 1 input channel, 1 output channel)
      _webScriptProcessor = js_util.callMethod(_webAudioContext, 'createScriptProcessor', [4096, 1, 1]);
      
      // Set up audio processing callback - MUST use allowInterop for Dart->JS callbacks
      final callback = js_util.allowInterop((event) {
        if (!_isListening) return;
        
        try {
          // Get input buffer
          final inputBuffer = js_util.getProperty(event, 'inputBuffer');
          final channelData = js_util.callMethod(inputBuffer, 'getChannelData', [0]);
          
          // Convert Float32Array to List<double>
          final length = js_util.getProperty(channelData, 'length') as int;
          final samples = List<double>.generate(length, (i) {
            return (js_util.getProperty(channelData, i) as num).toDouble();
          });
          
          // Process audio data
          _onWebAudioData(samples);
        } catch (e) {
          print('⚠️ Error processing web audio frame: $e');
        }
      });
      
      js_util.setProperty(_webScriptProcessor, 'onaudioprocess', callback);
      
      // Connect the nodes: source -> scriptProcessor -> destination
      js_util.callMethod(source, 'connect', [_webScriptProcessor]);
      js_util.callMethod(_webScriptProcessor, 'connect', [js_util.getProperty(_webAudioContext, 'destination')]);
      
      _isListening = true;
      _audioBuffer.clear();
      print('✅ Web audio started - listening for input');
      
    } catch (e) {
      print('❌ Error starting web audio: $e');
      _isListening = false;
      rethrow;
    }
  }
  
  /// Process web audio data
  void _onWebAudioData(List<double> samples) {
    // Add samples to buffer
    _audioBuffer.addAll(samples);
    
    // Process when we have enough samples
    if (_audioBuffer.length >= bufferSize) {
      final bufferCopy = List<double>.from(_audioBuffer.take(bufferSize));
      _audioBuffer.removeRange(0, bufferSize);
      
      final result = _detectPitch(bufferCopy);
      if (result != null && !_pitchController.isClosed) {
        _pitchController.add(result);
      }
    }
  }
  
  /// Called when audio data is received
  void _onAudioData(Uint8List data) {
    if (!_isListening) return;
    
    print('📊 Received ${data.length} bytes of audio data');
    
    // Convert PCM16 bytes to samples
    final samples = _bytesToSamples(data);
    _audioBuffer.addAll(samples);
    
    // Process when we have enough samples
    if (_audioBuffer.length >= bufferSize) {
      print('🔍 Processing buffer of ${_audioBuffer.length} samples');
      final result = _detectPitch(_audioBuffer.sublist(0, bufferSize));
      if (result != null) {
        print('🎵 Detected: ${result.note} at ${result.frequency.toStringAsFixed(2)} Hz, ${result.cents.toStringAsFixed(1)} cents');
        if (!_pitchController.isClosed) {
          _pitchController.add(result);
        }
      } else {
        print('⚠️ No pitch detected in this buffer');
      }
      
      // Keep last 25% of buffer for overlap
      _audioBuffer = _audioBuffer.sublist(bufferSize - (bufferSize ~/ 4));
    }
  }
  
  /// Called on audio error
  void _onError(Object error) {
    print('❌ Audio streaming error: $error');
  }
  
  /// Convert PCM16 bytes to normalized samples (-1.0 to 1.0)
  List<double> _bytesToSamples(Uint8List bytes) {
    final samples = <double>[];
    // PCM16 is 2 bytes per sample
    for (int i = 0; i < bytes.length - 1; i += 2) {
      // Combine two bytes into a 16-bit signed integer
      final int sample = bytes[i] | (bytes[i + 1] << 8);
      // Convert to signed if needed
      final int signedSample = sample > 32767 ? sample - 65536 : sample;
      // Normalize to -1.0 to 1.0
      samples.add(signedSample / 32768.0);
    }
    return samples;
  }
  
  /// Detect pitch using autocorrelation algorithm
  PitchResult? _detectPitch(List<double> samples) {
    // Validate input
    if (samples.length < bufferSize) {
      print('⚠️ Insufficient samples: ${samples.length} < $bufferSize');
      return null;
    }
    
    // Calculate RMS (volume) to filter out silence
    double sumSquares = 0;
    for (final sample in samples) {
      sumSquares += sample * sample;
    }
    final rms = math.sqrt(sumSquares / samples.length);
    
    // If audio too quiet, skip detection
    if (rms < 0.001) {  // Lowered threshold for web audio
      return null;
    }
    
    // Autocorrelation
    final int minPeriod = (_actualSampleRate / maxFrequency).round();
    final int maxPeriod = (_actualSampleRate / minFrequency).round();
    
    // Validate period range
    if (minPeriod <= 0 || maxPeriod <= minPeriod) {
      print('❌ Invalid period range: $minPeriod to $maxPeriod (sample rate: $_actualSampleRate Hz)');
      return null;
    }
    
    double maxCorrelation = 0;
    int bestPeriod = 0;
    
    for (int lag = minPeriod; lag < maxPeriod && lag < samples.length ~/ 2; lag++) {
      double correlation = 0;
      for (int i = 0; i < samples.length - lag; i++) {
        correlation += samples[i] * samples[i + lag];
      }
      
      if (correlation > maxCorrelation) {
        maxCorrelation = correlation;
        bestPeriod = lag;
      }
    }
    
    // Check if we found a strong enough correlation
    if (maxCorrelation < 0.01 || bestPeriod == 0) {
      return null;
    }
    
    // Calculate frequency
    final frequency = _actualSampleRate / bestPeriod;
    
    // Filter out unrealistic frequencies
    if (frequency < minFrequency || frequency > maxFrequency) {
      return null;
    }
    
    return _frequencyToNote(frequency);
  }
  
  /// Convert frequency to musical note
  PitchResult _frequencyToNote(double frequency) {
    // A4 = 440 Hz is note number 69
    final noteNumber = 12 * (math.log(frequency / 440.0) / math.ln2) + 69;
    final roundedNote = noteNumber.round();
    
    // Calculate cents (difference from exact note)
    final cents = ((noteNumber - roundedNote) * 100).toDouble();
    
    // Note names
    const noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final noteName = noteNames[roundedNote % 12];
    final octave = (roundedNote ~/ 12) - 1;
    
    return PitchResult(
      note: '$noteName$octave',
      frequency: frequency,
      cents: cents,
      timestamp: DateTime.now(),
    );
  }
  
  /// Clean up resources
  Future<void> dispose() async {
    if (!_pitchController.isClosed) {
      await stopListening();
      await _pitchController.close();
    }
  }
}
