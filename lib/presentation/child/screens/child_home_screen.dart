import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarah_app/core/constants/app_colors.dart';
import 'package:sarah_app/presentation/bloc/mode_bloc.dart';
import 'package:sarah_app/routes.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen>
    with TickerProviderStateMixin {
  // Pulsing glow ring behind the main button (Duolingo-style)
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  // Gentle floating for the mascot stars
  late AnimationController _floatCtrl;
  late Animation<double> _floatY;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: false);

    _pulseScale = Tween<double>(
      begin: 1.0,
      end: 1.35,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));
    _pulseOpacity = Tween<double>(
      begin: 0.45,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatY = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.childBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // ── Top row: mode-switch link ──────────────────────────────────
              Align(alignment: Alignment.centerRight, child: _ParentModeChip()),

              const Spacer(flex: 2),

              // ── Greeting ──────────────────────────────────────────────────
              AnimatedBuilder(
                animation: _floatY,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _floatY.value),
                  child: child,
                ),
                child: Column(
                  children: [
                    // Floating star decorations
                    _StarDecorations(),
                    const SizedBox(height: 16),

                    // Greeting text
                    Text(
                      '¡Hola Sarah!',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '¿Lista para tu tarea de hoy?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // ── Main clay button with pulsing glow ────────────────────────
              _ClayPlayButton(
                pulseScale: _pulseScale,
                pulseOpacity: _pulseOpacity,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.childTask),
              ),

              const Spacer(flex: 3),

              // ── Streak / encouragement bar ────────────────────────────────
              _StreakBanner(),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ParentModeChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<ModeCubit>().switchToParent(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowOuter,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'Modo padres',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarDecorations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 20,
            top: 0,
            child: _Star(size: 28, color: AppColors.accent),
          ),
          Positioned(
            right: 20,
            top: 10,
            child: _Star(size: 20, color: AppColors.pink),
          ),
          Positioned(
            left: 70,
            bottom: 0,
            child: _Star(size: 16, color: AppColors.secondary),
          ),
          Positioned(
            right: 60,
            bottom: 0,
            child: _Star(size: 22, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _Star extends StatelessWidget {
  final double size;
  final Color color;
  const _Star({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.star_rounded, size: size, color: color);
  }
}

class _ClayPlayButton extends StatefulWidget {
  final Animation<double> pulseScale;
  final Animation<double> pulseOpacity;
  final VoidCallback onPressed;

  const _ClayPlayButton({
    required this.pulseScale,
    required this.pulseOpacity,
    required this.onPressed,
  });

  @override
  State<_ClayPlayButton> createState() => _ClayPlayButtonState();
}

class _ClayPlayButtonState extends State<_ClayPlayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.pulseScale, widget.pulseOpacity]),
        builder: (context, child) {
          return SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulse ring
                Opacity(
                  opacity: widget.pulseOpacity.value,
                  child: Transform.scale(
                    scale: widget.pulseScale.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                ),

                // Clay button
                AnimatedScale(
                  scale: _pressed ? 0.93 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(
                        color: AppColors.primaryDark,
                        width: 4,
                      ),
                      boxShadow: [
                        // Outer drop shadow
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.6),
                          blurRadius: 0,
                          offset: const Offset(0, 6),
                        ),
                        // Soft ambient
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 72,
                          color: AppColors.white,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '¡Comenzar!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.6),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowOuter,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 28,
            color: AppColors.warning,
          ),
          const SizedBox(width: 10),
          Text(
            '¡Sigue así, campeona!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
