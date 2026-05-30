import 'package:sarah_app/data/datasources/local_datasource.dart';
import 'package:sarah_app/domain/entities/task.dart';
import 'package:sarah_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasks() {
    return localDataSource.getTasks();
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = await localDataSource.getTasks();
    tasks.add(task);
    await localDataSource.saveTasks(tasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await localDataSource.getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await localDataSource.saveTasks(tasks);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await localDataSource.getTasks();
    tasks.removeWhere((t) => t.id == id);
    await localDataSource.saveTasks(tasks);
  }
}
