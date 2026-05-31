import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sarah_app/core/constants/app_colors.dart';
import 'package:sarah_app/core/constants/audio_assets.dart';
import 'package:sarah_app/data/datasources/local_datasource.dart';
import 'package:sarah_app/data/repositories/task_repository_impl.dart';
import 'package:sarah_app/domain/entities/task.dart';
import 'package:sarah_app/domain/usecases/complete_task.dart';
import 'package:sarah_app/presentation/child/widgets/completion_animation.dart';
import 'package:sarah_app/services/audio_playback_service.dart';

enum _TaskScreenState { idle, playing, completed }

class ChildTaskScreen extends StatefulWidget {
  const ChildTaskScreen({super.key});

  @override
  State<ChildTaskScreen> createState() => _ChildTaskScreenState();
}

class _ChildTaskScreenState extends State<ChildTaskScreen>
    with TickerProviderStateMixin {
  _TaskScreenState _state = _TaskScreenState.idle;

  final AudioPlaybackService _audioService = AudioPlaybackService();
  final TaskRepositoryImpl _repository = TaskRepositoryImpl(LocalDataSource());
  late final CompleteTask _completeTaskUseCase = CompleteTask(_repository);

  Task? _activeTask;
  Timer? _elapsedTimer;
  int _elapsedSeconds = 0;

  // Audio-wave animation while playing
  late AnimationController _waveCtrl;

  // Bounce animation for the complete button
  late AnimationController _btnBounceCtrl;
  late Animation<double> _btnBounceScale;

  @override
  void initState() {
    super.initState();
    _loadActiveTask();

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _btnBounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _btnBounceScale = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _btnBounceCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _waveCtrl.dispose();
    _btnBounceCtrl.dispose();
    _audioService.stop();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _loadActiveTask() async {
    try {
      final tasks = await _repository.getTasks();
      if (mounted) {
        setState(() {
          try {
            _activeTask = tasks.firstWhere((t) => t.isActive);
          } catch (_) {
            _activeTask = null;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading active task: $e');
      if (mounted) setState(() => _activeTask = null);
    }
  }

  void _startTask() {
    setState(() => _state = _TaskScreenState.playing);
    _startTimer();
    _playSequence();
  }

  void _startTimer() {
    _elapsedSeconds = 0;
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  Future<void> _playSequence() async {
    const pauseDuration = Duration(seconds: 10);

    if (!mounted || _state != _TaskScreenState.playing) return;
    await _audioService.play(AudioAssets.taskStarted);

    if (!mounted || _state != _TaskScreenState.playing) return;
    await Future.delayed(pauseDuration);

    const intermediateAnnouncements = [
      AudioAssets.goodJob,
      AudioAssets.howIsYourTask,
      AudioAssets.keepGoing,
      AudioAssets.cheers,
      AudioAssets.almostDone,
    ];

    int index = 0;
    while (mounted && _state == _TaskScreenState.playing) {
      await _audioService.play(intermediateAnnouncements[index]);
      index = (index + 1) % intermediateAnnouncements.length;
      if (!mounted || _state != _TaskScreenState.playing) return;
      await Future.delayed(pauseDuration);
    }
  }

  Future<void> _completeTask() async {
    if (_activeTask == null || _state == _TaskScreenState.completed) return;

    setState(() => _state = _TaskScreenState.completed);

    _elapsedTimer?.cancel();
    _audioService.stop();
    await _audioService.play(AudioAssets.allDone);

    try {
      await _completeTaskUseCase(_activeTask!);
    } catch (e) {
      debugPrint('Error completing task: $e');
    }

    if (mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) Navigator.pop(context);
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.childBackground,
      // No AppBar — clean full-screen experience for children
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Back arrow (subtle)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textSecondary.withValues(alpha: 0.25),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowOuter,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildContent()),
              if (_state == _TaskScreenState.playing) ...[
                const SizedBox(height: 16),
                _buildCompleteButton(),
                const SizedBox(height: 24),
              ],
              if (_state != _TaskScreenState.playing)
                const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_activeTask == null) {
      return Center(
        child: _ClayCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No hay tareas asignadas',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Pídele a un adulto\nque te asigne una',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    switch (_state) {
      case _TaskScreenState.idle:
        return _buildIdleState();
      case _TaskScreenState.playing:
        return _buildPlayingState();
      case _TaskScreenState.completed:
        return _buildCompletedState();
    }
  }

  // ── Idle ──────────────────────────────────────────────────────────────────
  Widget _buildIdleState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Task card
        _ClayCard(
          color: AppColors.cardWhite,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.assignment_rounded,
                  size: 52,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tu tarea de hoy',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Text(
                _activeTask!.name,
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Start button (clay style)
        _ClayActionButton(
          label: '¡Empezar tarea!',
          color: AppColors.primary,
          borderColor: AppColors.primaryDark,
          icon: Icons.play_arrow_rounded,
          onTap: _startTask,
        ),
      ],
    );
  }

  // ── Playing ───────────────────────────────────────────────────────────────
  Widget _buildPlayingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Task name chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Text(
            _activeTask!.name,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.primary),
          ),
        ),

        const SizedBox(height: 32),

        // Audio wave indicator (clay orb)
        _AudioWaveOrb(controller: _waveCtrl),

        const SizedBox(height: 32),

        // Timer card
        _ClayCard(
          color: AppColors.cardWhite,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
          child: Column(
            children: [
              Text(
                _formatTime(_elapsedSeconds),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.primary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontSize: 52,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'tiempo transcurrido',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Motivational pill
        _MotivationalPill(),
      ],
    );
  }

  // ── Completed ─────────────────────────────────────────────────────────────
  Widget _buildCompletedState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CompletionAnimation(),
        const SizedBox(height: 24),
        Text(
          '¡Lo lograste!',
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '¡Eres una campeona! 🏆',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Complete button ────────────────────────────────────────────────────────
  Widget _buildCompleteButton() {
    return ScaleTransition(
      scale: _btnBounceScale,
      child: _ClayActionButton(
        label: '¡Tarea completada!',
        color: AppColors.success,
        borderColor: AppColors.successDark,
        icon: Icons.check_circle_rounded,
        onTap: _completeTask,
        fontSize: 22,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared clay sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ClayCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const _ClayCard({required this.child, this.color, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.15),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowOuter,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ClayActionButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color borderColor;
  final IconData icon;
  final VoidCallback onTap;
  final double fontSize;

  const _ClayActionButton({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.onTap,
    this.fontSize = 20,
  });

  @override
  State<_ClayActionButton> createState() => _ClayActionButtonState();
}

class _ClayActionButtonState extends State<_ClayActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: _pressed
            ? (Matrix4.identity()..translateByDouble(0.0, 4.0, 0.0, 1.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.borderColor, width: 3),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: widget.borderColor.withValues(alpha: 0.8),
                    blurRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: widget.borderColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 32, color: AppColors.white),
            const SizedBox(width: 12),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated orb that shows sound-wave rings while audio plays.
class _AudioWaveOrb extends StatelessWidget {
  final AnimationController controller;

  const _AudioWaveOrb({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring 1
              _buildRing(controller.value, AppColors.primary, 140),
              // Ring 2 (offset phase)
              _buildRing(
                (controller.value + 0.33) % 1.0,
                AppColors.secondary,
                140,
              ),
              // Ring 3
              _buildRing(
                (controller.value + 0.66) % 1.0,
                AppColors.accent,
                140,
              ),
              // Core orb
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.primaryDark, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  size: 38,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRing(double progress, Color color, double maxSize) {
    final scale = progress;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    return Opacity(
      opacity: opacity * 0.5,
      child: Transform.scale(
        scale: 0.5 + scale * 0.5,
        child: Container(
          width: maxSize,
          height: maxSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
        ),
      ),
    );
  }
}

/// Rotating motivational messages shown during the task.
class _MotivationalPill extends StatefulWidget {
  @override
  State<_MotivationalPill> createState() => _MotivationalPillState();
}

class _MotivationalPillState extends State<_MotivationalPill>
    with SingleTickerProviderStateMixin {
  final List<String> _messages = [
    '¡Tú puedes!',
    '¡Vas genial!',
    '¡Sigue adelante!',
    '¡Eres increíble!',
    '¡Ya casi terminas!',
  ];
  int _msgIndex = 0;
  Timer? _msgTimer;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();

    _msgTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _fadeCtrl.reverse();
      if (mounted) {
        setState(() => _msgIndex = (_msgIndex + 1) % _messages.length);
        _fadeCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _msgTimer?.cancel();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.6),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: AppColors.warning,
            ),
            const SizedBox(width: 8),
            Text(
              _messages[_msgIndex],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
