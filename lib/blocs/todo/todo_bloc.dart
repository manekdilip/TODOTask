import '../../utils/app_pages.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FireStoreService _firestoreService;
  final HiveDataStore dataStore = HiveDataStore();

  TodoBloc(this._firestoreService) : super(TodoInitial()) {
    ///To Get all the Local Todos
    on<LoadTodos>((event, emit) async {
      try {
        emit(TodoLoading());
        final todos = await dataStore.getAllTask();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError('Failed to load todos.'));
      }
    });

    ///To Get all the Remote DB Todos
    on<LoadFbTodos>((event, emit) async {
      try {
        emit(TodoLoading());
        final todosFb = await _firestoreService.getTodos();
        emit(TodoFbLoaded(todosFb));
        emit(TodoLoaded(todosFb));
      } catch (e) {
        emit(TodoError('Failed to load todos.'));
      }
    });

    ///To Add New Local Todos
    on<AddTodo>((event, emit) async {
      try {
        emit(TodoLoading());
        dataStore.addTask(task: event.todo);
        emit(TodoOperationSuccess('Todo added successfully.'));
      } catch (e) {
        emit(TodoError('Failed to add todo.'));
      }
    });

    ///To Update Existing Local Todos
    on<UpdateTodo>((event, emit) async {
      try {
        emit(TodoLoading());
        dataStore.updateTask(task: event.todo);
        emit(TodoOperationSuccess('Todo updated successfully.'));
      } catch (e) {
        emit(TodoError('Failed to update todo.'));
      }
    });

    ///To Sync Update Local Todos
    on<SyncTodo>((event, emit) async {
      try {
        emit(TodoLoading());
        for (var todo in event.todos) {
          final todoUpdate = Todo(
              id: todo.id,
              title: todo.title,
              description: todo.description,
              createdDT: todo.createdDT,
              updatedDT: todo.updatedDT,
              isCompleted: todo.isCompleted,
              isSynced: true);
          await _firestoreService.addTodo(todo);
          dataStore.updateTask(task: todoUpdate);
        }
        emit(TodoOperationSuccess('Todo updated successfully.'));
      } catch (e) {
        emit(TodoError('Failed to update todo.'));
      }
    });

    ///To Delete Local Todos
    on<DeleteTodo>((event, emit) async {
      try {
        emit(TodoLoading());
        dataStore.deleteTask(task: event.todo);
        await _firestoreService.deleteTodo(event.todo.id);
        emit(TodoOperationSuccess('Todo deleted successfully.'));
      } catch (e) {
        emit(TodoError('Failed to delete todo.'));
      }
    });
  }
}
