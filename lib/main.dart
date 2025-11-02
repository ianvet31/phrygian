import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const GuitarTunerApp());
}

class GuitarTunerApp extends StatelessWidget {
  const GuitarTunerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guitar Tuner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TunerScreen(),
    );
  }
}

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  bool _isListening = false;
  String _currentNote = '--';
  double _frequency = 0.0;
  double _cents = 0.0;
  String _statusMessage = 'Tap to start';

  // Standard guitar tuning frequencies (Hz)
  final Map<String, double> _guitarNotes = {
    'E2': 82.41,  // Low E
    'A2': 110.00, // A
    'D3': 146.83, // D
    'G3': 196.00, // G
    'B3': 246.94, // B
    'E4': 329.63, // High E
  };

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    
    if (status.isGranted) {
      setState(() {
        _isListening = true;
        _statusMessage = 'Listening...';
      });
      
      // In a real implementation, you would use a pitch detection library here
      // For this basic version, we'll simulate the pitch detection
      _simulatePitchDetection();
    } else {
      setState(() {
        _statusMessage = 'Microphone permission denied';
      });
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _currentNote = '--';
      _frequency = 0.0;
      _cents = 0.0;
      _statusMessage = 'Tap to start';
    });
  }

  // Simulates pitch detection for demonstration purposes
  // In a real app, you would use actual audio input processing
  void _simulatePitchDetection() {
    // This is a placeholder - real implementation would use microphone input
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }
      
      // Simulate detecting different guitar strings
      // In reality, this would come from actual audio analysis
      setState(() {
        _statusMessage = 'Listening... (Demo mode - no real audio detection)';
      });
    });
  }

  String _findClosestNote(double frequency) {
    if (frequency < 60 || frequency > 400) return '--';
    
    String closestNote = '--';
    double minDiff = double.infinity;
    
    _guitarNotes.forEach((note, freq) {
      final diff = (frequency - freq).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestNote = note;
      }
    });
    
    return closestNote;
  }

  double _calculateCents(double frequency, double targetFrequency) {
    if (frequency <= 0 || targetFrequency <= 0) return 0.0;
    return 1200 * (log(frequency / targetFrequency) / log(2));
  }

  Color _getTuningColor() {
    if (_cents.abs() < 5) {
      return Colors.green;
    } else if (_cents.abs() < 15) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guitar Tuner'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Guitar strings display
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: _guitarNotes.entries.map((entry) {
                  final isActive = _currentNote == entry.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? _getTuningColor() : Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Stack(
                            children: [
                              if (isActive)
                                Align(
                                  alignment: Alignment(_cents / 50, 0),
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _getTuningColor(),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${entry.value.toStringAsFixed(2)} Hz',
                            style: TextStyle(
                              fontSize: 14,
                              color: isActive ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Current note display
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _isListening ? _getTuningColor().withOpacity(0.2) : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isListening ? _getTuningColor() : Colors.grey,
                  width: 4,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentNote,
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: _isListening ? _getTuningColor() : Colors.grey,
                      ),
                    ),
                    if (_frequency > 0)
                      Text(
                        '${_frequency.toStringAsFixed(2)} Hz',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    if (_cents != 0)
                      Text(
                        '${_cents > 0 ? '+' : ''}${_cents.toStringAsFixed(0)} cents',
                        style: TextStyle(
                          fontSize: 14,
                          color: _getTuningColor(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Status message
            Text(
              _statusMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Start/Stop button
            ElevatedButton(
              onPressed: _toggleListening,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                backgroundColor: _isListening ? Colors.red : Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _isListening ? 'Stop' : 'Start Tuner',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
