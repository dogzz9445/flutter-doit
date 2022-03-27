import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

// Fake locale to represent the system Locale option.
const systemLocaleOption = Locale('system');

Locale? _deviceLocale;

Locale? get deviceLocale => _deviceLocale;

set deviceLocale(Locale? locale) {
  _deviceLocale ??= locale;
}

class Schedule {
  const Schedule({
    Locale? locale,
  }) : _locale = locale;
  final Locale? _locale;
  Locale? get locale => _locale ?? deviceLocale;
}
