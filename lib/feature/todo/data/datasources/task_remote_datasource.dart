import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexvoria_assignment_flutter/feature/todo/data/model/task_model.dart';

class TaskRemoteDataSource {
  TaskRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tasksRef =>
      _firestore.collection('tasks');

  Stream<List<TaskModel>> watchTasks() {
    return _tasksRef
        .orderBy('createdAt', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((snap) => snap.docs.map((d) => TaskModel.fromDoc(d)).toList());
  }

  Future<void> addTask(TaskModel task) {
    return _tasksRef.doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) {
    return _tasksRef.doc(task.id).set(task.toMap(), SetOptions(merge: true));
  }

  Future<void> toggleComplete(String id, bool value) {
    return _tasksRef.doc(id).update({'isCompleted': value});
  }

  Future<void> deleteTask(String id) {
    return _tasksRef.doc(id).delete();
  }
}
