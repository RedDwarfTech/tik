import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../models/hero_id_model.dart';
import 'add_todo_screen.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController c = Get.put(HomeController());
  final ScrollController scrollController = ScrollController();
  GlobalKey _inputViewKey = GlobalKey();

  Widget _buildTodoView(BuildContext context,HomeController controller) {
    return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.widgetsList.obs.length,
          //itemExtent: 50.0,
          itemBuilder: (BuildContext context, int index) {
            Widget widget = controller.widgetsList.obs[index];
            return widget;
          },
        );
  }

  Widget _buildBody(BuildContext context,HomeController controller) {
    return _buildTodoView(context,controller);
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
                          icon: Icon( // <-- Icon
                            Icons.add,
                            size: 24.0,
                          ),
                          label: Text('添加清单'))
                    ],
                  ),
                ),
                body: _buildBody(context,controller),
            floatingActionButton: FloatingActionButton(
              onPressed: addTask,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ));
        });
  }
}
