import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:photo_manager/photo_manager.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp>
    with SecureStoreMixin, SingleTickerProviderStateMixin {
  CameraController controller;
  List<CameraDescription> cameras;
  int indexCamera = 1;
  bool isRecord = false;
  XFile imageFile;
  XFile videoFile;
  bool permissionsIsNeeded = true;
  AssetEntity lastVideoThumbnail;
  final picker = ImagePicker();

  final FlutterUploader uploader = FlutterUploader();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double _scale;
  AnimationController _animController;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
        setState(() {});
      });
  }

  getLastVideoThumbnail() async {
    try {
      var albums = await PhotoManager.getAssetPathList(type: RequestType.video);
      final recentAlbum = albums.first;
      final recentAssets = await recentAlbum.getAssetListRange(
        start: 0, // start at index 0
        end: 1, // end at a very big index (to get all the assets)
      );
      setState(() {
        lastVideoThumbnail = recentAssets[0];
      });
    } catch (err) {
      print("DEU ERRO AO PEGAR A PARADA");
    }
  }

  Future<void> requestPermissions() async {
    var storageStatus = await Permission.storage.status;
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    if (storageStatus.isUndetermined ||
        cameraStatus.isUndetermined ||
        microphoneStatus.isUndetermined ||
        storageStatus.isDenied ||
        cameraStatus.isDenied ||
        microphoneStatus.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
        Permission.microphone
      ].request();
      if (statuses[Permission.storage] == PermissionStatus.granted &&
          statuses[Permission.camera] == PermissionStatus.granted &&
          statuses[Permission.microphone] == PermissionStatus.granted) {
        checkCameraAvailability();
        getLastVideoThumbnail();
        setState(() {
          permissionsIsNeeded = false;
        });
      }
      print(statuses[
          Permission.storage]); // it should print PermissionStatus.granted
    } else {
      setState(() {
        permissionsIsNeeded = false;
      });
      checkCameraAvailability();
      getLastVideoThumbnail();
    }
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
    super.dispose();
    controller?.dispose();
    _animController.dispose();
  }

  void setCamera() async {
    if (controller != null) {
      await controller.dispose();
    }

    indexCamera = indexCamera == 0 ? 1 : 0;
    controller = CameraController(
      cameras[indexCamera],
      ResolutionPreset.medium,
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

  void onStopButtonPressed(BuildContext context) {
    stopVideoRecording().then((file) async {
      if (mounted) setState(() {});
      if (file != null) {
        GallerySaver.saveVideo(file.path).then((res) async {
          String filePath = file.path;
          bool mirroredVideo = false;
          if (indexCamera == 1) {
            mirroredVideo = true;
          }
          videoFile = file;
          Navigator.of(context).pushNamed(
            PageRoute.Page.postPreviewScreen.route,
            arguments: {
              "filePath": filePath,
              "mirroredVideo": mirroredVideo.toString()
            },
          );
        });
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

  Future getVideoFromGallery(BuildContext context) async {
    await controller.dispose();
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    indexCamera = 1;
    controller = null;
    setCamera();

    setState(() {
      if (pickedFile != null) {
        Navigator.of(context).pushNamed(
          PageRoute.Page.postPreviewScreen.route,
          arguments: {
            "filePath": pickedFile.path,
          },
        );
      }
    });
  }

  Widget renderButtonsFlashCamera() {
    return IconButton(
      icon: Icon(Icons.no_flash),
      iconSize: 30,
      color: Colors.white38,
      onPressed: () {},
    );
  }

  Widget _animatedButton(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              blurRadius: 12.0,
              offset: Offset(0.0, 5.0),
            ),
          ],
          color: controller.value.isRecordingVideo ? Colors.red : Colors.white,
        ),
        child: Center(
          child: SizedBox(width: 64, height: 64),
        ),
      ),
    );
  }

  void _tapDown(details) {
    if (!controller.value.isRecordingVideo) {
      startVideoRecording();
      _animController.forward();
      print("START RECORD");
    }
  }

  void _tapUp(context) {
    if (controller.value.isRecordingVideo) {
      print("ON STOP HERE");
      onStopButtonPressed(context);
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Value =====================> ${_animController.value}");
    _scale = 1 + _animController.value;
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        child: Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (permissionsIsNeeded) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 300,
                  child: TryAgain(
                    requestPermissions,
                    messageText:
                        "You need to enable some \npermissions to allow full \nuse of the camera.",
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      final size = MediaQuery.of(context).size;
      //final deviceRatio = size.width / size.height;
      var scale = size.aspectRatio * controller.value.aspectRatio;
      if (scale < 1) scale = 1 / scale;

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(''),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Transform.scale(
              scale: scale,
              child: Center(
                child: CameraPreview(controller),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(GlobalConstants.of(context).spacingNormal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                  ),
                  controller != null
                      ? renderButtonsFlashCamera()
                      : SizedBox(
                          width: 36,
                          height: 36,
                        ),
                  GestureDetector(
                    onLongPressStart: _tapDown,
                    onLongPressEnd: (details) {
                      _tapUp(context);
                    },
                    child: Transform.scale(
                      scale: _scale,
                      child: _animatedButton(context),
                    ),
                  ),
                  IconButton(
                    icon: Icon(indexCamera == 0
                        ? Icons.camera_front
                        : Icons.camera_rear),
                    iconSize: 30,
                    color: Colors.white,
                    onPressed: () => setCamera(),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!controller.value.isRecordingVideo) {
                        getVideoFromGallery(context);
                      }
                    },
                    child: lastVideoThumbnail == null
                        ? IconButton(
                            icon: Icon(Icons.insert_photo),
                            iconSize: 30,
                            color: Colors.white,
                            onPressed: () {},
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                left: GlobalConstants.of(context).spacingSmall),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: FutureBuilder<Uint8List>(
                                future: lastVideoThumbnail.thumbData,
                                builder: (_, snapshot) {
                                  final bytes = snapshot.data;
                                  // If we have no data, display a spinner
                                  if (bytes == null)
                                    return CircularProgressIndicator();
                                  // If there's data, display it as an image
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      child: Image.memory(bytes,
                                          fit: BoxFit.cover),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
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
