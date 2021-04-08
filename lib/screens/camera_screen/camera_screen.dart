import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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

class _CameraAppState extends State<CameraApp> with SecureStoreMixin {
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

  @override
  void initState() {
    super.initState();
    requestPermissions();
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
        GallerySaver.saveVideo(file.path).then((res) {
          videoFile = file;
          Navigator.of(context).pushNamed(
            PageRoute.Page.postPreviewScreen.route,
            arguments: {
              "filePath": file.path,
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

  @override
  Widget build(BuildContext context) {
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

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(controller),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(GlobalConstants.of(context).spacingNormal),
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
                  onLongPressStart: (details) {
                    if (!controller.value.isRecordingVideo) {
                      startVideoRecording();
                      print("START RECORD");
                    }
                  },
                  onLongPressEnd: (details) {
                    if (controller.value.isRecordingVideo) {
                      print("ON STOP HERE");
                      onStopButtonPressed(context);
                    }
                  },
                  child: Container(
                    width: 68,
                    height: 68,
                    child: new LayoutBuilder(
                      builder: (context, constraint) {
                        return new Icon(Icons.fiber_manual_record,
                            size: constraint.biggest.height,
                            color: controller.value.isRecordingVideo
                                ? Colors.red
                                : Colors.white);
                      },
                    ),
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
                                    child:
                                        Image.memory(bytes, fit: BoxFit.cover),
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
