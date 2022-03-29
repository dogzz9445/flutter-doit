import 'dart:collection';
import 'dart:core';
import 'dart:core';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:table_calendar/table_calendar.dart';

class Schedule extends ChangeNotifier {
  Schedule({
    required String title,
    DateTime? scheduleDate,
    String? description,
  })  : _description = description,
        _title = title,
        _scheduleDate = scheduleDate;

  String _title;
  String? _description;
  DateTime? _scheduleDate;

  String get title => _title;
  set title(String value) {
    if (_title == value) {
      return;
    }
    _title = value;
    notifyListeners();
  }

  String? get description => _description;
  set description(String? value) {
    if (_description == value) {
      return;
    }
    _description = value;
    notifyListeners();
  }

  DateTime get scheduleDate => _scheduleDate ??= DateTime.now();
  set scheduleDate(DateTime value) {
    if (scheduleDate == value) {
      return;
    }
    _scheduleDate = value;
    notifyListeners();
  }

  @override
  String toString() => title;
}

final kSchedules = LinkedHashMap<DateTime, List<Schedule>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kScheduleSource);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class AppCalenderScheduler extends ChangeNotifier {
  AppCalenderScheduler();
  final _schedules = <Schedule>[];

  void add(Schedule schedule) {
    schedule.addListener(notifyListeners);
    _schedules.add(schedule);
    notifyListeners();
  }

  void remove(Schedule schedule) {
    schedule.removeListener(notifyListeners);
    _schedules.remove(schedule);
    notifyListeners();
  }
}

// final _kScheduleSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 6 + 1, (index) => Schedule(title: 'Event $item | ${index + 1}')))
final _kScheduleSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 6 + 1, (index) => Schedule(title: 'Event $item | ${index + 1}'))
}..addAll({
    kToday: [
      Schedule(title: 'Today\'s Event 1'),
      Schedule(title: 'Today\'s Event 2'),
    ],
  });

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

// const kKoreanDaysOfWeekStyle = DaysOfWeekStyle(
//   dowTextFormatter: (day, locale) =>
//       DateFormat.E(locale).format(day).toString(),
// );
