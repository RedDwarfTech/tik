import 'dart:collection';

import 'package:Tik/pages/calendar/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wheel/wheel.dart';

import '../../../includes.dart';
import '../../../models/todo/todo_model.dart';
import '../../../networking/rest/task/task_provider.dart';

class CalendarController extends GetxController {
  DateTime selectedDays = DateTime.now();
  List<TodoTask> tasks = List.empty(growable: true);
  Map<String, List<TodoTask>> taskMap = new HashMap();
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  late final ValueNotifier<List<TodoTask>> selectedEvents = ValueNotifier(calendarController.getEventsForDay(focusedDay.value));

  @override
  void onInit() {
    super.onInit();
  }

  List<TodoTask> getEventsForDay(DateTime day) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String dateString = formatter.format(day);
    List<TodoTask> dayTodoTask = taskMap[dateString] ?? [];
    return dayTodoTask;
  }

  void initialTasks() {
    int monthStartMilliseconds = DateTimeUtils.startOfMonthMilliseconds(DateTime.now());
    int monthEndMilliseconds = DateTimeUtils.endOfMonthMilliseconds(DateTime.now());
    TaskProvider.getTasksByRangeDate(monthStartMilliseconds, monthEndMilliseconds).then((value) => {buildHashMap(value)});
  }

  List<TodoTask> getEventsForDayLegacy(DateTime day) {
    var taskResult;
    int monthStartMilliseconds = DateTimeUtils.startOfMonthMilliseconds(DateTime.now());
    int monthEndMilliseconds = DateTimeUtils.endOfMonthMilliseconds(DateTime.now());
    TaskProvider.getTasksByRangeDate(monthStartMilliseconds, monthEndMilliseconds)
        .then((value) => {() => taskResult = getTasks(value, day)});
    return taskResult ?? [];
  }

  List<TodoTask> getTasks(List<TodoTask> tasks, DateTime day) {
    tasks.addAll(tasks);
    buildHashMap(tasks);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String dateString = formatter.format(day);
    List<TodoTask> dayTodoTask = taskMap[dateString] ?? [];
    return dayTodoTask;
  }

  Map<String, List<TodoTask>> buildHashMap(List<TodoTask> tasks) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    tasks.forEach((element) {
      DateTime scheduleDateTime = DateTime.fromMicrosecondsSinceEpoch(element.schedule_time * 1000);
      final String formatted = formatter.format(scheduleDateTime);
      if (taskMap.containsKey(formatted)) {
        taskMap[formatted]?.add(element);
      } else {
        List<TodoTask> taskList = List.empty(growable: true);
        taskList.add(element);
        taskMap.putIfAbsent(formatted, () => taskList);
      }
    });
    return taskMap;
  }
}
