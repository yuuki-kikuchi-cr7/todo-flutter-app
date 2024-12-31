import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_app/models/todo_model.dart';
import 'package:todo_flutter_app/pages/providers/todo_list/todo_list_provider.dart';

class TodoItem extends ConsumerWidget {
  final Todo todo;
  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return ConfirmEditDialog(
                todo: todo,
              );
            });
      },
      leading: Checkbox(
        value: todo.completed,
        onChanged: (bool? checked) {
          ref.read(todoListProvider.notifier).toggleTodo(todo.id);
        },
      ),
      title: Text(todo.desc),
      trailing: IconButton(
        onPressed: () async {
          final removeOrNot = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("Are you sure"),
                content: const Text("Do you really want to delete?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          );
          if (removeOrNot == true) {
            ref.read(todoListProvider.notifier).deleteTodo(todo.id);
          }
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }
}

class ConfirmEditDialog extends ConsumerStatefulWidget {
  final Todo todo;
  const ConfirmEditDialog({
    super.key,
    required this.todo,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmEditDialogState();
}

class _ConfirmEditDialogState extends ConsumerState<ConfirmEditDialog> {
  late final TextEditingController textEditingController;
  bool error = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.todo.desc);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Todo"),
      content: TextField(
        controller: textEditingController,
        autofocus: true,
        decoration:
            InputDecoration(errorText: error ? "Value can not be empty" : ""),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            error = textEditingController.text.isEmpty ? true : false;
            if (error == true) {
              setState(() {});
            } else {
              ref
                  .read(todoListProvider.notifier)
                  .editTodo(textEditingController.text, widget.todo.id);
              Navigator.pop(context);
            }
          },
          child: const Text("EDIT"),
        ),
      ],
    );
  }
}
