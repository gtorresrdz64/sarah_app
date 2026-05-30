import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarah_app/core/constants/app_colors.dart';
import 'package:sarah_app/data/datasources/local_datasource.dart';
import 'package:sarah_app/data/repositories/task_repository_impl.dart';
import 'package:sarah_app/domain/entities/task.dart';
import 'package:sarah_app/domain/usecases/get_tasks.dart';
import 'package:sarah_app/presentation/bloc/mode_bloc.dart';
import 'package:sarah_app/presentation/parent/widgets/task_card.dart';
import 'package:sarah_app/routes.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  final TaskRepositoryImpl _repository =
      TaskRepositoryImpl(LocalDataSource());
  late final GetTasks _getTasks = GetTasks(_repository);

  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _getTasks();
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    }
  }

  Future<void> _assignTask(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Asignar tarea'),
        content: Text('¿Asignar "${task.name}" a Sarah?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Asignar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (final t in _tasks) {
        if (t.isActive) {
          await _repository.updateTask(t.copyWith(isActive: false));
        }
      }
      await _repository.updateTask(task.copyWith(isActive: true));
      _loadTasks();
    }
  }

  Task? get _activeTask {
    try {
      return _tasks.firstWhere((t) => t.isActive);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas de Sarah'),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.child_care),
            onPressed: () {
              context.read<ModeCubit>().switchToChild();
            },
            tooltip: 'Modo niño',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, AppRoutes.parentAddTask);
          if (result != null && result is String) {
            final task = Task(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: result,
              assignedAt: DateTime.now(),
            );
            await _repository.addTask(task);
            _loadTasks();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }

  Widget _buildBody() {
    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 80, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No hay tareas asignadas',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega una tarea para Sarah',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_activeTask != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: AppColors.accent, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarea activa',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        _activeTask!.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return TaskCard(
                title: task.name,
                isCompleted: task.isCompleted,
                isActive: task.isActive,
                onToggle: () async {
                  final updated = task.copyWith(isCompleted: !task.isCompleted);
                  await _repository.updateTask(updated);
                  _loadTasks();
                },
                onAssign: !task.isActive && !task.isCompleted
                    ? () => _assignTask(task)
                    : null,
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Eliminar tarea'),
                      content: Text('¿Eliminar "${task.name}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Eliminar',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await _repository.deleteTask(task.id);
                    _loadTasks();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
