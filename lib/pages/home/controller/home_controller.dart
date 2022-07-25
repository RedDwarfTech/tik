import 'package:Tik/models/todo/todo_list_model.dart';
import 'package:Tik/networking/rest/list/todo_list_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:wheel/wheel.dart';

import '../../../db/db_provider.dart';
import '../../../includes.dart';
import '../../../models/todo/todo_model.dart';
import '../../../networking/rest/task/task_provider.dart';
import '../../calendar/controller/calendar_controller.dart';
import '../view/sub/edit_task_screen.dart';

class HomeController extends GetxController {
  List<Widget> newTaskList = List.empty(growable: true);
  List<Widget> completeTaskList = List.empty(growable: true);
  List<Widget> expiredTaskList = List.empty(growable: true);
  List<TodoTask> tasks = List.empty(growable: true);
  var newTaskExpanded = true.obs;
  var expiredTaskExpanded = false.obs;
  var completedTaskExpanded = false.obs;
  var activeTodoList = null;
  var taskPriority = 0.obs;

  // to do list
  var todoListName = "".obs;

  List<TodoList> todoLists = List.empty(growable: true);
  List<Widget> todoListWidgets = List.empty(growable: true);
  final CalendarController calendarController = Get.put(CalendarController());

  @override
  void onInit() {
    initTodoList();
    calendarController.initialTasks();
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
            TextField(
              decoration: InputDecoration(hintText: "输入清单名称"),
              onChanged: (text) {
                todoListName.value = text;
              },
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('文件夹'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  )
                ],
              ),
            ),
            ElevatedButton(
              child: Text('添加'),
              onPressed: () => {
                TodoListProvider.saveTodo(new TodoList(todoListName.value, id: 1, node_type: 1, parent_id: 0, color: 0, is_default: 0))
                    .then((value) => {initTodoList(), Get.back(closeOverlays: false)})
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
    List<Widget> expiredTasks = new List.empty(growable: true);
    List<TodoTask> newElements =
        tasks.where((element) => element.isCompleted != 1 && DateTimeUtils.isToday(element.schedule_time)).toList();
    newElements.sort((a, b) => b.schedule_time.compareTo(a.schedule_time));
    List<TodoTask> completeElements = tasks.where((element) => element.isCompleted == 1).toList();
    List<TodoTask> expiredElements =
        tasks.where((element) => element.isCompleted != 1 && !DateTimeUtils.isToday(element.schedule_time)).toList();
    newElements.forEach((element) {
      buildSingleTask(element, newTasks);
    });
    completeElements.forEach((element) {
      buildSingleTask(element, completedTasks);
    });
    expiredElements.forEach((element) {
      buildSingleTask(element, expiredTasks);
    });
    newTaskList = newTasks;
    completeTaskList = completedTasks;
    expiredTaskList = expiredTasks;
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

  Future<void> playDoneAudio(TodoTask todoTask) async {
    if (todoTask.isCompleted == 1) {
      AudioPlayer audioPlayer = new AudioPlayer();
      audioPlayer.setSourceAsset("audio/done.mp3");
      audioPlayer.resume();
    }
  }

  void buildSingleTask(TodoTask element, List<Widget> taskList) {
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
        horizontalTitleGap: -5,
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
                      playDoneAudio(element),
                      TaskProvider.getTasks(element.parent).then((todos) => {
                            buildTaskItems(todos),
                          })
                    });
              },
            )),
        title: Text(element.name,
            style: element.isCompleted == 1 ? TextStyle(color: Colors.grey) : TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis),
        selected: element.isCompleted == 1 ? true : false,
        onTap: () {
          Get.to(() => EditTaskScreen(
                taskId: element.id,
                color: Colors.green,
                icon: EvaIcons.edit,
                taskName: element.name,
                description: element.description ?? "",
              ));
        },
      ),
    );
    taskList.add(card);
  }

  void updateTask(TodoTask todo) {
    tasks.forEach((element) {
      if (element.id == todo.id) {
        element.name = todo.name;
        element.description = todo.description;
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
    TaskProvider.removeTask(todo).then((value) => {handleTaskRemoved(todo)});
  }

  void handleTaskRemoved(TodoTask task) {
    // remove calendar
    DateTime scheduleTime = DateTime.fromMillisecondsSinceEpoch(task.schedule_time);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String dateString = formatter.format(scheduleTime);
    calendarController.taskMap[dateString]?.removeWhere((element) => element.id == task.id);
    TaskProvider.getTasks(task.parent).then((todos) => {buildTaskItems(todos)});
  }

  void removeTodo(TodoList todo) {
    TodoListProvider.removeTodo(todo).then((value) => {initTodoList()});
  }
}
