import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarah_app/domain/entities/task.dart';

class LocalDataSource {
  static const _tasksKey = 'tasks';

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_tasksKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_tasksKey, json);
  }
}
