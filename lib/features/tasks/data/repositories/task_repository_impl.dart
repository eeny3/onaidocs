import 'package:onaidocs/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:onaidocs/features/tasks/data/models/task_model.dart';
import 'package:onaidocs/features/tasks/domain/entities/task.dart';
import 'package:onaidocs/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks() async {
    return await localDataSource.getTasks();
  }

  @override
  Future<void> saveTask(Task task) async {
    final tasks = await localDataSource.getTasks();
    final taskModel = TaskModel.fromEntity(task);
    
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      tasks[index] = taskModel;
    } else {
      tasks.add(taskModel);
    }
    
    await localDataSource.cacheTasks(tasks);
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await localDataSource.getTasks();
    tasks.removeWhere((t) => t.id == id);
    await localDataSource.cacheTasks(tasks);
  }
}
