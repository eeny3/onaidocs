import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onaidocs/features/tasks/domain/repositories/task_repository.dart';
import 'package:onaidocs/features/tasks/presentation/bloc/task_event.dart';
import 'package:onaidocs/features/tasks/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddUpdateTask>(_onAddUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<SearchTasks>(_onSearchTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks: tasks, filteredTasks: tasks));
    } catch (e) {
      emit(const TaskError("Failed to load tasks"));
    }
  }

  Future<void> _onAddUpdateTask(AddUpdateTask event, Emitter<TaskState> emit) async {
    try {
      await repository.saveTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(const TaskError("Failed to save task"));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await repository.deleteTask(event.taskId);
      add(LoadTasks());
    } catch (e) {
      emit(const TaskError("Failed to delete task"));
    }
  }

  void _onSearchTasks(SearchTasks event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final loadedState = state as TaskLoaded;
      final query = event.query.toLowerCase();
      
      final filtered = loadedState.tasks.where((task) {
        return task.title.toLowerCase().contains(query) ||
               task.description.toLowerCase().contains(query);
      }).toList();

      emit(TaskLoaded(tasks: loadedState.tasks, filteredTasks: filtered));
    }
  }
}
