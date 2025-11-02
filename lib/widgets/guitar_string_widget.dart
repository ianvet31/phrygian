import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A widget that displays a single guitar string with tuning indicator
class GuitarStringWidget extends StatelessWidget {
  final String noteName;
  final double targetFrequency;
  final bool isActive;
  final double cents;
  final VoidCallback? onTap;

  const GuitarStringWidget({
    super.key,
    required this.noteName,
    required this.targetFrequency,
    this.isActive = false,
    this.cents = 0.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tuningColor = isActive ? AppColors.getTuningColor(cents) : AppColors.textDisabled;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.getTuningColorWithOpacity(cents, 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? tuningColor : AppColors.surfaceLight,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // String name
            SizedBox(
              width: 50,
              child: Text(
                noteName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isActive ? tuningColor : AppColors.textSecondary,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Tuning indicator bar
            Expanded(
              child: SizedBox(
                height: 32,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    
                    // Center indicator line
                    Container(
                      width: 2,
                      height: 24,
                      color: AppColors.textDisabled.withOpacity(0.3),
                    ),
                    
                    // Tuning position indicator
                    if (isActive)
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment(
                          (cents / 50).clamp(-1.0, 1.0),
                          0,
                        ),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: tuningColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: tuningColor.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Target frequency
            SizedBox(
              width: 80,
              child: Text(
                '${targetFrequency.toStringAsFixed(2)} Hz',
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
