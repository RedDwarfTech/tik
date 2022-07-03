import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/todo_item.dart';
import 'dev_word_controller.dart';

class Quadrant extends StatefulWidget {
  Quadrant({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabControllerStuState();
  }
}

class _TabControllerStuState extends State<Quadrant>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ["生词", "已记住", "全部"];

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DevWordController>(
        init: DevWordController(_tabController),
        builder: (controller) {
          Widget renderWordList() {
            return ListView(children: controller.getCurrentRender);
          }

          List<Widget> buildBoardItems(List<TodoItem> items) {
            List<Widget> widgets = new List.empty(growable: true);
            items.forEach((element) {
              var cards = SliverToBoxAdapter(
                  child:Card(
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text("洗澡" + element.priority.toString()),
                  value: true,
                  onChanged: (bool? value) {},
                ),
              ));
              widgets.add(cards);
            });
            return widgets;
          }

          Map<int, String> boardItem = new HashMap();
          boardItem.putIfAbsent(0, () => "重要且紧急");
          boardItem.putIfAbsent(1, () => "重要不紧急");
          boardItem.putIfAbsent(2, () => "不重要紧急");
          boardItem.putIfAbsent(3, () => "不重要不紧急");

          List<TodoItem> items = new List.empty(growable: true);
          final _random = new Random();

          for (int i = 0; i < 30; i++) {
            TodoItem ti = new TodoItem(
                id: 1,
                priority: _random.nextInt(4) + 1,
                itemName: "dddddd",
                createdTime: 1,
                scheduleTime: 1,
                taskStatus: 1,
                tags: "tags");
            items.add(ti);
          }

          Widget buildListViewItemWidget(int index, List<TodoItem> items) {
            return Card(
              color: Colors.cyan[100 * (index % 9)],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: CustomScrollView(
                  slivers: buildBoardItems(items),
              ),
            );
          }

          var itemWidth = (MediaQuery.of(context).size.width - 30) / 2;
          var itemHeight = MediaQuery.of(context).size.height;
          var childAspectRatio = itemWidth / (itemHeight / 2 - 66);

          Widget buildGridView() {
            return GridView.custom(
              semanticChildCount: 2,
              cacheExtent: 4,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: childAspectRatio,
              ),
              childrenDelegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                List<TodoItem> itemsBuild = items
                    .where((element) => element.priority == index+1)
                    .toList();
                return buildListViewItemWidget(index, itemsBuild);
              }, childCount: 4),
            );
          }

          return Scaffold(
            body: SafeArea(child: buildGridView()),
          );
        });
  }
}
