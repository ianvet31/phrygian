import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/tuning_model.dart';

/// A bottom sheet widget for selecting different guitar tunings
class TuningSelector extends StatelessWidget {
  final TuningModel currentTuning;
  final Function(TuningModel) onTuningSelected;

  const TuningSelector({
    super.key,
    required this.currentTuning,
    required this.onTuningSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textDisabled,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Tuning',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Tuning options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: TuningModel.allTunings.length,
              itemBuilder: (context, index) {
                final tuning = TuningModel.allTunings[index];
                final isSelected = tuning.name == currentTuning.name;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  title: Text(
                    tuning.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    tuning.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onTap: () {
                    onTuningSelected(tuning);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Show the tuning selector as a modal bottom sheet
  static Future<void> show(
    BuildContext context, {
    required TuningModel currentTuning,
    required Function(TuningModel) onTuningSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TuningSelector(
        currentTuning: currentTuning,
        onTuningSelected: onTuningSelected,
      ),
    );
  }
}
