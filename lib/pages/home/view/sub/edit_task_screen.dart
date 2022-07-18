import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/colorpicker/color_picker_builder.dart';
import '../../../../component/iconpicker/icon_picker_builder.dart';
import '../../../../models/todo/todo_model.dart';
import '../../../../networking/rest/task/task_provider.dart';
import '../../controller/home_controller.dart';

class EditTaskScreen extends StatefulWidget {
  final int taskId;
  final String taskName;
  final String description;
  final Color color;
  final IconData icon;

  EditTaskScreen({
    required this.taskId,
    required this.taskName,
    required this.description,
    required this.color,
    required this.icon,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditCardScreenState();
  }
}

class _EditCardScreenState extends State<EditTaskScreen> {
  late String taskName;
  late Color taskColor;
  late String description;
  late IconData taskIcon;
  late int taskId;

  final btnSaveTitle = "保存";
  final HomeController homeController = Get.put(HomeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    taskName = widget.taskName;
    taskColor = widget.color;
    taskIcon = widget.icon;
    taskId = widget.taskId;
    description = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '编辑',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black26,
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.symmetric(
          horizontal: 36.0,
          vertical: 36.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '调整任务内容',
              style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            Container(
              height: 16.0,
            ),
            TextFormField(
              initialValue: taskName,
              onChanged: (text) {
                setState(
                  () => taskName = text,
                );
              },
              maxLines: 2,
              cursorColor: taskColor,
              autofocus: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '任务名称',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  )),
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 22.0),
            ),
            Container(
              height: 26.0,
            ),
            TextFormField(
              initialValue: description,
              onChanged: (text) {
                setState(
                  () => description = text,
                );
              },
              maxLines: 3,
              cursorColor: taskColor,
              autofocus: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '任务描述',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  )),
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 18.0),
            ),
            Row(
              children: [
                ColorPickerBuilder(
                    color: taskColor,
                    onColorChanged: (newColor) => {
                          if (newColor == Colors.red)
                            {homeController.taskPriority(1)}
                          else if (newColor == Colors.yellow)
                            {homeController.taskPriority(2)}
                          else if (newColor == Colors.blue)
                            {homeController.taskPriority(3)}
                          else if (newColor == Colors.grey)
                            {homeController.taskPriority(4)}
                          else
                            {homeController.taskPriority(0)}
                        }),
                Container(
                  width: 22.0,
                ),
                IconPickerBuilder(
                  iconData: taskIcon,
                  highlightColor: taskColor,
                  action: (newIcon) => setState(
                    () => taskIcon = newIcon,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            heroTag: 'fab_new_card',
            icon: Icon(Icons.save),
            backgroundColor: taskColor,
            label: Text(btnSaveTitle),
            onPressed: () {
              if (taskName.isEmpty) {
                final snackBar = SnackBar(
                  content: Text('Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                  backgroundColor: taskColor,
                );
                Scaffold.of(context).showSnackBar(snackBar);
              } else {
                var todo = TodoTask(taskName,
                    parent: 0,
                    id: taskId,
                    schedule_time: DateTime.now().millisecondsSinceEpoch,
                    priority: homeController.taskPriority.value,
                    description: description);
                TaskProvider.updateTaskProperties(todo).then((value) => {homeController.updateTask(value), Navigator.pop(context)});
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
