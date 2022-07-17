import 'dart:collection';

import 'package:Tik/networking/rest/task/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel/wheel.dart';

import '../../models/todo/todo_model.dart';

class QuadrantController extends GetxController {
  List<TodoTask> tasks = List.empty(growable: true);

  @override
  void onInit() {
    getTodoTasks();
    super.onInit();
  }

  List<Widget> buildBoardItems(List<TodoTask> items) {
    List<Widget> widgets = new List.empty(growable: true);
    items.forEach((element) {
      var cards = SliverToBoxAdapter(
          child: LongPressDraggable(
        data: element,
        feedback: Container(
          height: 50,
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: Text(
            element.name,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          visualDensity: const VisualDensity(vertical: -4),
          horizontalTitleGap: -6,
          leading: Theme(
              data: ThemeData(),
              child: Checkbox(
                value: element.isCompleted == 1 ? true : false,
                onChanged: (bool? value) {},
              )),
          title: Text(element.name,
              style: element.isCompleted == 1 ? TextStyle(color: Colors.grey, fontSize: 16) : TextStyle(color: Colors.black, fontSize: 14),
              overflow: TextOverflow.ellipsis),
          selected: element.isCompleted == 1 ? true : false,
          onTap: () {},
        ),
      ));
      widgets.add(cards);
    });
    return widgets;
  }

  Widget buildListViewItemWidget(int index, List<TodoTask> items) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: CustomScrollView(
          slivers: buildBoardItems(items),
        ));
  }

  Map<int, String> getBoards() {
    Map<int, String> boardItem = new HashMap();
    boardItem.putIfAbsent(0, () => "重要且紧急");
    boardItem.putIfAbsent(1, () => "重要不紧急");
    boardItem.putIfAbsent(2, () => "不重要紧急");
    boardItem.putIfAbsent(3, () => "不重要不紧急");
    return boardItem;
  }

  void getTodoTasks() {
    if (tasks.isNotEmpty) {
      tasks.clear();
    }
    int monthStartMilliseconds = DateTimeUtils.startOfMonthMilliseconds(DateTime.now());
    int monthEndMilliseconds = DateTimeUtils.endOfMonthMilliseconds(DateTime.now());
    TaskProvider.getTasksByRangeDate(monthStartMilliseconds, monthEndMilliseconds).then((value) => {tasks.addAll(value), update()});
  }
}
