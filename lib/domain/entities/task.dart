import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String name;
  final bool isCompleted;
  final bool isActive;
  final DateTime assignedAt;

  const Task({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.isActive = false,
    required this.assignedAt,
  });

  Task copyWith({
    String? id,
    String? name,
    bool? isCompleted,
    bool? isActive,
    DateTime? assignedAt,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
      'isActive': isActive,
      'assignedAt': assignedAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      name: json['name'] as String,
      isCompleted: json['isCompleted'] as bool,
      isActive: json['isActive'] as bool? ?? false,
      assignedAt: DateTime.parse(json['assignedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, isCompleted, isActive, assignedAt];
}
