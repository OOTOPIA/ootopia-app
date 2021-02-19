// import 'dart:async';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// // Future<void> main() async {
// //   // Fetch the available cameras before initializing the app.
// //   try {
// //     WidgetsFlutterBinding.ensureInitialized();
// //     cameras = await availableCameras();
// //   } on CameraException catch (e) {
// //     logError(e.code, e.description);
// //   }
// //   runApp(CameraApp());
// // }

// class CameraApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CameraExampleHome(),
//     );
//   }
// }

// class CameraExampleHome extends StatefulWidget {
//   @override
//   _CameraExampleHomeState createState() {
//     return _CameraExampleHomeState();
//   }
// }

// /// Returns a suitable camera icon for [direction].
// IconData getCameraLensIcon(CameraLensDirection direction) {
//   print("eae $direction");

//   switch (direction) {
//     case CameraLensDirection.back:
//       return Icons.camera_rear;
//     case CameraLensDirection.front:
//       return Icons.camera_front;
//     case CameraLensDirection.external:
//       return Icons.camera;
//   }
//   throw ArgumentError('Unknown lens direction');
// }

// void logError(String code, String message) =>
//     print('Error: $code\nError Message: $message');

// class _CameraExampleHomeState extends State<CameraExampleHome>
//     with WidgetsBindingObserver, TickerProviderStateMixin {
//   CameraController controller;
//   XFile imageFile;
//   XFile videoFile;
//   VideoPlayerController videoController;
//   VoidCallback videoPlayerListener;
//   bool enableAudio = true;
//   double _minAvailableExposureOffset = 0.0;
//   double _maxAvailableExposureOffset = 0.0;
//   double _currentExposureOffset = 0.0;
//   AnimationController _flashModeControlRowAnimationController;
//   Animation<double> _flashModeControlRowAnimation;
//   AnimationController _exposureModeControlRowAnimationController;
//   Animation<double> _exposureModeControlRowAnimation;
//   AnimationController _focusModeControlRowAnimationController;
//   Animation<double> _focusModeControlRowAnimation;
//   double _minAvailableZoom;
//   double _maxAvailableZoom;
//   double _currentScale = 1.0;
//   double _baseScale = 1.0;

//   // Counting pointers (number of user fingers on screen)
//   int _pointers = 0;

//   List<CameraDescription> cameras = [];

//   @override
//   void initState() {
//     super.initState();
//     checkCameraAvailability();

//     WidgetsBinding.instance.addObserver(this);
//     _flashModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _flashModeControlRowAnimation = CurvedAnimation(
//       parent: _flashModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//     _exposureModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _exposureModeControlRowAnimation = CurvedAnimation(
//       parent: _exposureModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//     _focusModeControlRowAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _focusModeControlRowAnimation = CurvedAnimation(
//       parent: _focusModeControlRowAnimationController,
//       curve: Curves.easeInCubic,
//     );
//   }

//   Future<void> checkCameraAvailability() async {
//     try {
//       WidgetsFlutterBinding.ensureInitialized();
//       this.cameras = await availableCameras();
//     } on CameraException catch (e) {
//       logError(e.code, e.description);
//     }

//     print('CAMERA ${this.cameras}');
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _flashModeControlRowAnimationController.dispose();
//     _exposureModeControlRowAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // App state changed before we got the chance to initialize.
//     if (controller == null || !controller.value.isInitialized) {
//       return;
//     }
//     if (state == AppLifecycleState.inactive) {
//       controller?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       if (controller != null) {
//         onNewCameraSelected(controller.description);
//       }
//     }
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(1.0),
//                 child: Center(
//                   child: _cameraPreviewWidget(),
//                 ),
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 border: Border.all(
//                   color: controller != null && controller.value.isRecordingVideo
//                       ? Colors.redAccent
//                       : Colors.grey,
//                   width: 3.0,
//                 ),
//               ),
//             ),
//           ),
//           // _captureControlRowWidget(),
//           // _modeControlRowWidget(),
//           Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 _cameraTogglesRowWidget(),
//                 _thumbnailWidget(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Display the preview from the camera (or a message if the preview is not available).
//   Widget _cameraPreviewWidget() {
//     if (controller == null || !controller.value.isInitialized) {
//       return const Text(
//         'Tap a camera',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return Listener(
//         onPointerDown: (_) => _pointers++,
//         onPointerUp: (_) => _pointers--,
//         child: CameraPreview(
//           controller,
//           child: LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//             return GestureDetector(
//               behavior: HitTestBehavior.opaque,
//               onScaleStart: _handleScaleStart,
//               onScaleUpdate: _handleScaleUpdate,
//               onTapDown: (details) => onViewFinderTap(details, constraints),
//             );
//           }),
//         ),
//       );
//     }
//   }

//   void _handleScaleStart(ScaleStartDetails details) {
//     _baseScale = _currentScale;
//   }

//   Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
//     // When there are not exactly two fingers on screen don't scale
//     if (_pointers != 2) {
//       return;
//     }

//     _currentScale = (_baseScale * details.scale)
//         .clamp(_minAvailableZoom, _maxAvailableZoom);

//     await controller.setZoomLevel(_currentScale);
//   }

//   /// Display the thumbnail of the captured image or video.
//   Widget _thumbnailWidget() {
//     return Expanded(
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             videoController == null && imageFile == null
//                 ? Container()
//                 : SizedBox(
//                     child: (videoController == null)
//                         ? Image.file(File(imageFile.path))
//                         : Container(
//                             child: Center(
//                               child: AspectRatio(
//                                   aspectRatio:
//                                       videoController.value.size != null
//                                           ? videoController.value.aspectRatio
//                                           : 1.0,
//                                   child: VideoPlayer(videoController)),
//                             ),
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.pink)),
//                           ),
//                     width: 64.0,
//                     height: 64.0,
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Display a bar with buttons to change the flash and exposure modes
//   Widget _modeControlRowWidget() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.flash_on),
//               color: Colors.blue,
//               onPressed: controller != null ? onFlashModeButtonPressed : null,
//             ),
//             IconButton(
//               icon: Icon(Icons.exposure),
//               color: Colors.blue,
//               onPressed:
//                   controller != null ? onExposureModeButtonPressed : null,
//             ),
//             IconButton(
//               icon: Icon(Icons.filter_center_focus),
//               color: Colors.blue,
//               onPressed: controller != null ? onFocusModeButtonPressed : null,
//             ),
//             IconButton(
//               icon: Icon(enableAudio ? Icons.volume_up : Icons.volume_mute),
//               color: Colors.blue,
//               onPressed: controller != null ? onAudioModeButtonPressed : null,
//             ),
//             IconButton(
//               icon: Icon(controller?.value?.isCaptureOrientationLocked ?? false
//                   ? Icons.screen_lock_rotation
//                   : Icons.screen_rotation),
//               color: Colors.blue,
//               onPressed: controller != null
//                   ? onCaptureOrientationLockButtonPressed
//                   : null,
//             ),
//           ],
//         ),
//         _flashModeControlRowWidget(),
//         _exposureModeControlRowWidget(),
//         _focusModeControlRowWidget(),
//       ],
//     );
//   }

//   Widget _flashModeControlRowWidget() {
//     return SizeTransition(
//       sizeFactor: _flashModeControlRowAnimation,
//       child: ClipRect(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             IconButton(
//               icon: Icon(Icons.flash_off),
//               color: controller?.value?.flashMode == FlashMode.off
//                   ? Colors.orange
//                   : Colors.blue,
//               onPressed: controller != null
//                   ? () => onSetFlashModeButtonPressed(FlashMode.off)
//                   : null,
//             ),
//             IconButton(
//               icon: Icon(Icons.flash_auto),
//               color: controller?.value?.flashMode == FlashMode.auto
//                   ? Colors.orange
//                   : Colors.blue,
//               onPressed: controller != null
//                   ? () => onSetFlashModeButtonPressed(FlashMode.auto)
//                   : null,
//             ),
//             IconButton(
//               icon: Icon(Icons.flash_on),
//               color: controller?.value?.flashMode == FlashMode.always
//                   ? Colors.orange
//                   : Colors.blue,
//               onPressed: controller != null
//                   ? () => onSetFlashModeButtonPressed(FlashMode.always)
//                   : null,
//             ),
//             IconButton(
//               icon: Icon(Icons.highlight),
//               color: controller?.value?.flashMode == FlashMode.torch
//                   ? Colors.orange
//                   : Colors.blue,
//               onPressed: controller != null
//                   ? () => onSetFlashModeButtonPressed(FlashMode.torch)
//                   : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _exposureModeControlRowWidget() {
//     final ButtonStyle styleAuto = TextButton.styleFrom(
//       primary: controller?.value?.exposureMode == ExposureMode.auto
//           ? Colors.orange
//           : Colors.blue,
//     );
//     final ButtonStyle styleLocked = TextButton.styleFrom(
//       primary: controller?.value?.exposureMode == ExposureMode.locked
//           ? Colors.orange
//           : Colors.blue,
//     );

//     return SizeTransition(
//       sizeFactor: _exposureModeControlRowAnimation,
//       child: ClipRect(
//         child: Container(
//           color: Colors.grey.shade50,
//           child: Column(
//             children: [
//               Center(
//                 child: Text("Exposure Mode"),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   TextButton(
//                     child: Text('AUTO'),
//                     style: styleAuto,
//                     onPressed: controller != null
//                         ? () =>
//                             onSetExposureModeButtonPressed(ExposureMode.auto)
//                         : null,
//                     onLongPress: () {
//                       if (controller != null) controller.setExposurePoint(null);
//                       showInSnackBar('Resetting exposure point');
//                     },
//                   ),
//                   TextButton(
//                     child: Text('LOCKED'),
//                     style: styleLocked,
//                     onPressed: controller != null
//                         ? () =>
//                             onSetExposureModeButtonPressed(ExposureMode.locked)
//                         : null,
//                   ),
//                 ],
//               ),
//               Center(
//                 child: Text("Exposure Offset"),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Text(_minAvailableExposureOffset.toString()),
//                   Slider(
//                     value: _currentExposureOffset,
//                     min: _minAvailableExposureOffset,
//                     max: _maxAvailableExposureOffset,
//                     label: _currentExposureOffset.toString(),
//                     onChanged: _minAvailableExposureOffset ==
//                             _maxAvailableExposureOffset
//                         ? null
//                         : setExposureOffset,
//                   ),
//                   Text(_maxAvailableExposureOffset.toString()),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _focusModeControlRowWidget() {
//     final ButtonStyle styleAuto = TextButton.styleFrom(
//       primary: controller?.value?.focusMode == FocusMode.auto
//           ? Colors.orange
//           : Colors.blue,
//     );
//     final ButtonStyle styleLocked = TextButton.styleFrom(
//       primary: controller?.value?.focusMode == FocusMode.locked
//           ? Colors.orange
//           : Colors.blue,
//     );

//     return SizeTransition(
//       sizeFactor: _focusModeControlRowAnimation,
//       child: ClipRect(
//         child: Container(
//           color: Colors.grey.shade50,
//           child: Column(
//             children: [
//               Center(
//                 child: Text("Focus Mode"),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   TextButton(
//                     child: Text('AUTO'),
//                     style: styleAuto,
//                     onPressed: controller != null
//                         ? () => onSetFocusModeButtonPressed(FocusMode.auto)
//                         : null,
//                     onLongPress: () {
//                       if (controller != null) controller.setFocusPoint(null);
//                       showInSnackBar('Resetting focus point');
//                     },
//                   ),
//                   TextButton(
//                     child: Text('LOCKED'),
//                     style: styleLocked,
//                     onPressed: controller != null
//                         ? () => onSetFocusModeButtonPressed(FocusMode.locked)
//                         : null,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Display the control bar with buttons to take pictures and record videos.
//   Widget _captureControlRowWidget() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       mainAxisSize: MainAxisSize.max,
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.camera_alt),
//           color: Colors.blue,
//           onPressed: controller != null &&
//                   controller.value.isInitialized &&
//                   !controller.value.isRecordingVideo
//               ? onTakePictureButtonPressed
//               : null,
//         ),
//         IconButton(
//           icon: const Icon(Icons.videocam),
//           color: Colors.blue,
//           onPressed: controller != null &&
//                   controller.value.isInitialized &&
//                   !controller.value.isRecordingVideo
//               ? onVideoRecordButtonPressed
//               : null,
//         ),
//         IconButton(
//           icon: controller != null && controller.value.isRecordingPaused
//               ? Icon(Icons.play_arrow)
//               : Icon(Icons.pause),
//           color: Colors.blue,
//           onPressed: controller != null &&
//                   controller.value.isInitialized &&
//                   controller.value.isRecordingVideo
//               ? (controller != null && controller.value.isRecordingPaused
//                   ? onResumeButtonPressed
//                   : onPauseButtonPressed)
//               : null,
//         ),
//         IconButton(
//           icon: const Icon(Icons.stop),
//           color: Colors.red,
//           onPressed: controller != null &&
//                   controller.value.isInitialized &&
//                   controller.value.isRecordingVideo
//               ? onStopButtonPressed
//               : null,
//         )
//       ],
//     );
//   }

//   /// Display a row of toggle to select the camera (or a message if no camera is available).
//   Widget _cameraTogglesRowWidget() {
//     final List<Widget> toggles = <Widget>[];

//     if (this.cameras.isEmpty) {
//       return const Text('No camera found');
//     } else {
//       for (CameraDescription cameraDescription in cameras) {
//         toggles.add(
//           SizedBox(
//             width: 90.0,
//             child: RadioListTile<CameraDescription>(
//               title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
//               groupValue: controller?.description,
//               value: cameraDescription,
//               onChanged: controller != null && controller.value.isRecordingVideo
//                   ? null
//                   : onNewCameraSelected,
//             ),
//           ),
//         );
//       }
//     }

//     return Row(children: toggles);
//   }

//   String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

//   void showInSnackBar(String message) {
//     // ignore: deprecated_member_use
//     _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
//   }

//   void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
//     final offset = Offset(
//       details.localPosition.dx / constraints.maxWidth,
//       details.localPosition.dy / constraints.maxHeight,
//     );
//     controller.setExposurePoint(offset);
//     controller.setFocusPoint(offset);
//   }
//aqui
//   void onNewCameraSelected(CameraDescription cameraDescription) async {
//     if (controller != null) {
//       await controller.dispose();
//     }
//     controller = CameraController(
//       cameraDescription,
//       ResolutionPreset.medium,
//       enableAudio: enableAudio,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );

//     // If the controller is updated then update the UI.
//     controller.addListener(() {
//       if (mounted) setState(() {});
//       if (controller.value.hasError) {
//         showInSnackBar('Camera error ${controller.value.errorDescription}');
//       }
//     });

//     try {
//       await controller.initialize();
//       await Future.wait([
//         controller
//             .getMinExposureOffset()
//             .then((value) => _minAvailableExposureOffset = value),
//         controller
//             .getMaxExposureOffset()
//             .then((value) => _maxAvailableExposureOffset = value),
//         controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
//         controller.getMinZoomLevel().then((value) => _minAvailableZoom = value),
//       ]);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void onTakePictureButtonPressed() {
//     takePicture().then((XFile file) {
//       if (mounted) {
//         setState(() {
//           imageFile = file;
//           videoController?.dispose();
//           videoController = null;
//         });
//         if (file != null) showInSnackBar('Picture saved to ${file.path}');
//       }
//     });
//   }

//   void onFlashModeButtonPressed() {
//     if (_flashModeControlRowAnimationController.value == 1) {
//       _flashModeControlRowAnimationController.reverse();
//     } else {
//       _flashModeControlRowAnimationController.forward();
//       _exposureModeControlRowAnimationController.reverse();
//       _focusModeControlRowAnimationController.reverse();
//     }
//   }

//   void onExposureModeButtonPressed() {
//     if (_exposureModeControlRowAnimationController.value == 1) {
//       _exposureModeControlRowAnimationController.reverse();
//     } else {
//       _exposureModeControlRowAnimationController.forward();
//       _flashModeControlRowAnimationController.reverse();
//       _focusModeControlRowAnimationController.reverse();
//     }
//   }

//   void onFocusModeButtonPressed() {
//     if (_focusModeControlRowAnimationController.value == 1) {
//       _focusModeControlRowAnimationController.reverse();
//     } else {
//       _focusModeControlRowAnimationController.forward();
//       _flashModeControlRowAnimationController.reverse();
//       _exposureModeControlRowAnimationController.reverse();
//     }
//   }

//   void onAudioModeButtonPressed() {
//     enableAudio = !enableAudio;
//     if (controller != null) {
//       onNewCameraSelected(controller.description);
//     }
//   }

//   void onCaptureOrientationLockButtonPressed() async {
//     if (controller != null) {
//       if (controller.value.isCaptureOrientationLocked) {
//         await controller.unlockCaptureOrientation();
//         showInSnackBar('Capture orientation unlocked');
//       } else {
//         await controller.lockCaptureOrientation();
//         showInSnackBar(
//             'Capture orientation locked to ${controller.value.lockedCaptureOrientation.toString().split('.').last}');
//       }
//     }
//   }

//   void onSetFlashModeButtonPressed(FlashMode mode) {
//     // print("Fui chamado1");

//     setFlashMode(mode).then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
//     });
//   }

//   void onSetExposureModeButtonPressed(ExposureMode mode) {
//     // print("Fui chamado2");

//     setExposureMode(mode).then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
//     });
//   }

//   void onSetFocusModeButtonPressed(FocusMode mode) {
//     // print("Fui chamado3");

//     setFocusMode(mode).then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
//     });
//   }

//   void onVideoRecordButtonPressed() {
//     startVideoRecording().then((_) {
//       if (mounted) setState(() {});
//     });
//   }

//   void onStopButtonPressed() {
//     stopVideoRecording().then((file) {
//       if (mounted) setState(() {});
//       if (file != null) {
//         showInSnackBar('Video recorded to ${file.path}');
//         videoFile = file;
//         _startVideoPlayer();
//       }
//     });
//   }

//   void onPauseButtonPressed() {
//     pauseVideoRecording().then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Video recording paused');
//     });
//   }

//   void onResumeButtonPressed() {
//     resumeVideoRecording().then((_) {
//       if (mounted) setState(() {});
//       showInSnackBar('Video recording resumed');
//     });
//   }

//   Future<void> startVideoRecording() async {
//     if (!controller.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return;
//     }

//     if (controller.value.isRecordingVideo) {
//       // A recording is already started, do nothing.
//       return;
//     }

//     try {
//       await controller.startVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return;
//     }
//   }

//   Future<XFile> stopVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       return controller.stopVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }

//   Future<void> pauseVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       await controller.pauseVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> resumeVideoRecording() async {
//     if (!controller.value.isRecordingVideo) {
//       return null;
//     }

//     try {
//       await controller.resumeVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setFlashMode(FlashMode mode) async {
//     try {
//       await controller.setFlashMode(mode);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setExposureMode(ExposureMode mode) async {
//     try {
//       await controller.setExposureMode(mode);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setExposureOffset(double offset) async {
//     setState(() {
//       _currentExposureOffset = offset;
//     });
//     try {
//       offset = await controller.setExposureOffset(offset);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> setFocusMode(FocusMode mode) async {
//     try {
//       await controller.setFocusMode(mode);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       rethrow;
//     }
//   }

//   Future<void> _startVideoPlayer() async {
//     final VideoPlayerController vController =
//         VideoPlayerController.file(File(videoFile.path));
//     videoPlayerListener = () {
//       if (videoController != null && videoController.value.size != null) {
//         // Refreshing the state to update video player with the correct ratio.
//         if (mounted) setState(() {});
//         videoController.removeListener(videoPlayerListener);
//       }
//     };
//     vController.addListener(videoPlayerListener);
//     await vController.setLooping(true);
//     await vController.initialize();
//     await videoController?.dispose();
//     if (mounted) {
//       setState(() {
//         imageFile = null;
//         videoController = vController;
//       });
//     }
//     await vController.play();
//   }

//   Future<XFile> takePicture() async {
//     if (!controller.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return null;
//     }

//     if (controller.value.isTakingPicture) {
//       // A capture is already pending, do nothing.
//       return null;
//     }

//     try {
//       XFile file = await controller.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }

//   void _showCameraException(CameraException e) {
//     logError(e.code, e.description);
//     showInSnackBar('Error: ${e.code}\n${e.description}');
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:flutter_uploader/flutter_uploader.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  List<CameraDescription> cameras;
  int indexCamera = 1;
  bool isRecord = false;
  XFile imageFile;
  XFile videoFile;

  final uploader = FlutterUploader();

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

    print('CAMERA ${this.cameras}');
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
      ResolutionPreset.ultraHigh,
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
    print('Olá');

    if (!controller.value.isInitialized || controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.startVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return;
    }
  }

  void uploadFileBackground(XFile file) async {
    // uploader

    await uploader.enqueue(
        url: "your upload link", //required: url to upload to
        files: [
          FileItem(
            filename: file.name,
            savedDir: file.path,
            fieldname: "file",
          )
        ], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        headers: {"apikey": "api_123456", "userkey": "userkey_123456"},
        data: {"name": "john"}, // any data you want to send in upload request
        showNotification:
            false, // send local notification (android only) for upload status
        tag: "upload 1"); // unique tag for upload task
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) {
      print('file ${file.name}');
      print('file ${file.path}');

      if (mounted) setState(() {});
      if (file != null) {
        GallerySaver.saveVideo(file.path).then((path) {
          // setState(() {
          //   secondButtonText = 'video saved!';
          // });
          print('Foi aqui ---------');
          print('Foi path --------- $path');
        });
        // showInSnackBar('Video recorded to ${file.path}');
        videoFile = file;
        // uploadFileBackground(file);
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
    print('mode $mode');

    setFlashMode(mode).then((_) {
      if (mounted) setState(() {});
      // showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    print('Hello $mode');

    try {
      print('deu certo');
      await controller.setFlashMode(mode);
    } on CameraException catch (e) {
      print('Erro da camera $e');
      rethrow;
    }
  }

  Widget renderButtonsFlashCamera() {
    if (false && indexCamera == 0) {
      print('Foi aqui1');
      return IconButton(
        icon: Icon(Icons.flash_off),
        iconSize: 30,
        color: Colors.white,
        onPressed: () => onSetFlashModeButtonPressed(FlashMode.off),
      );
    } else if (true && indexCamera == 0) {
      print('Foi aqui2');

      return IconButton(
        icon: Icon(Icons.flash_on),
        iconSize: 30,
        color: Colors.white,
        onPressed: () => onSetFlashModeButtonPressed(FlashMode.always),
      );
    } else {
      print('Foi aqui3');

      return IconButton(
        icon: Icon(Icons.no_flash),
        iconSize: 30,
        color: Colors.white38,
        onPressed: () {},
      );
    }
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
                    } else {
                      onStopButtonPressed();
                    }
                  }),
              IconButton(
                icon: Icon(
                    indexCamera == 0 ? Icons.camera_front : Icons.camera_rear),
                iconSize: 30,
                color: Colors.white,
                onPressed: () => setCamera(),
              ),
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
