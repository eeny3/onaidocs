import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onaidocs/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:onaidocs/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:onaidocs/features/tasks/domain/repositories/task_repository.dart';
import 'package:onaidocs/features/tasks/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerFactory(() => TaskBloc(repository: sl()));

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
