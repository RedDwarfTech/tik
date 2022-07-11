// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:Tik/pages/calendar/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/todo/todo_model.dart';
import '../controller/calendar_controller.dart';

class TableComplexExample extends StatefulWidget {
  @override
  _TableComplexExampleState createState() => _TableComplexExampleState();
}

class _TableComplexExampleState extends State<TableComplexExample> {
  late final PageController _pageController;
  DateTime? _selectedDays;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final CalendarController calendarController = Get.put(CalendarController());

  @override
  void initState() {
    super.initState();
    _selectedDays = calendarController.focusedDay.value;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get canClearSelection => _rangeStart != null || _rangeEnd != null;

  Future<List<TodoTask>> _getEventsForDays(Iterable<DateTime> days) async {
    return [
      for (final d in days) ...await calendarController.getEventsForDay(d),
    ];
  }

  Future<List<TodoTask>> _getEventsForRange(DateTime start, DateTime end) async {
    final days = daysInRange(start, end);
    return await _getEventsForDays(days);
  }

  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      calendarController.focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });
    calendarController.selectedEvents.value = await calendarController.getEventsForDay(selectedDay);
  }

  Future<void> _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) async {
    setState(() {
      calendarController.focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      calendarController.selectedEvents.value = await _getEventsForRange(start, end);
    } else if (start != null) {
      calendarController.selectedEvents.value = calendarController.getEventsForDay(start);
    } else if (end != null) {
      calendarController.selectedEvents.value = calendarController.getEventsForDay(end);
    }
  }

  Widget buildCalendarHeader(DateTime value) {
    return _CalendarHeader(
      focusedDay: value,
      clearButtonVisible: canClearSelection,
      onTodayButtonTap: () {
        setState(() => calendarController.focusedDay.value = DateTime.now());
      },
      onClearButtonTap: () {
        setState(() {
          _rangeStart = null;
          _rangeEnd = null;
          calendarController.selectedEvents.value = [];
        });
      },
      onLeftArrowTap: () {
        _pageController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      onRightArrowTap: () {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }

  Widget buildEvents(List<TodoTask> value) {
    return ListView.builder(
      itemCount: value.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            onTap: () => print('${value[index]}'),
            title: Text('${value[index].name}'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarController>(
        init: CalendarController(),
        builder: (controller) {
          return Scaffold(
              body: SafeArea(
            child: Column(
              children: [
                ValueListenableBuilder<DateTime>(
                  valueListenable: calendarController.focusedDay,
                  builder: (context, value, _) {
                    return buildCalendarHeader(value);
                  },
                ),
                TableCalendar<TodoTask>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: calendarController.focusedDay.value,
                  headerVisible: false,
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: calendarController.getEventsForDay,
                  holidayPredicate: (day) {
                    // Every 20th day of the month will be treated as a holiday
                    return day.day == 20;
                  },
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onCalendarCreated: (controller) => _pageController = controller,
                  onPageChanged: (focusedDay) => calendarController.focusedDay.value = focusedDay,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() => _calendarFormat = format);
                    }
                  },
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<TodoTask>>(
                    valueListenable: calendarController.selectedEvents,
                    builder: (context, value, _) {
                      return buildEvents(value);
                    },
                  ),
                ),
              ],
            ),
          ));
        });
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
