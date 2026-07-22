import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:nexvoria_assignment_flutter/core/router/App_routes.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/domain/entites/task_entity.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/pages/add_edit_page.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/pages/splash_screen.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/pages/todolist_page.dart';

class AppRouter {
  AppRouter._();
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.todoList,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey,
          child: const TodoListPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.addEditTask,
        pageBuilder: (context, state) {
          final task = state.extra as TaskEntity?;
          return _slideUpTransitionPage(
            key: state.pageKey,
            child: AddEditTaskPage(existingTask: task),
          );
        },
      ),
    ],
  );

  static CustomTransitionPage _fadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: ((context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      }),
    );
  }

  static CustomTransitionPage _slideUpTransitionPage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: ((context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      }),
    );
  }
}
