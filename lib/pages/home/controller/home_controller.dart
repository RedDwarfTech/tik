import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../db/db_provider.dart';
import '../../../models/todo/todo_model.dart';
import '../../../networking/rest/task/todo_provider.dart';
import '../view/sub/edit_task_screen.dart';

class HomeController extends GetxController {
  List<Widget> newTaskList = List.empty(growable: true);
  List<Widget> completeTaskList = List.empty(growable: true);
  List<TodoTask> tasks = List.empty(growable: true);
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
  List<Widget> buildTodoItems(List<TodoTask> newTodos) {
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

  void buildSingleTask(TodoTask element, List<Widget> newTaskList,
      List<Widget> completeTaskList) {
    var card = Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: '删除',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () async => {
            if (await TaskProvider.removeTask(element)) {removeTodo(element)}
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
            TaskProvider.updateTask(element).then((value) => {
                  TaskProvider.getTasks()
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

  void updateTask(TodoTask todo) {
    tasks.forEach((element) {
      if (element.id == todo.id) {
        element.name = todo.name;
        buildTodoItems(tasks);
      }
    });
  }

  void addTodo(TodoTask todo) {
    var _db = DBProvider.db;
    _db.insertTodo(todo).then((value) => {
          _db.getAllTodo().then((value1) => {buildTodoItems(value1)})
        });
  }

  void removeLocalTodo(TodoTask todo) {
    newTaskList.obs.remove(todo);
  }

  void removeTodo(TodoTask todo) {
    TaskProvider.removeTask(todo).then((value) => {
          TaskProvider.getTasks().then((todos) => {buildTodoItems(todos)})
        });
  }

  void addTodos(List<TodoTask> todos) {
    var _db = DBProvider.db;
    _db.insertBulkTodo(todos).then((value) => {
          _db.getAllTodo().then((value1) => {buildTodoItems(value1)})
        });
  }
}
