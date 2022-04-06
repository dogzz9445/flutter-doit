import 'package:flutter/material.dart';

import 'package:doit_calendar_todo/data/schedule.dart';

class Repository extends ChangeNotifier {
  Repository({
    required String title,
    required String description,
    Color? defaultColor,
  })  : _title = title,
        _description = description,
        _defaultColor = defaultColor;

  String _title;
  String _description;
  Color? _defaultColor;
  final List<Schedule> _schedules = <Schedule>[];

  String get title => _title;
  set title(String value) {
    if (_title == value) {
      return;
    }
    _title = value;
    notifyListeners();
  }

  String get description => _description;
  set description(String value) {
    if (_description == value) {
      return;
    }
    _description = value;
    notifyListeners();
  }

  Color get defaultColor => _defaultColor ??= Colors.grey;
  set color(Color value) {
    if (_defaultColor == value) {
      return;
    }
    _defaultColor = value;
    notifyListeners();
  }

  List<Schedule> get schedules {
    return schedules;
  }

  void Add(Schedule schedule) {
    // 이벤트 등록하고 리스트에 넣기
  }

  void AddRange(List<Schedule> schedules) {
    // 이벤트 등록하고 리스트에 넣기
  }

  void Remove(Schedule schedule) {
    // 이벤트 해제하고 제거
  }

  void Clear() {
    // 이벤트 해제하고 제거
  }

  @override
  String toString() => title;
}
