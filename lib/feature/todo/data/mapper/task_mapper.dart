import 'package:nexvoria_assignment_flutter/feature/todo/data/model/task_hive_model.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/domain/entites/task_entity.dart';

extension TaskEntityMapper on TaskEntity {
  TaskHiveModel toHiveModel() {
    return TaskHiveModel(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }
}

extension TaskHiveModelMapper on TaskHiveModel {
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }
}
