import 'package:flutter/material.dart';

class ViewLearningTracksScreen extends StatefulWidget {
  const ViewLearningTracksScreen({Key? key}) : super(key: key);

  @override
  _ViewLearningTracksScreenState createState() =>
      _ViewLearningTracksScreenState();
}

class _ViewLearningTracksScreenState extends State<ViewLearningTracksScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(args['list_chapters']);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            color: Colors.amber,
            height: 162,
          ),
          Positioned(
            top: 1,
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          )
        ],
      ),
    );
  }
}
