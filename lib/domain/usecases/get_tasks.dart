import 'package:sarah_app/domain/entities/task.dart';
import 'package:sarah_app/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() {
    return repository.getTasks();
  }
}
