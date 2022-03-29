import 'dart:core';

import 'package:doit_calendar_todo/widgets/TodoCalendar.dart';

import 'package:doit_calendar_todo/data/schedule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page that shows a summary of bills.
class CalenderView extends StatefulWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<List<Schedule>> _selectedSchedules = ValueNotifier([]);

  late List<Schedule> managedSchedules;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TodoCalendar(schedules: context.watch<AppCalenderScheduler>().schedules),
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
