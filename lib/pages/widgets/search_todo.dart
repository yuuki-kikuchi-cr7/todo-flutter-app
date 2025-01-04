import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_provider.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_state.dart';
import 'package:todo_flutter_app/pages/providers/todo_search/todo_search_provider.dart';
import 'package:todo_flutter_app/utils/debounce.dart';

class SearchTodo extends ConsumerStatefulWidget {
  const SearchTodo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchTodoState();
}

class _SearchTodoState extends ConsumerState<SearchTodo> {
  Widget prevWidget = const SizedBox.shrink();
  final debounce = Debounce(milliseconds: 1000);
  @override
  void dispose() {
    debounce.close();
    super.dispose();
  }

  bool enableOrNot(TodoListStatus status) {
    switch (status) {
      case TodoListStatus.failure when prevWidget is SizedBox:
      case TodoListStatus.loading || TodoListStatus.initial:
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
      enabled: enableOrNot(todoListState.status),
      decoration: const InputDecoration(
          labelText: "Search todos ...",
          border: InputBorder.none,
          filled: true,
          prefixIcon: Icon(Icons.search)),
      onChanged: (String? newSearchTerm) {
        if (newSearchTerm != null) {
          debounce.run(() {
            ref.read(todoSearchProvider.notifier).setSearchTerm(newSearchTerm);
          });
        }
      },
    );
  }
}
