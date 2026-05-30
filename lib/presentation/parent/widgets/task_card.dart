import 'package:flutter/material.dart';
import 'package:sarah_app/core/constants/app_colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onAssign;

  const TaskCard({
    super.key,
    required this.title,
    required this.isCompleted,
    this.isActive = false,
    required this.onToggle,
    required this.onDelete,
    this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isActive
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: isCompleted,
          onChanged: (_) => onToggle(),
          activeColor: AppColors.success,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? AppColors.textSecondary : null,
              ),
        ),
        subtitle: isActive
            ? Row(
                children: [
                  Icon(Icons.star, size: 14, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text(
                    'Asignada a Sarah',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                  ),
                ],
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onAssign != null)
              IconButton(
                icon: const Icon(Icons.assignment, color: AppColors.primary),
                tooltip: 'Asignar tarea',
                onPressed: onAssign,
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
