import 'package:nexvoria_assignment_flutter/feature/todo/domain/entites/task_entity.dart';

abstract class TaskRepository {
  Stream<List<TaskEntity>> watchTasks();
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> toggleComplete(String id, bool value);
  Future<void> deleteTask(String id);
}
