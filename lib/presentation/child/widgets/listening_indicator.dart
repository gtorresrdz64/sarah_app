import 'package:flutter/material.dart';
import 'package:sarah_app/core/constants/app_colors.dart';

/// Three concentric expanding rings (like a sonar) rendered as a clay orb.
/// Used anywhere a "listening/active" state needs visual feedback.
class ListeningIndicator extends StatefulWidget {
  const ListeningIndicator({super.key});

  @override
  State<ListeningIndicator> createState() => _ListeningIndicatorState();
}

class _ListeningIndicatorState extends State<ListeningIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildRing((_ctrl.value) % 1.0, AppColors.secondary),
              _buildRing((_ctrl.value + 0.33) % 1.0, AppColors.primary),
              _buildRing((_ctrl.value + 0.66) % 1.0, AppColors.accent),
              // Core circle
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                  border: Border.all(color: AppColors.secondaryDark, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryDark.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mic_rounded,
                  size: 28,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRing(double progress, Color color) {
    final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.55;
    final scale = 0.45 + progress * 0.55;
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
        ),
      ),
    );
  }
}
