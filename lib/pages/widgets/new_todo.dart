import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_provider.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_state.dart';

class NewTodo extends ConsumerStatefulWidget {
  const NewTodo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewTodoState();
}

class _NewTodoState extends ConsumerState<NewTodo> {
  final newTodoController = TextEditingController();
  Widget prevWidget = const SizedBox.shrink();

  @override
  void dispose() {
    super.dispose();
    newTodoController.dispose();
  }

  bool enableOrNot(TodoListState state){
    switch(state){
      case TodoListStateFailure(error:_) when prevWidget is SizedBox:
      case TodoListStateLoading() || TodoListStateInitial():
      return false;
      case _:
      prevWidget = Container();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoListState = ref.watch(todoListProvider);
    return TextField(
      enabled: enableOrNot(todoListState),
      controller: newTodoController,
      decoration: const InputDecoration(
        labelText: "What to do",
      ),
      onSubmitted: (String? desc) {
        if (desc != null && desc.trim().isNotEmpty) {
          ref.read(todoListProvider.notifier).addTodo(desc);
          newTodoController.clear();
        }
      },
    );
  }
}
