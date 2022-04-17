import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
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

  User? _owner;
  String _title;
  String _description;
  Color? _defaultColor;
  bool? _isTodo;
  bool? _isPrivate;
  final List<Schedule> _schedules = <Schedule>[];
  final List<User> _participants = <User>[];
  // invitedParticipants 추가하기
  // 3일 주기? 반복하는지 넣기
  // 미루면 자동으로 밀리는 옵션

  bool? get isTodo => _isTodo;
  set isTodo(bool? value) {
    if (_isTodo == value) {
      return;
    }
    _isTodo = value;
    notifyListeners();
  }

  bool? get isPrivate => _isPrivate;
  set isPrivate(bool? value) {
    if (_isPrivate == value) {
      return;
    }
    _isPrivate = value;
    notifyListeners();
  }

  User? get owner => _owner;
  set owner(User? value) {
    if (_owner == value) {
      return;
    }
    _owner = value;
    notifyListeners();
  }

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

  List<Schedule> get schedules => _schedules;

  void add(Schedule schedule) {
    schedule.addListener(notifyListeners);
    _schedules.add(schedule);
  }

  void addRange(List<Schedule> schedules) {
    _schedules.addAll(schedules);
  }

  void remove(Schedule schedule) {
    var selectedSchedule =
        _schedules.firstWhere((element) => element == schedule);
    selectedSchedule.removeListener(notifyListeners);
    _schedules.remove(selectedSchedule);
  }

  void clear() {
    for (var schedule in _schedules) {
      schedule.removeListener(notifyListeners);
    }
    _schedules.clear();
  }

  @override
  String toString() => title;
}
