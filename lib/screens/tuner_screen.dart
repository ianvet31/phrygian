import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import '../constants/app_colors.dart';
import '../models/tuning_model.dart';
import '../models/pitch_result.dart';
import '../services/pitch_detection_service.dart';
import '../widgets/guitar_string_widget.dart';
import '../widgets/note_display_widget.dart';
import '../widgets/tuning_selector.dart';
import '../widgets/note_selector.dart';

/// Main tuner screen with real pitch detection
class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> with TickerProviderStateMixin {
  // Pitch detection service
  final PitchDetectionService _pitchService = PitchDetectionService();
  StreamSubscription<PitchResult>? _pitchSubscription;
  
  // UI state
  bool _isListening = false;
  String _currentNote = '--';
  double _frequency = 0.0;
  double _cents = 0.0;
  String _statusMessage = 'Tap Start to begin tuning';
  TuningModel _currentTuning = TuningModel.standard;
  String? _selectedTargetNote; // Manual note selection
  
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
    _pitchService.dispose();
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
    try {
      setState(() {
        _isListening = true;
        _statusMessage = 'Initializing microphone...';
      });

      _buttonAnimationController.forward();

      // Start pitch detection
      await _pitchService.startListening();

      // Listen to pitch stream
      _pitchSubscription = _pitchService.pitchStream.listen(
        (pitchResult) {
          if (!mounted) return;
          
          _processPitchResult(pitchResult);
        },
        onError: (error) {
          print('Pitch detection error: $error');
          if (mounted) {
            setState(() {
              _statusMessage = 'Error detecting pitch';
            });
          }
        },
      );

      setState(() {
        _statusMessage = 'Listening... Play a note!';
      });
    } catch (e) {
      print('Error starting tuner: $e');
      setState(() {
        _isListening = false;
        _statusMessage = 'Failed to start tuner';
      });
      _buttonAnimationController.reverse();
    }
  }

  void _processPitchResult(PitchResult result) {
    if (!_isListening) return;

    // Determine target note - either selected manually or auto-detect
    String targetNote;
    double targetFrequency;

    if (_selectedTargetNote != null) {
      // Use manually selected note
      targetNote = _selectedTargetNote!;
      targetFrequency = _currentTuning.notes[_selectedTargetNote]!;
    } else {
      // Auto-detect closest note from tuning
      targetNote = _findClosestNote(result.frequency);
      targetFrequency = _currentTuning.notes[targetNote] ?? result.frequency;
    }

    // Calculate cents deviation
    final cents = _calculateCents(result.frequency, targetFrequency);

    setState(() {
      _currentNote = targetNote;
      _frequency = result.frequency;
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

  void _stopListening() {
    _pitchSubscription?.cancel();
    _pitchService.stopListening();
    
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

  void _changeTuning(TuningModel newTuning) {
    setState(() {
      _currentTuning = newTuning;
      _selectedTargetNote = null; // Reset selection when changing tuning
      if (_isListening) {
        _currentNote = '--';
        _frequency = 0.0;
        _cents = 0.0;
      }
    });
  }

  void _selectTargetNote(String? note) {
    setState(() {
      _selectedTargetNote = note;
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
                    // Manual note selector
                    NoteSelector(
                      currentTuning: _currentTuning,
                      selectedNote: _selectedTargetNote,
                      onNoteSelected: _selectTargetNote,
                    ),

                    const SizedBox(height: 24),

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
                                  ? AppColors.outOfTune.withValues(alpha: 0.5)
                                  : AppColors.primary.withValues(alpha: 0.5),
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
