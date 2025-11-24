import 'package:shared_preferences/shared_preferences.dart';
import 'package:onaidocs/features/tasks/data/models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> cacheTasks(List<TaskModel> tasks);
}

const String cachedTasksKey = 'CACHED_TASKS';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getTasks() async {
    final jsonString = sharedPreferences.getString(cachedTasksKey);
    if (jsonString != null) {
      return TaskModel.decode(jsonString);
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) {
    return sharedPreferences.setString(
      cachedTasksKey,
      TaskModel.encode(tasks),
    );
  }
}
