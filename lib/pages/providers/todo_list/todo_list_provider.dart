import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_flutter_app/models/todo_model.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_state.dart';
import 'package:todo_flutter_app/repositories/providers/todos_repository_provider.dart';

part 'todo_list_provider.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  TodoListState build() {
    return TodoListState.initial();
  }

  Future<void> getTodos() async {
    state = state.copyWith(status: TodoListStatus.loading);

    try {
      final todos = await ref.read(todosRepositoryProvider).getTodos();
      state = state.copyWith(status: TodoListStatus.success, todos: todos);
    } catch (e) {
      state =
          state.copyWith(status: TodoListStatus.failure, error: e.toString());
    }
  }

  Future<void> addTodo(String desc) async {
    state = state.copyWith(status: TodoListStatus.loading);
    try {
      final newTodo = Todo.add(desc: desc);

      await ref.read(todosRepositoryProvider).addTodo(todo: newTodo);

      state = state.copyWith(
        status: TodoListStatus.success,
        todos: [...state.todos, newTodo],
      );
    } catch (e) {
      state = state.copyWith(
        status: TodoListStatus.failure,
        error: e.toString(),
      );
    }
  }

  Future<void> editTodo(String desc, String id) async {
    state = state.copyWith(status: TodoListStatus.loading);

    try {
      await ref.read(todosRepositoryProvider).editTodo(id: id, desc: desc);

      state = state.copyWith(
        status: TodoListStatus.success,
        todos: [
          for (final todo in state.todos)
            if (id == todo.id) todo.copyWith(desc: desc) else todo
        ],
      );
    } catch (e) {
      state = state.copyWith(
        status: TodoListStatus.failure,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleTodo(String id) async {
    state = state.copyWith(status: TodoListStatus.loading);

    try {
      await ref.read(todosRepositoryProvider).toggleTodo(id: id);

      state = state.copyWith(
        status: TodoListStatus.success,
        todos: [
          for (final todo in state.todos)
            if (id == todo.id)
              todo.copyWith(completed: !todo.completed)
            else
              todo
        ],
      );
    } catch (e) {
      state = state.copyWith(
        status: TodoListStatus.failure,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteTodo(String id) async {
    state = state.copyWith(status: TodoListStatus.loading);

    try {
      await ref.read(todosRepositoryProvider).removeTodo(id: id);
      state = state.copyWith(
        status: TodoListStatus.success,
        todos: [
          for (final todo in state.todos)
            if (id != todo.id) todo
        ],
      );
    } catch (e) {
      state = state.copyWith(
        status: TodoListStatus.failure,
        error: e.toString(),
      );
    }
  }
}
