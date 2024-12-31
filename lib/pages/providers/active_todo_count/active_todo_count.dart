import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_provider.dart';

part 'active_todo_count.g.dart';

@riverpod
int activeTodoCount(ActiveTodoCountRef ref) {
  final todos = ref.watch(todoListProvider);
  return todos.where((todo)=>!todo.completed).toList().length;
}

