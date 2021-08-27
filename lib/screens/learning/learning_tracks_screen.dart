import 'package:flutter/material.dart';

class LearningTracksScreen extends StatefulWidget {
  LearningTracksScreen({Key? key}) : super(key: key);

  @override
  _LearningTracksScreenState createState() => _LearningTracksScreenState();
}

class _LearningTracksScreenState extends State<LearningTracksScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Learning Tracks"),
      ),
    );
  }
}
