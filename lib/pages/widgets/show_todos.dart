import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/pages/providers/filtered_todos/filtered_todos_provider.dart';
import 'package:todo_flutter_app/pages/widgets/todo_item.dart';

class ShowTodos extends ConsumerWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTodos = ref.watch(filteredTodosProvider);
    return ListView.separated(
      itemBuilder: (context, index) {
        final todo = filteredTodos[index];
        return TodoItem(todo: todo);
      },
      separatorBuilder: (context, index) => const Divider(color: Colors.grey,),
      itemCount: filteredTodos.length,
    );
  }
}
