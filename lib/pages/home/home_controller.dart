import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../db/db_provider.dart';
import '../../models/todo/todo_model.dart';

class HomeController extends GetxController{
  var count = 0.obs;
  increment() => count++;

  @override
  void onInit() {
    // TODO: implement onInit
    var _db = DBProvider.db;
    _db.getAllTodo().then((value) => {
     addTodos(value)
    });
    super.onInit();
  }

  List<Widget> buildTodoItems() {
    List<Widget> widgets = new List.empty(growable: true);
    toDos.obs.forEach((element) {
      var card = Card(
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(element.name),
          value: true,
          onChanged: (bool? value) {},
        ),
      );
      widgets.add(card);
    });
    return widgets;
  }

  List<Todo> toDos = List.empty(growable: true);

  void addTodo(Todo todo){
    toDos.add(todo);
    update();
    buildTodoItems();
  }

  void addTodos(List<Todo> todos){
    toDos.addAll(todos);
    update();
  }

}



