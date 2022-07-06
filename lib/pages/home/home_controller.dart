import 'package:Tik/networking/rest_api/todo/todo_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../db/db_provider.dart';
import '../../models/todo/todo_model.dart';

class HomeController extends GetxController {
  var count = 0.obs;

  increment() => count++;

  List<Widget> widgetsList = List.empty(growable: true);

  @override
  void onInit() {
    // TODO: implement onInit
    var _db = DBProvider.db;
    _db.getAllTodo().then((value) => {addTodos(value)});
    super.onInit();
  }

  List<Widget> buildTodoItems(List<Todo> newTodos) {
    List<Widget> widgets = new List.empty(growable: true);
    newTodos.forEach((element) {
      var card = SizedBox(
          height: 50,
          child: Card(
        child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: '删除',
                color: Colors.blue,
                icon: Icons.archive,
                onTap: () async => {
                  if(await TodoProvider.removeTodo(element)){
                    removeTodo(element)
                  }
                },
              ),
            ],
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(element.name,style:element.isCompleted == 1? TextStyle(color: Colors.grey):TextStyle(color: Colors.black)),
              value: element.isCompleted == 1?true:false,
              checkColor: Colors.green,
              selected: element.isCompleted == 1?true:false,
              onChanged: (bool? value) {
                if(value!){
                  element.isCompleted = 1;
                }else{
                  element.isCompleted = 0;
                }
                TodoProvider.updateTodo(element).then((value) => {
                  TodoProvider.getTodos().then((todos) => {
                    buildTodoItems(todos)
                  })
                });
              },
            )),
      ));
      widgets.add(card);
    });
    widgetsList = widgets;
    update();
    return widgets;
  }

  void addTodo(Todo todo) {
    var _db = DBProvider.db;
    _db.insertTodo(todo).then((value) => {
          _db.getAllTodo().then((value1) => {buildTodoItems(value1)})
        });
  }

  void removeLocalTodo(Todo todo){
    widgetsList.obs.remove(todo);
  }

  void removeTodo(Todo todo) {
    TodoProvider.removeTodo(todo).then((value) => {
      TodoProvider.getTodos().then((todos) => {
        buildTodoItems(todos)
    })
    });
  }

  void addTodos(List<Todo> todos) {
    var _db = DBProvider.db;
    _db.insertBulkTodo(todos).then((value) => {
      _db.getAllTodo().then((value1) => {buildTodoItems(value1)})
    });
  }

}
