import 'package:doit_calendar_todo/data/schedule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page that shows a summary of bills.
class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Consumer<AppCalenderScheduler>(
          builder: (context, data, index) {
            var todoSchedules =
                context.watch<AppCalenderScheduler>().todoSchedules;

            return ListView.builder(
                itemCount: todoSchedules.length,
                itemBuilder: (context, index) {
                  var schedule = todoSchedules[index];
                  return ListTile(title: Text(schedule.title));
                });
          },
        ))
      ],
    );
  }
}
