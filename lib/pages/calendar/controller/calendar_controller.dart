import 'package:Tik/models/todo/todo_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:wheel/wheel.dart';

import '../../../db/db_provider.dart';
import '../../../includes.dart';
import '../../../models/todo/todo_model.dart';
import '../../../networking/rest/task/task_provider.dart';

class CalendarController extends GetxController {
  List<Widget> newTaskList = List.empty(growable: true);
  List<Widget> completeTaskList = List.empty(growable: true);
  List<TodoTask> tasks = List.empty(growable: true);
  var newTaskExpanded = true.obs;
  var completedTaskExpanded = false.obs;
  var activeTodoList = null;
  var taskPriority = 0.obs;

  List<TodoList> todoLists = List.empty(growable: true);
  List<Widget> todoListWidgets = List.empty(growable: true);

  @override
  void onInit() {
    initTasks();
    super.onInit();
  }

  void initTasks() {
    int monthStartMilliseconds = DateTimeUtils.startOfMonthMilliseconds(DateTime.now());
    int monthEndMilliseconds = DateTimeUtils.endOfMonthMilliseconds(DateTime.now());
    TaskProvider.getTasksByRangeDate(monthStartMilliseconds, monthEndMilliseconds)
        .then((value) => {tasks.addAll(value), buildTaskItems(value)});
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
              onPressed: () => {},
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
    List<TodoTask> newElements = tasks.where((element) => element.isCompleted != 1).toList();
    newElements.sort((a, b) => b.schedule_time.compareTo(a.schedule_time));
    List<TodoTask> completeElements = tasks.where((element) => element.isCompleted == 1).toList();
    newElements.forEach((element) {
      buildSingleTask(element, newTasks, completedTasks);
    });
    completeElements.forEach((element) {
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
            onTap: () async => {},
          ),
        ],
        child: ListTile(
            title: Text(element.name),
            onTap: () {
              // Update the state of the app.
              loadCurrentTodoListTasks(element);
            }));
    completedTasks.add(tile);
  }

  void loadCurrentTodoListTasks(TodoList element) {
    activeTodoList = element;
    TaskProvider.getTasks(element.id).then((value) => {tasks.clear(), tasks.addAll(value), buildTaskItems(value)});
  }

  String getTaskTime(TodoTask element) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    DateTime dateToCheck = new DateTime.fromMicrosecondsSinceEpoch(element.schedule_time * 1000);
    final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (aDate == today) {
      return "今天";
    } else if (aDate == yesterday) {
      return "昨天";
    } else if (aDate == tomorrow) {
      return "明天";
    } else {
      var d24 = DateFormat('yyyy-MM-dd').format(dateToCheck);
      return d24;
    }
  }

  Color getCheckBoxColor(TodoTask element) {
    if (element.priority == 1) {
      return Colors.red;
    } else if (element.priority == 2) {
      return Colors.yellow;
    } else if (element.priority == 3) {
      return Colors.blue;
    } else if (element.priority == 4) {
      return Colors.grey;
    } else {
      return Colors.black;
    }
  }

  void buildSingleTask(TodoTask element, List<Widget> newTaskList, List<Widget> completeTaskList) {
    var scheduleTime = getTaskTime(element);
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
        trailing: Text(
          scheduleTime,
          style: new TextStyle(color: Colors.blue),
        ),
        leading: Theme(
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: getCheckBoxColor(element),
            ),
            child: Checkbox(
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
            )),
        title: Text(element.name,
            style: element.isCompleted == 1 ? TextStyle(color: Colors.grey) : TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis),
        selected: element.isCompleted == 1 ? true : false,
        onTap: () {},
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
}
