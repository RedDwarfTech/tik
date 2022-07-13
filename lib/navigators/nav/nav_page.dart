import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../pages/calendar/view/todo_calendar.dart';
import '../../pages/home/view/home.dart';
import '../../pages/quadrant/quadrant.dart';
import '../../pages/settings/settings.dart';
import 'nav_controller.dart';

class Nav extends StatelessWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavController>(
        init: NavController(),
        builder: (controller) {
          void _onItemTapped(int index) {
            if (index == 0) {
              Widget widget = HomePage();
              controller.updateCurrentWidget(widget);
              controller.updateSelectIndex(0);
            }
            if (index == 1) {
              Widget widget = TodoCalendar();
              controller.updateCurrentWidget(widget);
              controller.updateSelectIndex(1);
            }
            if (index == 2) {
              Widget widget = Quadrant();
              controller.updateCurrentWidget(widget);
              controller.updateSelectIndex(2);
            }
            if (index == 3) {
              Widget widget = SettingsPage();
              controller.updateCurrentWidget(widget);
              controller.updateSelectIndex(3);
            }
          }

          return Scaffold(
            body: controller.getCurrentWidget,
            bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "清单"),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.subscriptions),
                    label: "日历",
                  ),
                  BottomNavigationBarItem(icon: Icon(Icons.rss_feed), label: '象限'),
                  BottomNavigationBarItem(icon: Icon(Icons.school), label: '我的'),
                ],
                currentIndex: controller.currentSelectIndex,
                fixedColor: Theme.of(context).primaryColor,
                onTap: _onItemTapped,
                unselectedItemColor: const Color(0xff666666),
                type: BottomNavigationBarType.fixed),
          );
        });
  }
}
