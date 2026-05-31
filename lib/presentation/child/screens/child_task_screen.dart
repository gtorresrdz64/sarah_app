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

class _ChildTaskScreenState extends State<ChildTaskScreen> {
  _TaskScreenState _state = _TaskScreenState.idle;

  final AudioPlaybackService _audioService = AudioPlaybackService();
  final TaskRepositoryImpl _repository = TaskRepositoryImpl(LocalDataSource());
  late final CompleteTask _completeTaskUseCase = CompleteTask(_repository);

  Task? _activeTask;
  Timer? _elapsedTimer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadActiveTask();
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
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
      if (mounted) {
        setState(() {
          _activeTask = null;
        });
      }
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
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      AudioAssets.keepGoing,
      AudioAssets.almostDone,
    ];

    int index = 0;
    while (mounted && _state == _TaskScreenState.playing) {
      final asset = intermediateAnnouncements[index];
      await _audioService.play(asset);

      index = (index + 1) % intermediateAnnouncements.length;

      if (!mounted || _state != _TaskScreenState.playing) return;
      await Future.delayed(pauseDuration);
    }
  }

  Future<void> _completeTask() async {
    if (_activeTask == null || _state == _TaskScreenState.completed) return;

    // Set state immediately to prevent re-entrancy and stop intermediate loops
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildContent()),
              if (_state == _TaskScreenState.playing) ...[
                const SizedBox(height: 24),
                _buildCompleteButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_activeTask == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No hay tareas asignadas',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Pídele a un adulto que te asigne una',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    switch (_state) {
      case _TaskScreenState.idle:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'Tu tarea',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              _activeTask!.name,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 200,
              child: ElevatedButton(
                onPressed: _startTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.primary.withValues(alpha: 0.5),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, size: 64),
                    SizedBox(height: 4),
                    Text(
                      '¡Comenzar!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case _TaskScreenState.playing:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              _activeTask!.name,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Icon(Icons.timer_outlined, size: 48, color: AppColors.secondary),
            const SizedBox(height: 8),
            Text(
              _formatTime(_elapsedSeconds),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.primary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'tiempo transcurrido',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        );
      case _TaskScreenState.completed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CompletionAnimation(),
            const SizedBox(height: 24),
            Text('¡Muy bien!', style: Theme.of(context).textTheme.displayLarge),
          ],
        );
    }
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _completeTask,
        icon: const Icon(Icons.check_circle, size: 32),
        label: const Text('¡Tarea completada!'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 80),
        ),
      ),
    );
  }
}
