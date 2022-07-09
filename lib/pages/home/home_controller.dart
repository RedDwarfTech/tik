import 'package:Tik/networking/rest_api/todo/todo_provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../db/db_provider.dart';
import '../../models/todo/todo_model.dart';
import 'edit_task_screen.dart';

class HomeController extends GetxController {
  List<Widget> newTaskList = List.empty(growable: true);
  List<Widget> completeTaskList = List.empty(growable: true);
  List<Todo> tasks = List.empty(growable: true);
  var newTaskExpanded = true.obs;
  var completedTaskExpanded = false.obs;

  @override
  void onInit() {
    var _db = DBProvider.db;
    _db.getAllTodo().then((value) => {tasks.addAll(value), addTodos(value)});
    super.onInit();
  }

  /**
   * why using List + Checkbox?
   * https://stackoverflow.com/questions/72905465/is-it-possible-to-know-trigger-checkbox-or-item-text-when-using-checkboxlisttile
   */
  List<Widget> buildTodoItems(List<Todo> newTodos) {
    List<Widget> newTasks = new List.empty(growable: true);
    List<Widget> completedTasks = new List.empty(growable: true);
    newTodos.forEach((element) {
      buildSingleTask(element, newTasks, completedTasks);
    });
    newTaskList = newTasks;
    completeTaskList = completedTasks;
    update();
    return newTasks;
  }

  void buildSingleTask(
      Todo element, List<Widget> newTaskList, List<Widget> completeTaskList) {
    var card = Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: '删除',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () async => {
            if (await TodoProvider.removeTodo(element)) {removeTodo(element)}
          },
        ),
      ],
      child: ListTile(
        leading: Checkbox(
          value: element.isCompleted == 1 ? true : false,
          onChanged: (bool? value) {
            if (value!) {
              element.isCompleted = 1;
            } else {
              element.isCompleted = 0;
            }
            TodoProvider.updateTodo(element).then((value) => {
                  TodoProvider.getTodos()
                      .then((todos) => {buildTodoItems(todos)})
                });
          },
        ),
        title: Text(element.name,
            style: element.isCompleted == 1
                ? TextStyle(color: Colors.grey)
                : TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis),
        selected: element.isCompleted == 1 ? true : false,
        onTap: () {
          Get.to(EditTaskScreen(
            taskId: element.id,
            color: Colors.green,
            icon: EvaIcons.edit,
            taskName: element.name,
          ));
        },
      ),
    );
    if (element.isCompleted == 1) {
      completeTaskList.add(card);
    } else {
      newTaskList.add(card);
    }
  }

  void updateTask(Todo todo) {
    tasks.forEach((element) {
      if (element.id == todo.id) {
        element.name = todo.name;
        buildTodoItems(tasks);
      }
    });
  }

  void addTodo(Todo todo) {
    var _db = DBProvider.db;
    _db.insertTodo(todo).then((value) => {
          _db.getAllTodo().then((value1) => {buildTodoItems(value1)})
        });
  }

  void removeLocalTodo(Todo todo) {
    newTaskList.obs.remove(todo);
  }

  void removeTodo(Todo todo) {
    TodoProvider.removeTodo(todo).then((value) => {
          TodoProvider.getTodos().then((todos) => {buildTodoItems(todos)})
        });
  }

  void addTodos(List<Todo> todos) {
    var _db = DBProvider.db;
    _db.insertBulkTodo(todos).then((value) => {
          _db.getAllTodo().then((value1) => {buildTodoItems(value1)})
        });
  }
}
