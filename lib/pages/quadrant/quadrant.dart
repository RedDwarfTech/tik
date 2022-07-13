import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'quadrant_controller.dart';

class Quadrant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemWidth = (MediaQuery.of(context).size.width - 30) / 2;
    var itemHeight = MediaQuery.of(context).size.height;
    var childAspectRatio = itemWidth / (itemHeight / 2 - 66);

    return GetBuilder<QuadrantController>(
        init: QuadrantController(),
        builder: (controller) {
          return Scaffold(
              body: SafeArea(
                  child: GridView.custom(
            semanticChildCount: 2,
            cacheExtent: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 3.0,
              crossAxisCount: 2,
              childAspectRatio: childAspectRatio,
            ),
            childrenDelegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return controller.buildListViewItemWidget(index, controller.tasks.where((element) => element.priority == index + 1).toList());
            }, childCount: 4),
          )));
        });
  }
}
