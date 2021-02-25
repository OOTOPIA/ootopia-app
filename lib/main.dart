import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './app/screens/timeline/timeline.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimelinePage(),
    );
  }
}
