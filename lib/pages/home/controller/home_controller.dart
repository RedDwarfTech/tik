import 'package:Tik/models/todo/todo_list_model.dart';
import 'package:Tik/networking/rest/list/todo_list_provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../db/db_provider.dart';
import '../../../models/todo/todo_model.dart';
import '../../../networking/rest/task/task_provider.dart';
import '../view/sub/edit_task_screen.dart';

class HomeController extends GetxController {
  List<Widget> newTaskList = List.empty(growable: true);
  List<Widget> completeTaskList = List.empty(growable: true);
  List<TodoTask> tasks = List.empty(growable: true);
  var newTaskExpanded = true.obs;
  var completedTaskExpanded = false.obs;
  var activeTodoList = null;

  List<TodoList> todoLists = List.empty(growable: true);
  List<Widget> todoListWidgets = List.empty(growable: true);

  @override
  void onInit() {
    initTodoList();
    super.onInit();
  }

  void initTodoList() {
    todoLists.clear();
    TodoListProvider.getTodos().then((value) => {todoLists.addAll(value), buildTodoListItems(), initTasks(value)});
  }

  void initTasks(List<TodoList> todoList) {
    // find the default list
    var defaultTodoList = todoList.where((element) => element.is_default == 1).toList();
    var _db = DBProvider.db;
    activeTodoList = defaultTodoList[0];
    _db.getAllTodo(defaultTodoList[0].id).then((value) => {tasks.addAll(value), buildTaskItems(value)});
  }

  List<Widget> buildTodoListItems() {
    List<Widget> completedTasks = new List.empty(growable: true);
    todoLists.forEach((element) {
      buildSingleTodo(element, completedTasks);
    });
    todoListWidgets = completedTasks;
    var btn = ElevatedButton.icon(
        onPressed: () {
          Get.dialog(AlertDialog(
              content: Column(children: [
            Text("name:"),
            ElevatedButton(
              child: Text('添加'),
              onPressed: () => {
                TodoListProvider.saveTodo(
                        new TodoList("test", id: 1, node_type: 1, parent_id: 0, color: 0, is_default: 0))
                    .then((value) => {initTodoList()})
              },
              // ** result: returns this value up the call stack **
            ),
          ])));
        },
        icon: Icon(
          // <-- Icon
          Icons.add,
          size: 24.0,
        ),
        label: Text('添加清单'));
    todoListWidgets.add(btn);
    update();
    return completedTasks;
  }

  /**
   * why using List + Checkbox?
   * https://stackoverflow.com/questions/72905465/is-it-possible-to-know-trigger-checkbox-or-item-text-when-using-checkboxlisttile
   */
  List<Widget> buildTaskItems(List<TodoTask> tasks) {
    List<Widget> newTasks = new List.empty(growable: true);
    List<Widget> completedTasks = new List.empty(growable: true);
    tasks.forEach((element) {
      buildSingleTask(element, newTasks, completedTasks);
    });
    newTaskList = newTasks;
    completeTaskList = completedTasks;
    update();
    return newTasks;
  }

  void buildSingleTodo(TodoList element, List<Widget> completedTasks) {
    var tile = Slidable(
        actionPane: SlidableDrawerActionPane(),
        actions: <Widget>[
          IconSlideAction(
            caption: '删除',
            color: Colors.blue,
            icon: Icons.archive,
            onTap: () async => {removeTodo(element)},
          ),
        ],
        child: ListTile(
          title: Text(element.name),
          onTap: () {
            // Update the state of the app.
            loadCurrentTodoListTasks(element);
          },
        ));
    completedTasks.add(tile);
  }

  void loadCurrentTodoListTasks(TodoList element) {
    activeTodoList = element;
    TaskProvider.getTasks(element.id).then((value) => {tasks.clear(), tasks.addAll(value), buildTaskItems(value)});
  }

  void buildSingleTask(TodoTask element, List<Widget> newTaskList, List<Widget> completeTaskList) {
    var card = Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: '删除',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () async => {removeTask(element)},
        ),
      ],
      child: ListTile(
        leading: Checkbox(
          value: element.isCompleted == 1 ? true : false,
          onChanged: (bool? value) {
            if (value!) {
              element.isCompleted = 1;
              element.complete_time = DateTime.now().millisecondsSinceEpoch;
            } else {
              element.isCompleted = 0;
            }
            TaskProvider.updateTask(element).then((value) => {
                  TaskProvider.getTasks(element.parent).then((todos) => {buildTaskItems(todos)})
                });
          },
        ),
        title: Text(element.name,
            style: element.isCompleted == 1 ? TextStyle(color: Colors.grey) : TextStyle(color: Colors.black),
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
        buildTaskItems(tasks);
      }
    });
  }

  void addTodo(TodoTask todo) {
    var _db = DBProvider.db;
    _db.insertTodo(todo).then((value) => {
          _db.getAllTodo(todo.parent).then((value1) => {buildTaskItems(value1)})
        });
  }

  void removeLocalTodo(TodoTask todo) {
    newTaskList.obs.remove(todo);
  }

  void removeTask(TodoTask todo) {
    TaskProvider.removeTask(todo).then((value) => {
          TaskProvider.getTasks(todo.parent).then((todos) => {buildTaskItems(todos)})
        });
  }

  void removeTodo(TodoList todo) {
    TodoListProvider.removeTodo(todo).then((value) => {initTodoList()});
  }
}
