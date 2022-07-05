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
}