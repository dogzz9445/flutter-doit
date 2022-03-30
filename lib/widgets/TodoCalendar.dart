import 'dart:collection';
import 'dart:core';

import 'package:doit_calendar_todo/data/app_settings.dart';
import 'package:doit_calendar_todo/data/schedule.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoCalendar extends StatefulWidget {
  const TodoCalendar(
      {Key? key, required this.schedules, required this.selectedSchedules})
      : super(key: key);

  final List<Schedule> schedules;
  final ValueNotifier<List<Schedule>> selectedSchedules;

  List<Schedule> getSchedulesForDay(day) {
    return schedules
        .where((element) => isSameDay(element.scheduleDate, day))
        .toList();
  }

  @override
  _TodoCalendarState createState() => _TodoCalendarState();
}

class _TodoCalendarState extends State<TodoCalendar>
    with SingleTickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    loadTestData();
    setState(() {
      _selectedDay = DateTime.now();
    });
    widget.selectedSchedules.value = widget.getSchedulesForDay(_selectedDay);
  }

  void loadTestData() {
    widget.schedules.addAll(kSchedules.values.first);
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Schedule>(
      locale: deviceLocale.toString(),
      calendarFormat: _calendarFormat,
      firstDay: DateTime.utc(2017),
      lastDay: DateTime.utc(2030),
      focusedDay: _focusedDay,
      daysOfWeekHeight: 22.0,
      // daysOfWeekStyle: DaysOfWeekStyle(dowTextFormatter: (day, locale) {
      //   return DateFormat.E(locale).format(day);
      // }),
      eventLoader: widget.getSchedulesForDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });

          widget.selectedSchedules.value =
              widget.getSchedulesForDay(selectedDay);
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
