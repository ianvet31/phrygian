import 'package:flutter/material.dart';

/// Color palette for the guitar tuner app
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accent = Color(0xFFFF6F00);
  
  // Tuning status colors
  static const Color inTune = Color(0xFF4CAF50);
  static const Color close = Color(0xFFFF9800);
  static const Color outOfTune = Color(0xFFF44336);
  
  // Background colors
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2C2C2C);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0xFF757575);
  
  // Guitar string colors (wood/metal aesthetic)
  static const Color stringColor = Color(0xFFD4AF37); // Gold
  static const Color fretboard = Color(0xFF3E2723); // Dark brown
  
  /// Get tuning status color based on cents deviation
  static Color getTuningColor(double cents) {
    final absCents = cents.abs();
    if (absCents < 5) {
      return inTune;
    } else if (absCents < 15) {
      return close;
    } else {
      return outOfTune;
    }
  }
  
  /// Get tuning status color with opacity
  static Color getTuningColorWithOpacity(double cents, double opacity) {
    return getTuningColor(cents).withValues(alpha: opacity);
  }
}
