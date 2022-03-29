import 'package:flutter/material.dart';

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
      children: [const Text("지나간 할일"), const Text("다가오는 일")],
    );
  }
}
