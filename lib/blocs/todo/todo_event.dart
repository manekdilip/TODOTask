import 'package:flutter/material.dart';

import '../../utils/app_pages.dart';

@immutable
abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class LoadFbTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
}

class UpdateTodo extends TodoEvent {
  final Todo todo;
  UpdateTodo(this.todo);
}

class SyncTodo extends TodoEvent {
  final List<Todo> todos;
  SyncTodo(this.todos);
}

class DeleteTodo extends TodoEvent {
  final Todo todo;
  DeleteTodo(this.todo);
}
