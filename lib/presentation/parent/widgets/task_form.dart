import 'package:flutter/material.dart';
import 'package:sarah_app/core/constants/app_colors.dart';

class TaskForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const TaskForm({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Nombre de la tarea',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          child: const Text('Asignar tarea'),
        ),
      ],
    );
  }
}
