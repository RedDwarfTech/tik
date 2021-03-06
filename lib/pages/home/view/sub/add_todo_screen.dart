import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/todo_badge.dart';
import '../../../../models/hero_id_model.dart';
import '../../../../models/todo/todo_model.dart';
import '../../../../networking/rest/task/task_provider.dart';
import '../../../calendar/controller/calendar_controller.dart';
import '../../controller/home_controller.dart';

class AddTodoScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroIds;

  AddTodoScreen({
    required this.taskId,
    required this.heroIds,
  });

  @override
  State<StatefulWidget> createState() {
    return _AddTodoScreenState();
  }
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late String newTask;
  String description = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    newTask = '';
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final CalendarController calendarController = Get.put(CalendarController());

    void handleLocal(TodoTask todo) {
      TaskProvider.getTasks(todo.parent).then((value) => {homeController.buildTaskItems(value), Navigator.pop(context)});
    }

    void handleSavedTask(TodoTask task) {
      handleLocal(task);
      DateTime scheduleTime = DateTime.fromMillisecondsSinceEpoch(task.schedule_time);
      calendarController.putTasks(task, scheduleTime);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '新任务',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black26),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '想要完成什么事项呢？',
              style: TextStyle(color: Colors.black38, fontWeight: FontWeight.w600, fontSize: 16.0),
            ),
            Container(
              height: 16.0,
            ),
            TextField(
              onChanged: (text) {
                setState(() => newTask = text);
              },
              maxLines: 2,
              //cursorColor: _color,
              autofocus: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '输入任务内容',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  )),
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 22.0),
            ),
            Container(
              height: 26.0,
            ),
            TextField(
              onChanged: (text) {
                setState(() => description = text);
              },
              maxLines: 3,
              //cursorColor: _color,
              autofocus: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '输入任务描述(可选)',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  )),
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 18.0),
            ),
            Row(
              children: [
                TodoBadge(
                  codePoint: 1,
                  color: const Color(0xff666666),
                  id: widget.heroIds.codePointId,
                  size: 20.0,
                ),
                Container(
                  width: 16.0,
                ),
                Hero(
                  child: Text(
                    "dgwegwhewh",
                    style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  tag: "not_using_right_now", //widget.heroIds.titleId,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            heroTag: 'fab_new_task',
            icon: Icon(Icons.add),
            label: Text('Create Task'),
            onPressed: () {
              if (newTask.isEmpty) {
                final snackBar = SnackBar(
                  content: Text('Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              } else {
                var todo = TodoTask(newTask,
                    parent: homeController.activeTodoList.id,
                    schedule_time: DateTime.now().millisecondsSinceEpoch,
                    priority: 4,
                    description: description);
                TaskProvider.saveTask(todo).then((value) => {handleSavedTask(value)});
              }
            },
          );
        },
      ),
    );
  }
}

// Reason for wraping fab with builder (to get scafold context)
// https://stackoverflow.com/a/52123080/4934757
