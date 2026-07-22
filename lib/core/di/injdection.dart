import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/data/repo_impl/connectivity_repo_impl.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/domain/repositories/connectivity_repository.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/presentation/cubit/connectivity_cubit.dart';
import 'package:nexvoria_assignment_flutter/feature/theme/bloc/theme_cubit.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/datasources/task_local_datasource.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/datasources/task_remote_datasource.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/repository_impl/task_remote_datasource.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/domain/repositories/task_repository.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/bloc/task_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ---- External (Firebase) ----
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  // ---- Data sources ----
  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSource(firestore: getIt()),
  );
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );

  // ---- Repositories ----
  getIt.registerLazySingleton<TaskRepository>(
    () =>
        TaskRepositoryImpl(remoteDataSource: getIt(), localDataSource: getIt()),
  );
  getIt.registerLazySingleton<ConnectivityRepository>(
    () => ConnectivityRepositoryImpl(getIt()),
  );

  getIt.registerFactory<TaskBloc>(() => TaskBloc(getIt()));

  getIt.registerFactory<ThemeCubit>(() => ThemeCubit());

  getIt.registerLazySingleton<ConnectivityCubit>(
    () => ConnectivityCubit(getIt()),
  );
}
