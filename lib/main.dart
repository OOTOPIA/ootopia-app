import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './screens/timeline/timeline.dart';
import './screens/camera_screen/camera_screen.dart';

import 'package:camera/camera.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: TimelinePage(),
      home: CameraScreen(),
    );
  }
}

// class CameraApp extends StatelessWidget {
//   List<CameraDescription> cameras = [];

//   @override
//   Future<void> initState() async {
//     try {
//       WidgetsFlutterBinding.ensureInitialized();
//       cameras = await availableCameras();
//     } on CameraException catch (e) {
//       logError(e.code, e.description);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CameraExampleHome(cameras: this.cameras),
//     );
//   }
// }

// Future<void> main() async {
//   // Fetch the available cameras before initializing the app.

//   runApp(CameraApp());
// }
