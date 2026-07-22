import 'package:equatable/equatable.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/domain/entites/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class WatchTasksRequested extends TaskEvent {
  const WatchTasksRequested();
}

class TasksUpdated extends TaskEvent {
  final List<TaskEntity> tasks;
  const TasksUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskAdded extends TaskEvent {
  final String title;
  final String description;
  const TaskAdded({required this.title, this.description = ''});

  @override
  List<Object?> get props => [title, description];
}

class TaskToggled extends TaskEvent {
  final String id;
  final bool isCompleted;
  const TaskToggled({required this.id, required this.isCompleted});

  @override
  List<Object?> get props => [id, isCompleted];
}

class TaskDeleted extends TaskEvent {
  final TaskEntity task;
  const TaskDeleted(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskRestored extends TaskEvent {
  final TaskEntity task;
  const TaskRestored(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUpdated extends TaskEvent {
  final String id;
  final String title;
  final String description;
  const TaskUpdated({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description];
}
