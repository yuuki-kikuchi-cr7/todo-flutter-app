import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/pages/providers/active_todo_count/active_todo_count.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_provider.dart';

class TodoHeader extends ConsumerWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTodoCount = ref.watch(activeTodoCountProvider);
    final todos = ref.watch(todoListProvider).length;
    return Row(
      children: [
        const Text(
          "TODO",
          style: TextStyle(fontSize: 36.0),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "($activeTodoCount/$todos item${activeTodoCount != 1 ? "s" : ""} left)",
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.blue,
          ),
        )
      ],
    );
  }
}
