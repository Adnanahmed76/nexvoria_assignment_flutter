import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexvoria_assignment_flutter/core/di/injdection.dart';
import 'package:nexvoria_assignment_flutter/core/router/app_router.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/presentation/cubit/connectivity_cubit.dart';
import 'package:nexvoria_assignment_flutter/feature/theme/bloc/theme_cubit.dart';
import 'package:nexvoria_assignment_flutter/feature/theme/bloc/theme_state.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/datasources/task_local_datasource.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/model/task_hive_model.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/bloc/task_bloc.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/bloc/task_event.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(TaskHiveModelAdapter());
  await Hive.openBox<TaskHiveModel>(TaskLocalDataSourceImpl.boxName);

  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()),
        BlocProvider.value(value: getIt<ConnectivityCubit>()),
        BlocProvider<TaskBloc>(
          create: (_) => getIt<TaskBloc>()..add(const WatchTasksRequested()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            themeMode: themeState.themeMode,
            theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            title: 'Offline-First To-Do',
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
