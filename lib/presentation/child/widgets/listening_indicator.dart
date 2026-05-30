import 'package:flutter/material.dart';
import 'package:sarah_app/core/constants/app_colors.dart';

class ListeningIndicator extends StatefulWidget {
  const ListeningIndicator({super.key});

  @override
  State<ListeningIndicator> createState() => _ListeningIndicatorState();
}

class _ListeningIndicatorState extends State<ListeningIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 80 + _controller.value * 20,
          height: 80 + _controller.value * 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.8 - _controller.value * 0.3),
          ),
          child: const Icon(Icons.mic, size: 40, color: Colors.white),
        );
      },
    );
  }
}
