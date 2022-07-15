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
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            element.name,
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12.0),
          ),
          value: true,
          onChanged: (bool? value) {},
        ),
      ));
      widgets.add(cards);
    });
    return widgets;
  }

  Widget buildListViewItemWidget(int index, List<TodoTask> items) {
    return Card(
      color: Colors.cyan[100 * (index % 9)],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: CustomScrollView(
        slivers: buildBoardItems(items),
      ),
    );
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
    int monthStartMilliseconds = DateTimeUtils.startOfMonthMilliseconds(DateTime.now());
    int monthEndMilliseconds = DateTimeUtils.endOfMonthMilliseconds(DateTime.now());
    TaskProvider.getTasksByRangeDate(monthStartMilliseconds, monthEndMilliseconds).then((value) => {tasks.addAll(value), update()});
  }
}
