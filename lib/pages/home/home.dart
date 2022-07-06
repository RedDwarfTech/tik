import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../models/hero_id_model.dart';
import './toolbar_item_always_on_top.dart';
import './toolbar_item_settings.dart';
import 'add_todo_screen.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController c = Get.put(HomeController());
  final ScrollController scrollController = ScrollController();
  GlobalKey _inputViewKey = GlobalKey();

  Widget _buildTodoView(BuildContext context) {
    return Container(
      key: _inputViewKey,
      width: double.infinity,
      child: ListView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        children: c.widgetsList.obs,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTodoView(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ToolbarItemAlwaysOnTop(),
            Expanded(child: Container()),
            // ToolbarItemSponsor(),
            ToolbarItemSettings(
              onSettingsPageDismiss: () {},
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(34),
    );
  }

  Future<void> _incrementCounter() async {
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
            appBar: _buildAppBar(context),
            body: _buildBody(context),
            floatingActionButton: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ));
        });
  }
}
