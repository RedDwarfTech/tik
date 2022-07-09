import 'dart:collection';

import 'package:wheel/wheel.dart' show RestClient;

import '../../../models/todo/todo_list_model.dart';

class TodoListProvider {
  static Future<bool> saveTodo(TodoList todo) async {
    Map todoParam = todo.toJson();
    var response = await RestClient.postHttp("/tik/todo/v1/add", todoParam);
    if (RestClient.respSuccess(response)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<TodoList>> getTodos() async {
    var response = await RestClient.getHttp("/tik/todo/v1/list");
    if (RestClient.respSuccess(response)) {
      var todos = response.data["result"];
      List<TodoList> todoList = List.empty(growable: true);
      todos.forEach((element) {
        TodoList todo = TodoList.fromJson(element);
        todoList.add(todo);
      });
      return todoList;
    } else {
      return new List.empty();
    }
  }

  static Future<bool> removeTodo(TodoList todo) async {
    Map<String, Object> params = new HashMap();
    params.putIfAbsent("id", () => todo.id);
    var response = await RestClient.delete("/tik/todo/v1/del", params);
    if (RestClient.respSuccess(response)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateTodo(TodoList todo) async {
    Map<String, Object> params = new HashMap();
    params.putIfAbsent("id", () => todo.id);
    var response = await RestClient.patch("/tik/todo/v1/update", params);
    if (RestClient.respSuccess(response)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<TodoList> updateTodoProperties(TodoList todo) async {
    Map<String, Object> params = new HashMap();
    params.putIfAbsent("id", () => todo.id);
    params.putIfAbsent("name", () => todo.name);
    var response = await RestClient.patch("/tik/todo/v1/update", params);
    if (RestClient.respSuccess(response)) {
      var updateResult = response.data["result"];
      TodoList parsedTodo = TodoList.fromJson(updateResult);
      return parsedTodo;
    } else {
      throw 'update task failed';
    }
  }
}
