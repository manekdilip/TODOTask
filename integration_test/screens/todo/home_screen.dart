import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/utils/app_pages.dart';

class TodoHomeScreen {
  late WidgetTester tester;

  TodoHomeScreen(this.tester);

  final _addTodoIconLocator = find.byKey(AppStrings.addTodoFABKey);
  final _todoTitleTextField = find.byKey(AppStrings.addTitleKey);
  final _todoDescriptionTextField = find.byKey(AppStrings.addDescKey);
  final _addTodoButton = find.byKey(AppStrings.addTodoKey);

  Finder todoLocator = find.byKey(AppStrings.addTodoFABKey);
  final popUpButtonLocator = find.byKey(AppStrings.popUpKey);
  final editButtonLocator = find.byKey(AppStrings.editTodoKey);
  final _updateTitleTextField = find.byKey(AppStrings.updateTitleKey);
  final _todoUpdateTextField = find.byKey(AppStrings.updateDescKey);
  final _updateTodoButton = find.byKey(AppStrings.updateTodoKey);


  Future<void> addTodo(String title, String description) async {
    await tester.tap(_addTodoIconLocator, warnIfMissed: true);
    await tester.pumpAndSettle();
    await tester.enterText(_todoTitleTextField, title);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.enterText(_todoDescriptionTextField, title);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.tap(_addTodoButton, warnIfMissed: true);
    await tester.pumpAndSettle();
  }

  Future<void> updateTodo(String updateTitle, String updateDesc) async {
    await tester.tap(todoLocator, warnIfMissed: true);
    await tester.pumpAndSettle();
    await tester.tap(popUpButtonLocator, warnIfMissed: true);
    await tester.pumpAndSettle();
    await tester.tap(editButtonLocator, warnIfMissed: true);
    await tester.pumpAndSettle();
    await tester.enterText(_updateTitleTextField, updateTitle);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.enterText(_todoUpdateTextField, updateDesc);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.tap(_updateTodoButton, warnIfMissed: true);
    await tester.pumpAndSettle();
  }

  Future<bool> isTodoPresent(String title) async {
      todoLocator = find.descendant(of: find.byType(CustomTile), matching: find.text(title));
    return tester.any(todoLocator);
  }

  Future<bool> isTodoUpdated(String title) async {
    todoLocator = find.descendant(of: find.byType(CustomTile), matching: find.text(title));
    return tester.any(todoLocator);
  }

}