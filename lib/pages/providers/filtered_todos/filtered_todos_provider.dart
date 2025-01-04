import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_flutter_app/models/todo_model.dart';
import 'package:todo_flutter_app/pages/providers/todo_filter/todo_filter_provider.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_provider.dart';
import 'package:todo_flutter_app/pages/providers/todo_search/todo_search_provider.dart';

part 'filtered_todos_provider.g.dart';

@riverpod
List<Todo> filteredTodos(FilteredTodosRef ref) {
  final todoListState = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);
  final search = ref.watch(todoSearchProvider);

  List<Todo> tempTodo;

  tempTodo = switch (filter) {
    Filter.all => todoListState.todos,
    Filter.active => todoListState.todos.where((todo) => !todo.completed).toList(),
    Filter.completed => todoListState.todos.where((todo) => todo.completed).toList()
  };

  if (search.isNotEmpty) {
    tempTodo = tempTodo
        .where((todo) => todo.desc.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
  return tempTodo;
}
