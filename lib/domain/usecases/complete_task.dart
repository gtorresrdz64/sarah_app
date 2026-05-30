import 'package:sarah_app/domain/entities/task.dart';
import 'package:sarah_app/domain/repositories/task_repository.dart';

class CompleteTask {
  final TaskRepository repository;

  CompleteTask(this.repository);

  Future<void> call(Task task) {
    return repository.updateTask(task.copyWith(isCompleted: true));
  }
}
