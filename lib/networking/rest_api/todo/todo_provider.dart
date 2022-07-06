import 'dart:collection';
import 'package:wheel/wheel.dart' show RestClient;
import '../../../models/todo/todo_model.dart';

class TodoProvider {
  static Future<bool> saveTodo(Todo todo) async {
    Map todoParam = todo.toJson();
    var response = await RestClient.postHttp("/tik/todo/v1/add", todoParam);
    if (RestClient.respSuccess(response)) {
      return true;
    }else{
      return false;
    }
  }

  static Future<List<Todo>> getTodos() async {
    var response = await RestClient.getHttp("/tik/todo/v1/list");
    if (RestClient.respSuccess(response)) {
      var todos = response.data["result"];
      List<Todo> todoList = List.empty(growable: true);
      todos.forEach((element) {
        Todo todo = new Todo(element["name"], parent: "111");
        todoList.add(todo);
      });
      return todoList;
    }else{
      return new List.empty();
    }
  }
}