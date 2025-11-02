import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:math' as math;

import '../constants/app_colors.dart';
import '../models/tuning_model.dart';
import '../widgets/guitar_string_widget.dart';
import '../widgets/note_display_widget.dart';
import '../widgets/tuning_selector.dart';

/// Main tuner screen with all tuning functionality
class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> with TickerProviderStateMixin {
  bool _isListening = false;
  String _currentNote = '--';
  double _frequency = 0.0;
  double _cents = 0.0;
  String _statusMessage = 'Tap Start to begin tuning';
  TuningModel _currentTuning = TuningModel.standard;
  Timer? _detectionTimer;

  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _stopListening();
    _buttonAnimationController.dispose();
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
        _statusMessage = 'Listening for guitar strings...';
      });

      _buttonAnimationController.forward();

      // In a real implementation, you would use a pitch detection library here
      // For this demo version, we'll simulate the pitch detection
      _simulatePitchDetection();
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _statusMessage = 'Microphone permission denied. Please enable in settings.';
      });
      // Show dialog to open settings
      _showPermissionDialog();
    } else {
      setState(() {
        _statusMessage = 'Microphone permission required';
      });
    }
  }

  void _stopListening() {
    _detectionTimer?.cancel();
    _detectionTimer = null;
    
    if (mounted) {
      setState(() {
        _isListening = false;
        _currentNote = '--';
        _frequency = 0.0;
        _cents = 0.0;
        _statusMessage = 'Tap Start to begin tuning';
      });
      _buttonAnimationController.reverse();
    }
  }

  /// Simulates pitch detection for demonstration purposes
  /// In a real app, replace this with actual microphone input processing
  /// using libraries like pitch_detector_dart or flutter_audio_capture
  void _simulatePitchDetection() {
    final random = math.Random();
    var currentStringIndex = 0;
    var holdCounter = 0;

    _detectionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }

      // Simulate holding on a string for a few cycles
      if (holdCounter < 20) {
        holdCounter++;
        
        final notes = _currentTuning.notes.entries.toList();
        final targetNote = notes[currentStringIndex];
        
        // Simulate some frequency variation and tuning drift
        final targetFreq = targetNote.value;
        final variation = (random.nextDouble() - 0.5) * 3.0; // ±1.5 Hz
        final detectedFreq = targetFreq + variation;
        
        final closestNote = _findClosestNote(detectedFreq);
        final cents = _calculateCents(
          detectedFreq,
          _currentTuning.notes[closestNote]!,
        );

        setState(() {
          _currentNote = closestNote;
          _frequency = detectedFreq;
          _cents = cents;
          
          // Update status message based on tuning accuracy
          if (cents.abs() < 5) {
            _statusMessage = '✓ Perfect! In tune';
          } else if (cents.abs() < 15) {
            _statusMessage = cents > 0 ? 'Almost there - tune down' : 'Almost there - tune up';
          } else {
            _statusMessage = cents > 0 ? 'Too sharp - tune down' : 'Too flat - tune up';
          }
        });
      } else {
        // Move to next string
        holdCounter = 0;
        currentStringIndex = (currentStringIndex + 1) % _currentTuning.notes.length;
      }
    });
  }

  String _findClosestNote(double frequency) {
    if (frequency < 60 || frequency > 450) return '--';

    String closestNote = '--';
    double minDiff = double.infinity;

    _currentTuning.notes.forEach((note, freq) {
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
    return 1200 * (math.log(frequency / targetFrequency) / math.log(2));
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Microphone Permission Required',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This app needs microphone access to detect guitar string frequencies. '
          'Please enable microphone permission in your device settings.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _changeTuning(TuningModel newTuning) {
    setState(() {
      _currentTuning = newTuning;
      if (_isListening) {
        _currentNote = '--';
        _frequency = 0.0;
        _cents = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Phrygian Tuner',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textPrimary),
            onPressed: () {
              TuningSelector.show(
                context,
                currentTuning: _currentTuning,
                onTuningSelected: _changeTuning,
              );
            },
            tooltip: 'Select Tuning',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tuning mode indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: AppColors.surface,
              child: Column(
                children: [
                  Text(
                    _currentTuning.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    _currentTuning.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Guitar strings display
                    ..._currentTuning.notes.entries.map((entry) {
                      final isActive = _currentNote == entry.key && _isListening;
                      return GuitarStringWidget(
                        noteName: entry.key,
                        targetFrequency: entry.value,
                        isActive: isActive,
                        cents: isActive ? _cents : 0.0,
                      );
                    }),

                    const SizedBox(height: 40),

                    // Current note display
                    NoteDisplayWidget(
                      note: _currentNote,
                      frequency: _frequency,
                      cents: _cents,
                      isActive: _isListening,
                    ),

                    const SizedBox(height: 30),

                    // Status message
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Start/Stop button
                    AnimatedBuilder(
                      animation: _buttonAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_buttonAnimationController.value * 0.05),
                          child: ElevatedButton(
                            onPressed: _toggleListening,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 20,
                              ),
                              backgroundColor: _isListening
                                  ? AppColors.outOfTune
                                  : AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                              shadowColor: _isListening
                                  ? AppColors.outOfTune.withOpacity(0.5)
                                  : AppColors.primary.withOpacity(0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isListening ? Icons.stop : Icons.play_arrow,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _isListening ? 'Stop' : 'Start Tuning',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Demo mode notice
                    if (_isListening)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.accent,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Demo mode: Simulated pitch detection',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
