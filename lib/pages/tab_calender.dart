import 'dart:collection';
import 'package:doit_calendar_todo/data/app_settings.dart';
import 'package:intl/intl.dart';

import 'package:doit_calendar_todo/data/schedule.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// A page that shows a summary of bills.
class CalenderView extends StatefulWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView>
    with SingleTickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final ValueNotifier<List<Schedule>> _selectedSchedules = ValueNotifier([]);

  List<Schedule> _getSchedulesForDay(DateTime day) {
    // Implementation example
    return kSchedules[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    // return CalendarDatePicker(
    //   firstDate: DateTime(2017),
    //   initialDate: DateTime.now(),
    //   lastDate: DateTime(2030),
    //   onDateChanged: (DateTime value) {},
    // );
    return Column(children: [
      TableCalendar<Schedule>(
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
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
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
      ),
      const SizedBox(height: 8.0),
      Expanded(
        child: ValueListenableBuilder<List<Schedule>>(
          valueListenable: _selectedSchedules,
          builder: (context, value, _) {
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color(0xFFE6EBEB),
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2.0,
                          spreadRadius: 2.0,
                          offset: Offset(4, 4))
                    ],
                  ),
                  child: ListTile(
                    onTap: () => print('${value[index]}'),
                    title: Text('${value[index]}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]);
  }
}
