import 'dart:collection';

import 'package:wheel/wheel.dart' show RestClient;

import '../../../models/todo/todo_model.dart';

class TaskProvider {
  static Future<bool> saveTask(TodoTask todo) async {
    Map todoParam = todo.toJson();
    var response = await RestClient.postHttp("/tik/task/v1/add", todoParam);
    if (RestClient.respSuccess(response)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<TodoTask>> getTasks() async {
    var response = await RestClient.getHttp("/tik/task/v1/list");
    if (RestClient.respSuccess(response)) {
      var todos = response.data["result"];
      List<TodoTask> todoList = List.empty(growable: true);
      todos.forEach((element) {
        var elementId = element["id"];
        TodoTask todo = new TodoTask(element["name"],
            id: elementId, parent: 0, isCompleted: element["is_complete"]);
        todoList.add(todo);
      });
      todoList.sort((a, b) => a.isCompleted.compareTo(b.isCompleted));
      return todoList;
    } else {
      return new List.empty();
    }
  }

  static Future<bool> removeTask(TodoTask todo) async {
    Map<String, Object> params = new HashMap();
    params.putIfAbsent("id", () => todo.id);
    var response = await RestClient.delete("/tik/task/v1/del", params);
    if (RestClient.respSuccess(response)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateTask(TodoTask todo) async {
    Map<String, Object> params = new HashMap();
    params.putIfAbsent("id", () => todo.id);
    params.putIfAbsent("is_complete", () => todo.isCompleted);
    var response = await RestClient.patch("/tik/task/v1/update", params);
    if (RestClient.respSuccess(response)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<TodoTask> updateTaskProperties(TodoTask todo) async {
    Map<String, Object> params = new HashMap();
    params.putIfAbsent("id", () => todo.id);
    params.putIfAbsent("name", () => todo.name);
    var response = await RestClient.patch("/tik/task/v1/update", params);
    if (RestClient.respSuccess(response)) {
      var updateResult = response.data["result"];
      TodoTask parsedTodo = TodoTask.fromJson(updateResult);
      return parsedTodo;
    } else {
      throw 'update task failed';
    }
  }
}
