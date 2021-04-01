import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

import 'package:flutter_uploader/flutter_uploader.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with SecureStoreMixin {
  CameraController controller;
  List<CameraDescription> cameras;
  int indexCamera = 1;
  bool isRecord = false;
  XFile imageFile;
  XFile videoFile;

  final FlutterUploader uploader = FlutterUploader();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    checkCameraAvailability();
  }

  Future<void> checkCameraAvailability() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      this.cameras = await availableCameras();

      setCamera();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void setCamera() async {
    if (controller != null) {
      await controller.dispose();
    }

    indexCamera = indexCamera == 0 ? 1 : 0;
    controller = CameraController(
      cameras[indexCamera],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> startVideoRecording() async {
    if (!controller.value.isInitialized || controller.value.isRecordingVideo) {
      return null;
    }

    await controller.startVideoRecording();
    setState(() {});
  }

  Future<Map<String, String>> getHeaders() async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return null;
    }
    String token = await getAuthToken();

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    };
  }

  void uploadFileBackground(XFile file) async {
    // uploader
    try {
      await uploader.enqueue(
          url: DotEnv.env['API_URL'] + "posts", //required: url to upload to
          //
          files: [
            FileItem(
              filename: basename(file.path),
              savedDir: dirname(file.path),
              fieldname: "file",
            )
          ], // required: list of files that you want to upload
          method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
          headers: await getHeaders(),
          data: {
            "metadata": '{"type": "video", "description": "Upload"}'
          }, // any data you want to send in upload request
          showNotification:
              false, // send local notification (android only) for upload status
          tag: "upload 1");
    } catch (e) {
      print('Error upload: $e');
    } // unique tag for upload task
  }

  void onStopButtonPressed(BuildContext context) {
    stopVideoRecording().then((file) async {
      if (mounted) setState(() {});
      if (file != null) {
        await GallerySaver.saveVideo(file.path);
        videoFile = file;
        Navigator.of(context).pushNamed(
          PageRoute.Page.postPreviewScreen.route,
          arguments: {
            "filePath": file.path,
          },
        );
      }
    });
  }

  Future<XFile> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      return controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    print('Hello $mode');

    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e) {
      print('Erro da camera $e');
      rethrow;
    }
  }

  Widget renderButtonsFlashCamera() {
    // if (false && indexCamera == 0) {
    //   print('Foi aqui1');

    //   return IconButton(
    //     icon: Icon(Icons.flash_off),
    //     iconSize: 30,
    //     color: Colors.white,
    //     onPressed: () => onSetFlashModeButtonPressed(FlashMode.off),
    //   );
    // } else if (true && indexCamera == 0) {
    //   print('Foi aqui2');

    //   return IconButton(
    //     icon: Icon(Icons.flash_on),
    //     iconSize: 30,
    //     color: Colors.white,
    //     onPressed: () => onSetFlashModeButtonPressed(FlashMode.always),
    //   );
    // } else {
    //   print('Foi aqui3');

    //   return IconButton(
    //     icon: Icon(Icons.no_flash),
    //     iconSize: 30,
    //     color: Colors.white38,
    //     onPressed: () {},
    //   );
    // }

    return IconButton(
      icon: Icon(Icons.no_flash),
      iconSize: 30,
      color: Colors.white38,
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    } else {
      final size = MediaQuery.of(context).size;
      final deviceRatio = size.width / size.height;

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            child: AspectRatio(
              aspectRatio: deviceRatio,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(1.0, 1.0, 1.0),
                child: CameraPreview(controller),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller != null ? renderButtonsFlashCamera() : null,
              IconButton(
                  icon: Icon(Icons.fiber_manual_record),
                  iconSize: 68,
                  color: controller.value.isRecordingVideo
                      ? Colors.red
                      : Colors.white,
                  onPressed: () {
                    if (!controller.value.isRecordingVideo) {
                      startVideoRecording();
                      print("START RECORD");
                    } else {
                      print("ON STOP HERE");
                      onStopButtonPressed(context);
                    }
                  }),
              IconButton(
                icon: Icon(
                    indexCamera == 0 ? Icons.camera_front : Icons.camera_rear),
                iconSize: 30,
                color: Colors.white,
                onPressed: () => setCamera(),
              ),
              /*IconButton(
                icon: Icon(Icons.insert_photo),
                iconSize: 30,
                color: Colors.white,
                onPressed: () => setCamera(),
              ),*/
            ],
          )
        ],
      );
    }
  }
}

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraApp(),
    );
  }
}
