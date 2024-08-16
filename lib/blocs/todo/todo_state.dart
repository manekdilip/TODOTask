import 'package:flutter/material.dart';

import '../../utils/app_pages.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo?> allTodos;

  TodoLoaded(this.allTodos);
}

class TodoFbLoaded extends TodoState {
  final List<Todo?> allFbTodos;

  TodoFbLoaded(this.allFbTodos);
}

class TodoOperationSuccess extends TodoState {
  final String message;

  TodoOperationSuccess(this.message);
}

class TodoError extends TodoState {
  final String errorMessage;

  TodoError(this.errorMessage);
}
