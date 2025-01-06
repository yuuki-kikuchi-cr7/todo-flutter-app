import 'dart:math';

import 'package:hive/hive.dart';
import 'package:todo_flutter_app/models/todo_model.dart';
import 'package:todo_flutter_app/repositories/todos_repository.dart';

const double kProbabilityOfError = 0.5;
const int kDelayDuration = 1;

class HiveTodosRepository extends TodosRepository {
  final Box todoBox = Hive.box("todos");
  final Random random = Random();

  Future<void> waitSeconds() {
    return Future.delayed(const Duration(seconds: kDelayDuration));
  }

  @override
  Future<List<Todo>> getTodos() async {
    await waitSeconds();
    try {
      if (random.nextDouble() < kProbabilityOfError) {
        throw "Fail to retrive todos";
      }

      if (todoBox.length == 0) return [];

      return [
        for (final todo in todoBox.values)
          Todo.fromJson(Map<String, dynamic>.from(todo))
      ];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTodo({required Todo todo}) async {
    await waitSeconds();
    try {
      if (random.nextDouble() < kProbabilityOfError) {
        throw "Fail to add todo";
      }
      await todoBox.put(todo.id, todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editTodo({required String id, required String desc}) async {
    await waitSeconds();
    try {
      if (random.nextDouble() < kProbabilityOfError) {
        throw "Fail to edit todo";
      }
      final todoMap = todoBox.get(id);
      print(id);
      print(todoBox.values);
      todoMap["desc"] = desc;
      await todoBox.put(id, todoMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> toggleTodo({required String id}) async {
    await waitSeconds();
    try {
      if (random.nextDouble() < kProbabilityOfError) {
        throw "Fail to toggle todo";
      }
      final todoMap = todoBox.get(id);
      todoMap["completed"] = !todoMap["completed"];
      await todoBox.put(id, todoMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeTodo({required String id}) async {
    await waitSeconds();

    try {
      if (random.nextDouble() < kProbabilityOfError) {
        throw "Fail to edit todo";
      }

      await todoBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }
}
