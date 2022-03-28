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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // return CalendarDatePicker(
    //   firstDate: DateTime(2017),
    //   initialDate: DateTime.now(),
    //   lastDate: DateTime(2030),
    //   onDateChanged: (DateTime value) {},
    // );
    return TableCalendar(
        firstDay: DateTime.utc(2017),
        lastDay: DateTime.utc(2030),
        focusedDay: _focusedDay,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        });
  }
}
