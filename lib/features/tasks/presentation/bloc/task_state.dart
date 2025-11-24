import 'package:equatable/equatable.dart';
import 'package:onaidocs/features/tasks/domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> filteredTasks;

  const TaskLoaded({required this.tasks, this.filteredTasks = const []});

  @override
  List<Object> get props => [tasks, filteredTasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
