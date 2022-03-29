import 'dart:collection';
import 'dart:core';

import 'package:doit_calendar_todo/data/app_settings.dart';
import 'package:doit_calendar_todo/data/schedule.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoCalendar extends StatefulWidget {
  TodoCalendar({Key? key, required this.schedules}) : super(key: key);

  final List<Schedule> schedules;
  final hashSchedules = LinkedHashMap<DateTime, List<Schedule>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  @override
  _TodoCalendarState createState() => _TodoCalendarState();
}

class _TodoCalendarState extends State<TodoCalendar>
    with SingleTickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final ValueNotifier<List<Schedule>> _selectedSchedules = ValueNotifier([]);

  List<Schedule> _getSchedulesForDay(day) {
    return widget.hashSchedules[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Schedule>(
      locale: deviceLocale,
      calendarFormat: _calendarFormat,
      firstDay: DateTime.utc(2017),
      lastDay: DateTime.utc(2030),
      focusedDay: _focusedDay,
      // daysOfWeekStyle: DaysOfWeekStyle(dowTextFormatter: (day, locale) {
      //   return DateFormat.E(locale).format(day);
      // }),
      eventLoader: _getSchedulesForDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });

          _selectedSchedules.value = _getSchedulesForDay(selectedDay);
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
