import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/hero_id_model.dart';
import '../controller/home_controller.dart';
import 'sub/add_todo_screen.dart';

class HomePage extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final ScrollController scrollController = ScrollController();

  Map<int, String> getCategories() {
    Map<int, String> categories = HashMap<int, String>();
    categories.putIfAbsent(1, () => "已过期");
    categories.putIfAbsent(2, () => "待完成");
    categories.putIfAbsent(3, () => "已完成");
    return categories;
  }

  Widget buildTaskCategoriesView(BuildContext context, HomeController controller) {
    return SingleChildScrollView(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Card(
                  child: ExpansionTile(
                    title: Text(getCategories()[index + 1]!),
                    children: buildTasks(index + 1),
                  ),
                ),
              ),
          itemCount: getCategories().length),
    );
  }

  List<Widget> buildTasks(int index) {
    if (index == 1) {
      return homeController.expiredTaskList;
    } else if (index == 2) {
      return homeController.newTaskList;
    } else if (index == 3) {
      return homeController.completeTaskList;
    } else {
      return List.empty(growable: false);
    }
  }

  Widget buildExpiredTasks(BuildContext context, HomeController controller) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: controller.expiredTaskList.obs.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        Widget widget = controller.expiredTaskList.obs[index];
        return widget;
      },
    );
  }

  Widget buildNewTasks(BuildContext context, HomeController controller) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: controller.newTaskList.obs.length,
      controller: scrollController,
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
      controller: scrollController,
      itemCount: controller.completeTaskList.obs.length,
      itemBuilder: (BuildContext context, int index) {
        Widget widget = controller.completeTaskList.obs[index];
        return widget;
      },
    );
  }

  Widget _buildBody(BuildContext context, HomeController controller) {
    //return Obx(() => buildTaskCategoriesView(context, controller));
    return buildTaskCategoriesView(context, controller);
  }

  Future<void> addTask() async {
    HeroId heroId = new HeroId(progressId: '121', titleId: '232', remainingTaskId: '4242', codePointId: '2424');
    Get.to(() => AddTodoScreen(
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
            appBar: AppBar(title: Text("${controller.activeTodoList == null ? 'unknown' : controller.activeTodoList.name}")),
            drawer: Drawer(child: ListView(children: homeController.buildTodoListItems())),
            body: _buildBody(context, controller),
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              onPressed: addTask,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ));
        });
  }
}
