import 'package:flutter/material.dart';
import 'package:sarah_app/core/constants/app_colors.dart';

class ParentAddTaskScreen extends StatefulWidget {
  const ParentAddTaskScreen({super.key});

  @override
  State<ParentAddTaskScreen> createState() => _ParentAddTaskScreenState();
}

class _ParentAddTaskScreenState extends State<ParentAddTaskScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva tarea'),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '¿Qué tarea va a hacer Sarah?',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre de la tarea',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              autofocus: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  Navigator.pop(context, text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Asignar tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
