import 'package:flutter/material.dart';

/// A page that shows a summary of bills.
class ActivityView extends StatefulWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  _ActivityViewState createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const Text("Activitys");
  }
}
