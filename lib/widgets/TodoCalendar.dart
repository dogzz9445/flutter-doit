import 'dart:collection';
import 'dart:core';

import 'package:doit_calendar_todo/data/app_settings.dart';
import 'package:doit_calendar_todo/data/schedule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoCalendar extends StatefulWidget {
  const TodoCalendar({Key? key, required this.schedules}) : super(key: key);

  final List<Schedule> schedules;

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
    Provider.of<AppCalenderScheduler>(context, listen: false)
        .selectedSchedules
        .value = getSchedulesForDay(_selectedDay);
  }

  List<Schedule> getSchedulesForDay(day) {
    return widget.schedules
        .where((element) => isSameDay(element.scheduleDate, day))
        .toList();
  }

  void loadTestData() {
    widget.schedules.clear();
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
      eventLoader: getSchedulesForDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
            Provider.of<AppCalenderScheduler>(context, listen: false)
                .selectedSchedules
                .value = getSchedulesForDay(selectedDay);
          });
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
