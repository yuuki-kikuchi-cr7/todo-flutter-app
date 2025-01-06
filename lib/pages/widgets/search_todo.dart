import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/models/todo_model.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_provider.dart';
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

  bool enableOrNot(AsyncValue<List<Todo>> state) {
    return state.when(
      data: (_){
        prevWidget = Container();
        return true;
      },
      error: (_,__)=> prevWidget is SizedBox ?false : true,
      loading: ()=> false,
    );
    
  }

  @override
  Widget build(BuildContext context) {
    final todoListState = ref.watch(todoListProvider);
    return TextField(
      enabled: enableOrNot(todoListState),
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
