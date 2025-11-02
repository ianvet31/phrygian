import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_colors.dart';

/// A circular widget that displays the current detected note and tuning status
class NoteDisplayWidget extends StatefulWidget {
  final String note;
  final double frequency;
  final double cents;
  final bool isActive;

  const NoteDisplayWidget({
    super.key,
    required this.note,
    required this.frequency,
    required this.cents,
    required this.isActive,
  });

  @override
  State<NoteDisplayWidget> createState() => _NoteDisplayWidgetState();
}

class _NoteDisplayWidgetState extends State<NoteDisplayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tuningColor = widget.isActive
        ? AppColors.getTuningColor(widget.cents)
        : AppColors.textDisabled;

    final isInTune = widget.cents.abs() < 5;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = isInTune && widget.isActive
            ? 1.0 + (_pulseController.value * 0.05)
            : 1.0;

        return Transform.scale(
          scale: pulseValue,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: widget.isActive
                    ? [
                        tuningColor.withOpacity(0.2),
                        tuningColor.withOpacity(0.05),
                      ]
                    : [
                        AppColors.surface,
                        AppColors.background,
                      ],
              ),
              border: Border.all(
                color: tuningColor,
                width: 4,
              ),
              boxShadow: widget.isActive
                  ? [
                      BoxShadow(
                        color: tuningColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                // Tuning arc indicator
                if (widget.isActive && widget.note != '--')
                  CustomPaint(
                    size: const Size(240, 240),
                    painter: TuningArcPainter(
                      cents: widget.cents,
                      color: tuningColor,
                    ),
                  ),

                // Center content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Note name
                      Text(
                        widget.note,
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: tuningColor,
                          letterSpacing: -2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Frequency
                      if (widget.frequency > 0)
                        Text(
                          '${widget.frequency.toStringAsFixed(2)} Hz',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      const SizedBox(height: 4),

                      // Cents deviation
                      if (widget.cents != 0 && widget.note != '--')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tuningColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${widget.cents > 0 ? '+' : ''}${widget.cents.toStringAsFixed(0)}¢',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: tuningColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for the tuning arc indicator around the note display
class TuningArcPainter extends CustomPainter {
  final double cents;
  final Color color;

  TuningArcPainter({
    required this.cents,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw arc showing tuning position
    // -50 cents = -90 degrees, +50 cents = +90 degrees
    final sweepAngle = (cents / 50).clamp(-1.0, 1.0) * math.pi / 2;
    final startAngle = -math.pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TuningArcPainter oldDelegate) {
    return oldDelegate.cents != cents || oldDelegate.color != color;
  }
}
