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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TodoCalendar(
          schedules: context.watch<AppCalenderScheduler>().schedules,
          selectedSchedules: _selectedSchedules),
      const SizedBox(height: 3.0),
      Expanded(
        child: ValueListenableBuilder<List<Schedule>>(
          valueListenable: _selectedSchedules,
          builder: (context, value, _) {
            return ListView.builder(
              itemExtent: 56,
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      splashColor: Colors.red,
                      hoverColor: const Color(0x88080808),
                      onTap: () {
                        print('${value[index]}');
                        setState(() {});
                      },
                      child: Ink(
                          decoration: BoxDecoration(
                              color: const Color(0xFFE6EBEB),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(2, 2))
                              ]),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16.0),
                            title: Text('${value[index]}'),
                            trailing: const Icon(Icons.navigate_next),
                          ))),
                );
              },
            );
          },
        ),
      ),
    ]);
  }
}
