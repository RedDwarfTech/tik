import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/hero_id_model.dart';
import 'add_todo_screen.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController c = Get.put(HomeController());
  final ScrollController scrollController = ScrollController();

  Widget _buildTodoView(BuildContext context, HomeController controller) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          if (index == 0) {
            var expand = controller.newTaskExpanded.value;
            controller.newTaskExpanded(!expand);
            controller.refresh();
          }
          if (index == 1) {
            var expand = controller.completedTaskExpanded.value;
            controller.completedTaskExpanded(!expand);
            controller.refresh();
          }
        },
        children: [
          ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text("待完成"),
                );
              },
              body: buildNewTasks(context, controller),
              isExpanded: controller.newTaskExpanded.value,
              canTapOnHeader: true),
          ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text("已完成"),
                );
              },
              isExpanded: controller.completedTaskExpanded.value,
              canTapOnHeader: true,
              body: buildCompletedTasks(context, controller))
        ],
      )
    ]));
  }

  Widget buildNewTasks(BuildContext context, HomeController controller) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: controller.newTaskList.obs.length,
      itemBuilder: (BuildContext context, int index) {
        Widget widget = controller.newTaskList.obs[index];
        return widget;
      },
    );
  }

  Widget buildCompletedTasks(BuildContext context, HomeController controller) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: controller.completeTaskList.obs.length,
      itemBuilder: (BuildContext context, int index) {
        Widget widget = controller.completeTaskList.obs[index];
        return widget;
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeController controller) {
    return _buildTodoView(context, controller);
  }

  Future<void> addTask() async {
    HeroId heroId = new HeroId(
        progressId: '121',
        titleId: '232',
        remainingTaskId: '4242',
        codePointId: '2424');
    Get.to(AddTodoScreen(
      taskId: '1',
      heroIds: heroId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(title: Text("title")),
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('清单1'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    title: const Text('清单2'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        // <-- Icon
                        Icons.add,
                        size: 24.0,
                      ),
                      label: Text('添加清单'))
                ],
              ),
            ),
            body: _buildBody(context, controller),
            floatingActionButton: FloatingActionButton(
              onPressed: addTask,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ));
        });
  }
}
