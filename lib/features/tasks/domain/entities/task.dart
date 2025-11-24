import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, priority, createdAt];
}
