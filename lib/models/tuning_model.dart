/// Represents a guitar tuning configuration
class TuningModel {
  final String name;
  final String description;
  final Map<String, double> notes;

  const TuningModel({
    required this.name,
    required this.description,
    required this.notes,
  });

  /// Standard guitar tuning (E A D G B E)
  static const TuningModel standard = TuningModel(
    name: 'Standard',
    description: 'E A D G B E',
    notes: {
      'E2': 82.41,  // Low E
      'A2': 110.00, // A
      'D3': 146.83, // D
      'G3': 196.00, // G
      'B3': 246.94, // B
      'E4': 329.63, // High E
    },
  );

  /// Drop D tuning (D A D G B E)
  static const TuningModel dropD = TuningModel(
    name: 'Drop D',
    description: 'D A D G B E',
    notes: {
      'D2': 73.42,  // Low D
      'A2': 110.00, // A
      'D3': 146.83, // D
      'G3': 196.00, // G
      'B3': 246.94, // B
      'E4': 329.63, // High E
    },
  );

  /// Half step down tuning (Eb Ab Db Gb Bb Eb)
  static const TuningModel halfStepDown = TuningModel(
    name: 'Half Step Down',
    description: 'E♭ A♭ D♭ G♭ B♭ E♭',
    notes: {
      'D#2': 77.78, // Eb
      'G#2': 103.83, // Ab
      'C#3': 138.59, // Db
      'F#3': 185.00, // Gb
      'A#3': 233.08, // Bb
      'D#4': 311.13, // Eb
    },
  );

  /// Open G tuning (D G D G B D)
  static const TuningModel openG = TuningModel(
    name: 'Open G',
    description: 'D G D G B D',
    notes: {
      'D2': 73.42,  // D
      'G2': 98.00,  // G
      'D3': 146.83, // D
      'G3': 196.00, // G
      'B3': 246.94, // B
      'D4': 293.66, // D
    },
  );

  /// DADGAD tuning
  static const TuningModel dadgad = TuningModel(
    name: 'DADGAD',
    description: 'D A D G A D',
    notes: {
      'D2': 73.42,  // D
      'A2': 110.00, // A
      'D3': 146.83, // D
      'G3': 196.00, // G
      'A3': 220.00, // A
      'D4': 293.66, // D
    },
  );

  /// List of all available tunings
  static const List<TuningModel> allTunings = [
    standard,
    dropD,
    halfStepDown,
    openG,
    dadgad,
  ];

  /// Get string names as a list
  List<String> get stringNames => notes.keys.toList();

  /// Get string frequencies as a list
  List<double> get frequencies => notes.values.toList();
}
