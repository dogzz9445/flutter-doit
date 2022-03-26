import 'package:flutter/material.dart';

/// A page that shows a summary of bills.
class CalenderView extends StatefulWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const Text("Calenders");
  }
}
