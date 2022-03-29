import 'dart:collection';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:table_calendar/table_calendar.dart';

// Fake locale to represent the system Locale option.
const systemLocaleOption = Locale('system');

Locale? _deviceLocale;

Locale? get deviceLocale => _deviceLocale;

set deviceLocale(Locale? locale) {
  _deviceLocale ??= locale;
}

class Schedule {
  const Schedule({
    required this.title,
    Locale? locale,
  }) : _locale = locale;

  final Locale? _locale;
  final String title;

  Locale? get locale => _locale ?? deviceLocale;

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

final _kScheduleSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(item % 4 + 1,
        (index) => Schedule(title: 'Event $item | ${index + 1}', locale: null)))
  ..addAll({
    kToday: [
      Schedule(title: 'Today\'s Event 1', locale: null),
      Schedule(title: 'Today\'s Event 2', locale: null),
    ],
  });

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

// const kKoreanDaysOfWeekStyle = DaysOfWeekStyle(
//   dowTextFormatter: (day, locale) =>
//       DateFormat.E(locale).format(day).toString(),
// );
