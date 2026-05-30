import 'package:flutter/material.dart';
import 'package:sarah_app/presentation/child/screens/child_home_screen.dart';
import 'package:sarah_app/presentation/child/screens/child_task_screen.dart';
import 'package:sarah_app/presentation/parent/screens/parent_add_task_screen.dart';
import 'package:sarah_app/presentation/parent/screens/parent_home_screen.dart';

class AppRoutes {
  static const String childHome = '/child/home';
  static const String childTask = '/child/task';
  static const String parentHome = '/parent/home';
  static const String parentAddTask = '/parent/add-task';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case childHome:
        return MaterialPageRoute(builder: (_) => const ChildHomeScreen());
      case childTask:
        return MaterialPageRoute(builder: (_) => const ChildTaskScreen());
      case parentHome:
        return MaterialPageRoute(builder: (_) => const ParentHomeScreen());
      case parentAddTask:
        return MaterialPageRoute(builder: (_) => const ParentAddTaskScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
        );
    }
  }
}
