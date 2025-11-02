/// Represents the result of pitch detection
class PitchResult {
  final String note;
  final double frequency;
  final double cents;
  final DateTime? timestamp;

  const PitchResult({
    required this.note,
    required this.frequency,
    required this.cents,
    this.timestamp,
  });

  /// Create an empty/inactive pitch result
  static PitchResult empty = PitchResult(
    note: '--',
    frequency: 0.0,
    cents: 0.0,
    timestamp: DateTime.now(),
  );

  /// Check if this is a valid result
  bool get isValid => note != '--' && frequency > 0;

  /// Check if the pitch is in tune (within ±5 cents)
  bool get isInTune => cents.abs() < 5;

  /// Check if the pitch is close to being in tune (within ±15 cents)
  bool get isClose => cents.abs() < 15;

  /// Get tuning status as a string
  String get tuningStatus {
    if (isInTune) return 'In Tune';
    if (isClose) return 'Close';
    return 'Out of Tune';
  }

  @override
  String toString() {
    return 'PitchResult(note: $note, frequency: ${frequency.toStringAsFixed(2)} Hz, '
        'cents: ${cents.toStringAsFixed(1)}, status: $tuningStatus)';
  }
}
