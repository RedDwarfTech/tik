import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import 'new_word_controller.dart';

class TodoCalendar extends StatelessWidget {
  TodoCalendar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewWordController>(
        init: NewWordController(),
        builder: (controller) {
          return Scaffold(
              body: SafeArea(
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),
          ));
        });
  }
}
