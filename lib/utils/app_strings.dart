import 'package:flutter/material.dart';

class AppStrings {
  static const String cancel = "Cancel";
  static const String add = "ADD";
  static const String update = "Update";
  static const String syncNow = "Sync Now";
  static const String appTitle = "Manage your Daily Task";
  static const String getStarted =   'Get Started';
  static const String ongoing = 'Ongoing';
  static const String completed = 'Completed';
  static const String noOngoingTask = 'No Ongoing Tasks!';
  static const String noCompletedTask = 'No Completed Tasks!';
  static const String markAsComplete = 'Mark as completed';
  static const String title = 'Title';
  static const String description = 'Description';
  static const String updateTitle = 'Complete Todo';
  static const String updateMsg = 'Are you sure that mark this as complete?';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String share = 'Share';
  static const String deleteTodo = 'Delete Todo';
  static const String deleteMsg = 'Are you sure that delete this Todo?';
  static const String titleHintText = 'Workout';
  static const String descriptionHintText = '10 Pull Ups';
  static const String taskName = "fireBaseSync";
  static const String defaultLanguage = "en";
  static final List supportedLanguage = ['en', 'ar'];

  static const String fontName = 'Poppins';
  static const String fontNameManRope = 'Manrope';

  static const String tasksBox = 'tasksBox';
  static const String frequencyBox = 'frequencyBox';
  static const String isWorkMangerStarted= 'isWorkMangerStarted';

  static const String prefStringsNotSyncedTodos = 'prefStringsNotSyncedTodos';

  static const addTaskFormKey = GlobalObjectKey<FormState>('addTask');
  static const updateTaskFormKey = GlobalObjectKey<FormState>('updateTask');

  static const addTitleKey= ValueKey('addTitleKey');
  static const addDescKey= ValueKey('addDescKey');
  static const updateTitleKey= ValueKey('updateTitleKey');
  static const updateDescKey= ValueKey('updateDescKey');
  static const addTodoKey= ValueKey('addTodoKey');
  static const updateTodoKey= ValueKey('updateTodoKey');
  static const addTodoFABKey= ValueKey('addTodoFABKey');
  static const editTodoKey= ValueKey('editTodoKey');
  static const deleteTodoKey= ValueKey('deleteTodoKey');
  static const shareTodoKey= ValueKey('shareTodoKey');
  static const popUpKey= ValueKey('popUpKey');

}

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String? isValidTitle(BuildContext context) {
    if (isEmpty) {
      return "Please enter title.";
    } else if (trim().length < 2) {
      return "Please enter valid title least 2 letters.";
    } else {
      return null;
    }
  }

  String? isValidDesc(BuildContext context) {
    if (isEmpty) {
      return "Please enter Description.";
    } else if (trim().length < 5) {
      return "Please enter valid Description least 5 letters.";
    } else {
      return null;
    }
  }
}
