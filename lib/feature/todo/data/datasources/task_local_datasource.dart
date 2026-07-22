import 'package:hive/hive.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/mapper/task_mapper.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/model/task_hive_model.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/domain/entites/task_entity.dart';

abstract class TaskLocalDataSource {
  List<TaskEntity> getCachedTasks();
  Future<void> cacheTasks(List<TaskEntity> tasks);
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String boxName = 'tasks_box';

  Box<TaskHiveModel> get _box => Hive.box<TaskHiveModel>(boxName);

  @override
  List<TaskEntity> getCachedTasks() {
    return _box.values.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> cacheTasks(List<TaskEntity> tasks) async {
    await _box.clear();
    final map = {for (final t in tasks) t.id: t.toHiveModel()};
    await _box.putAll(map);
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    await _box.put(task.id, task.toHiveModel());
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await _box.put(task.id, task.toHiveModel());
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
