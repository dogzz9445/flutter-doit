import 'package:flutter/material.dart';

/// A page that shows a summary of bills.
class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const Text("settings");
  }
}
