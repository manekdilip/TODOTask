import 'dart:developer';
import 'package:platform_device_id_v3/platform_device_id.dart';
import '../utils/app_pages.dart';

class FireStoreService {
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');
  String currentUserId = 'default';

  ///update todos to the remote DB
  Future<void> updateTodo(Todo todo) {
    return _todosCollection
        .doc(currentUserId)
        .collection('user_todos')
        .doc(todo.id)
        .update({
      'title': todo.title,
      'description': todo.description,
      'createdDT': todo.createdDT,
      'updatedDT': todo.updatedDT,
      'isCompleted': todo.isCompleted,
      'isSynced': todo.isSynced,
    });
  }

  ///get todos from remote DB
  Future<List<Todo>> getTodos() async {
    currentUserId = await PlatformDeviceId.getDeviceId ?? 'default';
    List<Todo> firebaseTodos = [];
    var querySnapshot = await _todosCollection
        .doc(currentUserId)
        .collection('user_todos')
        .get();
    try {
      var todos = querySnapshot.docs;
      for (var todo in todos) {
        var fbTodo = Todo(
          id: todo.id,
          title: todo['title'],
          description: todo['description'],
          createdDT: todo['createdDT'].toDate(),
          updatedDT: todo['updatedDT'].toDate(),
          isCompleted: todo['isCompleted'],
          isSynced: todo['isSynced'],
        );
        firebaseTodos.add(fbTodo);
      }
    } catch (e) {
      log(e.toString());
    }
    return firebaseTodos;
    // return _todosCollection
    //     .doc(currentUserId)
    //     .collection('user_todos')
    //     .snapshots()
    //     .map((snapshot) {
    //   return snapshot.docs.map((doc) {
    //     Map<String, dynamic> data = doc.data();
    //     return Todo(
    //       id: doc.id,
    //       title: data['title'],
    //       description: data['description'],
    //       createdDT: data['createdDT'],
    //       updatedDT: data['updatedDT'],
    //       isCompleted: data['isCompleted'],
    //       isSynced: data['isSynced'],
    //     );
    //   }).toList();
    // });
  }

  ///add todos to remote DB
  Future<void> addTodo(Todo todo) async {
    currentUserId = await PlatformDeviceId.getDeviceId ?? 'default';
    return _todosCollection
        .doc(currentUserId)
        .collection('user_todos')
        .doc(todo.id)
        .set({
      'title': todo.title,
      'description': todo.description,
      'createdDT': todo.createdDT,
      'updatedDT': todo.updatedDT,
      'isCompleted': todo.isCompleted,
      'isSynced': true,
    });
  }

  ///delete todos to remote DB
  Future<void> deleteTodo(String todoId) {
    return _todosCollection
        .doc(currentUserId)
        .collection('user_todos')
        .doc(todoId)
        .delete();
  }
}
