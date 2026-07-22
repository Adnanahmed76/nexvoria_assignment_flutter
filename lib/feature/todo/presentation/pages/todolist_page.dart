import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexvoria_assignment_flutter/core/enum/task_filter.dart';
import 'package:nexvoria_assignment_flutter/core/router/App_routes.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/presentation/widget/connectivity_banner.dart';
import 'package:nexvoria_assignment_flutter/feature/theme/bloc/theme_cubit.dart';
import 'package:nexvoria_assignment_flutter/feature/theme/bloc/theme_state.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/bloc/task_bloc.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/bloc/task_event.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/bloc/task_state.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/widgets/empty_state.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/presentation/widgets/task_tile.dart';
import 'package:nexvoria_assignment_flutter/utils/searchbar.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  TaskFilter _filter = TaskFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return IconButton(
                tooltip: 'Toggle theme',
                icon: Icon(
                  themeState.isDark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addEditTask),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading || state is TaskInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TaskError) {
                  return Center(
                    child: Text('Something went wrong: ${state.message}'),
                  );
                }

                final allTasks = (state as TaskLoaded).tasks;

                final tasks = allTasks.where((task) {
                  final matchesQuery =
                      _query.isEmpty ||
                      task.title.toLowerCase().contains(_query.toLowerCase()) ||
                      (task.description.toLowerCase().contains(
                        _query.toLowerCase(),
                      ));

                  final matchesFilter = switch (_filter) {
                    TaskFilter.all => true,
                    TaskFilter.pending => !task.isCompleted,
                    TaskFilter.completed => task.isCompleted,
                  };

                  return matchesQuery && matchesFilter;
                }).toList();

                return Column(
                  children: [
                    SearchAndFilterBar(
                      controller: _searchController,
                      selectedFilter: _filter,
                      onQueryChanged: (val) => setState(() => _query = val),
                      onFilterChanged: (val) => setState(() => _filter = val),
                    ),
                    Expanded(
                      child: allTasks.isEmpty
                          ? const EmptyState()
                          : tasks.isEmpty
                          ? const Center(
                              child: Text(
                                'No tasks match your search',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                12,
                                16,
                                100,
                              ),
                              itemCount: tasks.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),

                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return Dismissible(
                                  key: ValueKey(task.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    // Delete logic
                                    context.read<TaskBloc>().add(
                                      TaskDeleted(task),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        content: Text('${task.title} deleted'),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            context.read<TaskBloc>().add(
                                              TaskRestored(task),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: TaskTile(
                                    key: ValueKey(task.id),
                                    task: task,
                                    onTap: () => context.push(
                                      AppRoutes.addEditTask,
                                      extra: task,
                                    ),
                                    onToggleComplete: (newValue) {
                                      context.read<TaskBloc>().add(
                                        TaskToggled(
                                          id: task.id,
                                          isCompleted: newValue,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
