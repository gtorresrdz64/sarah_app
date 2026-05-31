import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sarah_app/core/constants/app_colors.dart';

/// Duolingo-style celebration:
///  • Elastic pop of the trophy icon
///  • Confetti particles burst from center
///  • Star shower from top
class CompletionAnimation extends StatefulWidget {
  const CompletionAnimation({super.key});

  @override
  State<CompletionAnimation> createState() => _CompletionAnimationState();
}

class _CompletionAnimationState extends State<CompletionAnimation>
    with TickerProviderStateMixin {
  // Trophy pop
  late AnimationController _popCtrl;
  late Animation<double> _popScale;

  // Confetti burst
  late AnimationController _confettiCtrl;

  // Persistent gentle bob
  late AnimationController _bobCtrl;
  late Animation<double> _bobY;

  final List<_Particle> _particles = [];
  final math.Random _rng = math.Random();

  static const int _particleCount = 18;
  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.pink,
    AppColors.warning,
  ];

  @override
  void initState() {
    super.initState();

    // Generate particles
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(_Particle(rng: _rng));
    }

    // Trophy pop (elasticOut)
    _popCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _popScale = CurvedAnimation(parent: _popCtrl, curve: Curves.elasticOut);
    _popCtrl.forward();

    // Confetti burst (linear, one-shot)
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _confettiCtrl.forward();

    // Bob loop
    _bobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _bobY = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(parent: _bobCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    _confettiCtrl.dispose();
    _bobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti layer
          AnimatedBuilder(
            animation: _confettiCtrl,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(220, 220),
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _confettiCtrl.value,
                ),
              );
            },
          ),

          // Trophy icon
          AnimatedBuilder(
            animation: Listenable.merge([_popScale, _bobY]),
            builder: (context, _) {
              return Transform.translate(
                offset: Offset(0, _bobY.value),
                child: ScaleTransition(
                  scale: _popScale,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(
                        color: AppColors.primaryDark,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                          blurRadius: 0,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      size: 68,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Confetti particles
// ─────────────────────────────────────────────────────────────────────────────

class _Particle {
  final double angle; // launch direction (radians)
  final double speed; // max travel distance (px)
  final double size; // dot size
  final Color color;
  final double spin; // rotation

  _Particle({required math.Random rng})
    : angle = rng.nextDouble() * 2 * math.pi,
      speed = 60 + rng.nextDouble() * 60,
      size = 6 + rng.nextDouble() * 8,
      color = _CompletionAnimationState
          ._colors[rng.nextInt(_CompletionAnimationState._colors.length)],
      spin = (rng.nextDouble() - 0.5) * 6;
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress; // 0..1

  const _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final eased = Curves.easeOut.transform(progress);

    for (final p in particles) {
      final dx = math.cos(p.angle) * p.speed * eased;
      final dy = math.sin(p.angle) * p.speed * eased;
      final opacity = (1.0 - eased * 0.8).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(center.dx + dx, center.dy + dy);
      canvas.rotate(p.spin * progress);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: p.size,
        height: p.size * 0.6,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
