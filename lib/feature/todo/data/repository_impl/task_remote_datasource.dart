import 'dart:async';
import 'package:nexvoria_assignment_flutter/feature/todo/data/datasources/task_local_datasource.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/datasources/task_remote_datasource.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/model/task_model.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/domain/entites/task_entity.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  StreamController<List<TaskEntity>>? _controller;

  @override
  Stream<List<TaskEntity>> watchTasks() {
    _controller ??= StreamController<List<TaskEntity>>.broadcast(
      onListen: () {
        final cached = localDataSource.getCachedTasks();
        if (cached.isNotEmpty) {
          _controller?.add(cached);
        }

        remoteDataSource.watchTasks().listen(
          (tasks) async {
            await localDataSource.cacheTasks(tasks);
            _controller?.add(tasks);
          },
          onError: (error) {
            final fallback = localDataSource.getCachedTasks();
            _controller?.add(fallback);
          },
        );
      },
    );

    return _controller!.stream;
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    await localDataSource.addTask(task);
    _emitCurrentCache();
    await remoteDataSource.addTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await localDataSource.updateTask(task);
    _emitCurrentCache();
    await remoteDataSource.updateTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> toggleComplete(String id, bool isCompleted) async {
    final cached = localDataSource.getCachedTasks();
    final existing = cached.where((t) => t.id == id).firstOrNull;
    if (existing != null) {
      final updated = existing.copyWith(isCompleted: isCompleted);
      await localDataSource.updateTask(updated);
      _emitCurrentCache();
    }
    await remoteDataSource.toggleComplete(id, isCompleted);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
    _emitCurrentCache();
    await remoteDataSource.deleteTask(id);
  }

  void _emitCurrentCache() {
    final cached = localDataSource.getCachedTasks();
    _controller?.add(cached);
  }
}
