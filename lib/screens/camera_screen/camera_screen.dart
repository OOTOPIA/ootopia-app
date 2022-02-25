import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/custom_gallery.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'components/crop_widget.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp>
    with SecureStoreMixin, SingleTickerProviderStateMixin {
  CameraController? controller;
  late List<CameraDescription> cameras;
  int indexCamera = 1;
  bool isRecord = false;
  late XFile imageFile;
  late XFile videoFile;
  bool permissionsIsNeeded = true;
  AssetEntity? lastVideoThumbnail;
  final picker = ImagePicker();
  bool flashIsOff = true;

  final FlutterUploader uploader = FlutterUploader();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late double _scale;
  late AnimationController _animController;

  final cropKey = GlobalKey<CropState>();
  late final crop;

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
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(type: RequestType.video);
      final AssetPathEntity recentAlbum = albums.first;
      final recentAssets = await recentAlbum.getAssetListRange(
        start: 0, // start at index 0
        end: 1, // end at a very big index (to get all the assets)
      );
      setState(() {
        lastVideoThumbnail = recentAssets[0];
      });
    } catch (err) {
      Sentry.captureException(err);
    }
  }

  Future<void> requestPermissions() async {
    var storageStatus = await Permission.storage.status;
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;
    if (storageStatus.isRestricted ||
        cameraStatus.isRestricted ||
        microphoneStatus.isRestricted ||
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
        await checkCameraAvailability();
        getLastVideoThumbnail();
        setState(() {
          permissionsIsNeeded = false;
        });
      }
    } else {
      await checkCameraAvailability();
      getLastVideoThumbnail();
      setState(() {
        permissionsIsNeeded = false;
      });
    }
  }

  Future<void> checkCameraAvailability() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      this.cameras = await availableCameras();

      setCamera();
    } on CameraException catch (e) {
      Sentry.captureException(e);
    }
  }

  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  void setCamera() async {
    // if (controller != null) {
    //   await controller!.dispose();
    // }

    indexCamera = indexCamera == 0 ? 1 : 0;
    controller = CameraController(
      cameras[indexCamera],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await controller!.initialize();

    setState(() {});
  }

  Future<void> startVideoRecording() async {
    if (!controller!.value.isInitialized ||
        controller!.value.isRecordingVideo) {
      return null;
    }

    await controller!.startVideoRecording();
    setState(() {});
  }

  Future<Map<String, String>> getHeaders() async {
    SharedPreferencesInstance prefs =
        await SharedPreferencesInstance.getInstance();

    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return {
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }
    String? token = prefs.getAuthToken();

    if (token == null) {
      return {
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }

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
              "mirroredVideo": mirroredVideo.toString(),
              "type": "video",
            },
          );
        });
      }
    });
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      return controller!.stopVideoRecording();
    } on CameraException catch (e) {
      return null;
    }
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      Sentry.captureException(e);
      rethrow;
    }
  }

  Future getVideoFromGallery() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    indexCamera = 1;
    setCamera();

    setState(() async {
      //await controller!.dispose();

      if (pickedFile != null) {
        await Navigator.of(context).pushNamed(
          PageRoute.Page.postPreviewScreen.route,
          arguments: {"filePath": pickedFile.path, "type": "video"},
        );
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    indexCamera = 1;
    setCamera();

    setState(() async {
      //await controller!.dispose();

      if (pickedFile != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropWidget(
              imageFile: File(pickedFile.path),
            ),
          ),
        );
      }
    });
  }

  Future openCustomGallery() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomGallery(),
      ),
    );
  }

  Future _selectImageOrVideo() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              AppLocalizations.of(context)!.whatWillYouContribute,
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            titleTextStyle: null,
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, "video"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 8),
                      child: Icon(Icons.video_camera_back),
                    ),
                    Text('Video'),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, "image"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 10),
                      child: Icon(Icons.image),
                    ),
                    Text('Image'),
                  ],
                ),
              ),
            ],
          );
        })) {
      case null:
        break;

      case "image":
        getImageFromGallery();
        break;

      case "video":
        getVideoFromGallery();
        break;
    }
  }

  Widget renderButtonsFlashCamera() {
    return IconButton(
      icon: Icon(Icons.no_flash),
      iconSize: 30,
      color: flashIsOff ? Colors.white38 : Colors.white,
      onPressed: () async {
        flashIsOff = controller?.value.flashMode == FlashMode.off;

        setState(() {
          if (flashIsOff) {
            setFlashMode(FlashMode.torch);
            flashIsOff = false;
          } else {
            setFlashMode(FlashMode.off);
            flashIsOff = true;
          }
        });
      },
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
          color: controller!.value.isRecordingVideo ? Colors.red : Colors.white,
        ),
        child: Center(
          child: SizedBox(width: 64, height: 64),
        ),
      ),
    );
  }

  void _takePhoto() async {
    if (!controller!.value.isTakingPicture) {
      if (!controller!.value.isInitialized ||
          controller!.value.isRecordingVideo) {
        return null;
      }

      await controller!.takePicture().then((file) {
        if (mounted) setState(() {});
        if (file != null) {
          GallerySaver.saveImage(file.path).then((res) async {
            String filePath = file.path;
            bool mirroredPhoto = false;

            imageFile = file;

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CropWidget(
                  imageFile: File(filePath),
                  mirroredPhoto: mirroredPhoto,
                ),
              ),
            );
          });
        }
      });
      setState(() {});

      _animController.forward();
    }
  }

  void _tapDown(details) {
    if (!controller!.value.isRecordingVideo) {
      startVideoRecording();
      _animController.forward();
    }
  }

  void _tapUp(context) {
    if (controller!.value.isRecordingVideo) {
      onStopButtonPressed(context);
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 + _animController.value;
    if (controller == null || !controller!.value.isInitialized) {
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
                    messageText: AppLocalizations.of(context)!
                        .youNeedToEnableSomePermissionsToAllowFullUseOfTheCamera,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      final size = MediaQuery.of(context).size;
      var scale = size.aspectRatio * controller!.value.aspectRatio;
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
                child: CameraPreview(controller!),
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
                    onTap: _takePhoto,
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
                      if (!controller!.value.isRecordingVideo) {
                         openCustomGallery();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: GlobalConstants.of(context).spacingSmall),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: FutureBuilder<Uint8List?>(
                          future: lastVideoThumbnail?.thumbData,
                          builder: (_, snapshot) {
                            final bytes = snapshot.data;
                            // If we have no data, display a spinner
                            if (bytes == null) return Icon(Icons.insert_photo);
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
                                child: Image.memory(bytes, fit: BoxFit.cover),
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
