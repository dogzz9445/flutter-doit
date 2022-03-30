import 'package:flutter/material.dart';

/// A page that shows a summary of bills.
class FriendView extends StatefulWidget {
  const FriendView({Key? key}) : super(key: key);

  @override
  _FriendViewState createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const Text("Friends");
  }
}
