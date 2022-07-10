import 'package:Tik/models/todo/todo_model.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../component/todo_badge.dart';
import '../../../../models/hero_id_model.dart';
import '../../../../models/todo/task_model.dart';
import 'add_todo_screen.dart';
import 'edit_task_screen.dart';

class DetailScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroIds;

  DetailScreen({
    required this.taskId,
    required this.heroIds,
  });

  @override
  State<StatefulWidget> createState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0.0, 0.0)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    Task _task = new Task("", color: 123, codePoint: 12, id: 0);

    try {
      //_task = model.tasks.firstWhere((it) => it.id == widget.taskId);
    } catch (e) {
      return Container(
        color: Colors.white,
      );
    }
    List<TodoTask> todos = new List.empty(growable: true);
    var _todos = todos;
    var _hero = widget.heroIds;
    var _color = Colors.green;
    var _icon = EvaIcons.activity;

    return Theme(
      data: ThemeData(primarySwatch: _color),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black26),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              color: _color,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(
                      taskId: _task.id,
                      taskName: _task.name,
                      icon: _icon,
                      color: _color,
                    ),
                  ),
                );
              },
            ),
            SimpleAlertDialog(
              color: _color,
              onActionPressed: () => {},
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Column(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 36.0, vertical: 0.0),
              height: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TodoBadge(
                    color: _color,
                    codePoint: _task.codePoint,
                    id: _hero.codePointId,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Hero(
                      tag: _hero.remainingTaskId,
                      child: Text(
                        " Task",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  Container(
                    child: Hero(
                      tag: 'title_hero_unused', //_hero.titleId,
                      child: Text(_task.name,
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.black54)),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _todos.length) {
                      return SizedBox(
                        height: 56, // size of FAB
                      );
                    }
                    var todo = _todos[index];
                    return Container(
                      padding: EdgeInsets.only(left: 22.0, right: 22.0),
                      child: ListTile(
                        onTap: () => {
                          //model.updateTodo(todo.copy(isCompleted: todo.isCompleted == 1 ? 0 : 1))
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                        leading: Checkbox(
                            onChanged: (value) => {
                                  //model.updateTodo(todo.copy(isCompleted: value == true ? 1 : 0))
                                },
                            value: todo.isCompleted == 1 ? true : false),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () => {},
                        ),
                        title: Text(
                          todo.name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: todo.isCompleted == 1 ? _color : Colors.black54,
                            decoration: todo.isCompleted == 1 ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _todos.length + 1,
                ),
              ),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'fab_new_task',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodoScreen(taskId: widget.taskId, heroIds: _hero),
              ),
            );
          },
          tooltip: 'New Todo',
          backgroundColor: _color,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

typedef void Callback();

class SimpleAlertDialog extends StatelessWidget {
  final Color color;
  final Callback onActionPressed;

  SimpleAlertDialog({
    required this.color,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      icon: Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete this card?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('This is a one way street! Deleting this will remove all the task assigned in this card.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    onActionPressed();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
