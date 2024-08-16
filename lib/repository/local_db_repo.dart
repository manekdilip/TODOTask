import 'package:flutter/foundation.dart';
import '../utils/app_pages.dart';

class HiveDataStore {
  static const boxName = AppStrings.tasksBox;
  final Box<Todo> box = Hive.box<Todo>(boxName);

  /// Add new Task
  Future<void> addTask({required Todo task}) async {
    await box.put(task.id, task);
  }

  /// Show task
  Future<Todo?> getTask({required String id}) async {
    return box.get(id);
  }

   Future<List<Todo?>> getAllTask() async {
     List<Todo?> todos=[];
     var box = await Hive.openBox<Todo>(AppStrings.tasksBox);

     for (var task in box.values) {
        todos.add(task);
     }
     return todos;
   }
  /// Update task
  Future<void> updateTask({required Todo task}) async {
    await box.put(task.id, task);
  }

  /// Delete task
  Future<void> deleteTask({required Todo task}) async {
    await task.delete();
  }

  ValueListenable<Box<Todo>> listenToTask() {
    return box.listenable();
  }
}