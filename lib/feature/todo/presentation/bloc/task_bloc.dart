import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/domain/entites/task_entity.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(this._repository) : super(TaskInitial()) {
    on<WatchTasksRequested>(_onWatchTasksRequested);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskAdded>(_onTaskAdded);
    on<TaskToggled>(_onTaskToggled);
    on<TaskDeleted>(_onTaskDeleted);
    on<TaskRestored>(_onTaskRestored);
    on<TasksUpdated>(onTasksUpdated);
  }

  final TaskRepository _repository;
  StreamSubscription<List<TaskEntity>>? _taskSubscription;
  final _uuid = const Uuid();

  Future<void> _onWatchTasksRequested(
    WatchTasksRequested event,
    Emitter<TaskState> emit,
  ) async {
    print('🔵 WatchTasksRequested handler called');
    emit(TaskLoading());

    await _taskSubscription?.cancel();

    _taskSubscription = _repository.watchTasks().listen(
      (tasks) {
        print('🟢 Tasks received: ${tasks.length}');
        add(TasksUpdated(tasks));
      },
      onError: (error) {
        print('🔴 Stream error: $error');
        add(TasksUpdated(const []));
      },
    );
  }

  void onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    emit(TaskLoaded(event.tasks));
  }

  Future<void> _onTaskAdded(TaskAdded event, Emitter<TaskState> emit) async {
    final task = TaskEntity(
      id: _uuid.v4(),
      title: event.title,
      description: event.description,
      createdAt: DateTime.now(),
    );
    await _repository.addTask(task);
  }

  Future<void> _onTaskToggled(
    TaskToggled event,
    Emitter<TaskState> emit,
  ) async {
    await _repository.toggleComplete(event.id, event.isCompleted);
  }

  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<TaskState> emit,
  ) async {
    await _repository.deleteTask(event.task.id);
  }

  Future<void> _onTaskRestored(
    TaskRestored event,
    Emitter<TaskState> emit,
  ) async {
    await _repository.addTask(event.task);
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }

  Future<void> _onTaskUpdated(
    TaskUpdated event,
    Emitter<TaskState> emit,
  ) async {
    final updatedTask = TaskEntity(
      id: event.id,
      title: event.title,
      description: event.description,
      createdAt: DateTime.now(),
    );
    await _repository.updateTask(updatedTask);
  }
}
