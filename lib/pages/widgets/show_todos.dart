import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/models/todo_model.dart';
//import 'package:todo_flutter_app/pages/providers/filtered_todos/filtered_todos_provider.dart';
import 'package:todo_flutter_app/pages/providers/todo_filter/todo_filter_provider.dart';
import 'package:todo_flutter_app/pages/providers/todo_item/todo_item_provider.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_provider.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_state.dart';
import 'package:todo_flutter_app/pages/providers/todo_search/todo_search_provider.dart';
import 'package:todo_flutter_app/pages/widgets/todo_item.dart';

class ShowTodos extends ConsumerStatefulWidget {
  const ShowTodos({super.key});

  @override
  ConsumerState<ShowTodos> createState() => _ShowTodosState();
}

class _ShowTodosState extends ConsumerState<ShowTodos> {
  Widget prevTodosWidget = const SizedBox.shrink();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(todoListProvider.notifier).getTodos();
    });
  }

  List<Todo> filterTodos(List<Todo> allTodos) {
    final filter = ref.watch(todoFilterProvider);
    final search = ref.watch(todoSearchProvider);

    List<Todo> tempTodo;

    tempTodo = switch (filter) {
      Filter.all => allTodos,
      Filter.active => allTodos.where((todo) => !todo.completed).toList(),
      Filter.completed => allTodos.where((todo) => todo.completed).toList()
    };

    if (search.isNotEmpty) {
      tempTodo = tempTodo
          .where(
              (todo) => todo.desc.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    return tempTodo;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TodoListState>(
      todoListProvider,
      (previus, next) {
        switch(next) {
          case TodoListStateFailure(error:String error):
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "Error",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  error,
                  textAlign: TextAlign.center,
                ),
              );
            },
          );
          case _:
        }
      },
    );
    final todoListState = ref.watch(todoListProvider);

    switch (todoListState) {
      case TodoListStateInitial():
        return const SizedBox.shrink();
      case TodoListStateLoading():
        return prevTodosWidget;
      case TodoListStateFailure(error:var error) when prevTodosWidget is SizedBox:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () {
                  ref.read(todoListProvider.notifier).getTodos();
                },
                child: const Text(
                  "Please Retry!",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        );
      case TodoListStateFailure(error: _):
        return prevTodosWidget;
      case TodoListStateSuccess(todos:var allTodos):
        final filteredTodos = filterTodos(allTodos);

        prevTodosWidget = ListView.separated(
          itemBuilder: (context, index) {
            final todo = filteredTodos[index];
            return ProviderScope(
              overrides: [todoItemProvider.overrideWithValue(todo)],
              child: const TodoItem(),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
          ),
          itemCount: filteredTodos.length,
        );

        return prevTodosWidget;
    }
  }
}
