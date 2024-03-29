// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:ootopia_app/screens/auth/register_controller/register_controller.dart';
// import 'package:ootopia_app/screens/components/default_app_bar.dart';

// import 'package:ootopia_app/shared/analytics.server.dart';
// import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
// import 'package:ootopia_app/shared/background_butterfly_top.dart';
// import 'package:ootopia_app/shared/global-constants.dart';
// import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:video_player/video_player.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:syncfusion_flutter_core/theme.dart';

// class RegisterDailyLearningGoalScreen extends StatefulWidget {
//   final Map<String, dynamic>? args;

//   const RegisterDailyLearningGoalScreen([this.args]);

//   @override
//   _RegisterDailyLearningGoalScreenState createState() =>
//       _RegisterDailyLearningGoalScreenState();
// }

// class _RegisterDailyLearningGoalScreenState
//     extends State<RegisterDailyLearningGoalScreen> {
//   double _learningGoalRating = 10;
//   AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
//   late VideoPlayerController _videoPlayerController;
//   bool _isNotLearningGoalRating = false;
//   Timer? timerOpacity;
//   RegisterSecondPhaseController registerController =
//       RegisterSecondPhaseController.getInstance();

//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController = VideoPlayerController.network(
//         'https://videodelivery.net/1a802774c1b694c0554143d69519c598/manifest/video.m3u8')
//       ..initialize().then((value) {
//         _videoPlayerController.play();
//         setState(() {});
//       });
//     setState(() {
//       if (registerController.user!.dailyLearningGoalInMinutes != null &&
//           registerController.user!.dailyLearningGoalInMinutes! >= 10) {
//         _learningGoalRating =
//             registerController.user!.dailyLearningGoalInMinutes!.toDouble();
//       }
//     });
//   }

//   get appBar => DefaultAppBar(
//         components: [
//           AppBarComponents.back,
//         ],
//         onTapLeading: () {
//           Navigator.of(context).pop();
//         },
//       );

//   @override
//   void dispose() {
//     super.dispose();
//     _videoPlayerController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     return Scaffold(
//       appBar: isPortrait ? appBar : null,
//       body: isPortrait
//           ? Stack(
//               children: [
//                 BackgroundButterflyTop(positioned: -59),
//                 BackgroundButterflyBottom(),
//                 SafeArea(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: GlobalConstants.of(context).spacingNormal),
//                     child: CustomScrollView(slivers: [
//                       SliverFillRemaining(
//                         hasScrollBody: false,
//                         fillOverscroll: true,
//                         child: Column(children: [
//                           Expanded(
//                             child: Container(
//                               height:
//                                   registerController.currentSliderValue == 0.0
//                                       ? 625
//                                       : 575,
//                               child: Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 30,
//                                   ),
//                                   Text(
//                                     AppLocalizations.of(context)!
//                                         .regenerationGame,
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 22,
//                                         color: Color(0xff03145C),
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     height: 24,
//                                   ),
//                                   Text(
//                                     AppLocalizations.of(context)!
//                                         .watchVideoToLearn,
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: Color(0xff707070),
//                                         fontWeight: FontWeight.w400),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                       top: 32,
//                                       bottom: 26,
//                                     ),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           _videoPlayerController.value.isPlaying
//                                               ? _videoPlayerController.pause()
//                                               : _videoPlayerController.play();

//                                           timerOpacity?.cancel();
//                                           timerOpacity = Timer(
//                                               Duration(seconds: 1),
//                                               () => setState(
//                                                   () => timerOpacity = null));
//                                         });
//                                       },
//                                       child: Container(
//                                           height: 210,
//                                           width: 360,
//                                           child: Stack(
//                                             children: [
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(4),
//                                                 child: VideoPlayer(
//                                                     _videoPlayerController),
//                                               ),
//                                               _videoPlayerController
//                                                       .value.isPlaying
//                                                   ? AnimatedOpacity(
//                                                       opacity:
//                                                           timerOpacity != null
//                                                               ? 1
//                                                               : 0.0,
//                                                       duration: Duration(
//                                                           milliseconds: 200),
//                                                       child: timerOpacity !=
//                                                               null
//                                                           ? Center(
//                                                               child:
//                                                                   CircleAvatar(
//                                                                 backgroundColor:
//                                                                     Color(
//                                                                         0xff35AD6C),
//                                                                 radius: 28.5,
//                                                                 child: Icon(
//                                                                   Icons.pause,
//                                                                   size: 23,
//                                                                   color: Colors
//                                                                       .white,
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           : IgnorePointer(
//                                                               child: Center(
//                                                                 child:
//                                                                     CircleAvatar(
//                                                                   backgroundColor:
//                                                                       Color(
//                                                                           0xff35AD6C),
//                                                                   radius: 28.5,
//                                                                   child: Icon(
//                                                                     Icons.pause,
//                                                                     size: 23,
//                                                                     color: Colors
//                                                                         .white,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                     )
//                                                   : Center(
//                                                       child: CircleAvatar(
//                                                         backgroundColor:
//                                                             Color(0xff35AD6C),
//                                                         radius: 28.5,
//                                                         child: Icon(
//                                                           Icons.play_arrow,
//                                                           size: 23,
//                                                           color: Colors.white,
//                                                         ),
//                                                       ),
//                                                     ),
//                                               Positioned(
//                                                   bottom: 2,
//                                                   right: 2,
//                                                   child: IconButton(
//                                                       onPressed: () {
//                                                         SystemChrome
//                                                             .setPreferredOrientations([
//                                                           DeviceOrientation
//                                                               .landscapeRight,
//                                                           DeviceOrientation
//                                                               .landscapeLeft
//                                                         ]);
//                                                       },
//                                                       icon: ImageIcon(
//                                                           AssetImage(
//                                                               "assets/icons/icon_maximizescreen.png"),
//                                                           color:
//                                                               Color(0xFFCDCDCD),
//                                                           size: 16)))
//                                             ],
//                                           )),
//                                     ),
//                                   ),
//                                   Divider(
//                                     color: Color(0xff707070).withOpacity(.6),
//                                     height: 1,
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(top: 24, bottom: 24),
//                                     child: Text(
//                                       AppLocalizations.of(context)!
//                                           .chooseYourDailyGoal,
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xff707070),
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     AppLocalizations.of(context)!.minutesPerDay,
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xff707070)),
//                                   ),
//                                   SizedBox(
//                                     height:
//                                         GlobalConstants.of(context).spacingSmall,
//                                   ),
//                                   SfSliderTheme(
//                                     data: SfSliderThemeData(
//                                         activeTrackColor:
//                                             Color(0xff03DAC5).withOpacity(0.08),
//                                         inactiveTrackColor:
//                                             Color(0xff03DAC5).withOpacity(0.3),
//                                         inactiveDividerRadius: 4.8,
//                                         minorTickSize: Size(10, 10),
//                                         tickSize: Size(20, 20),
//                                         thumbColor: Colors.white,
//                                         activeDividerColor: Color(0xff03DAC5),
//                                         overlayColor: Color(0xff03DAC5),
//                                         activeDividerStrokeColor: Color(0xff03DAC5),
//                                         disabledActiveDividerColor:
//                                             Color(0xff03DAC5),
//                                         thumbStrokeColor: Color(0xff03DAC5),
//                                         inactiveTickColor: Color(0xff03DAC5),
//                                         disabledThumbColor: Color(0xff03DAC5),
//                                         activeMinorTickColor: Color(0xff03DAC5),
//                                         inactiveDividerColor: Color(0xff03DAC5),
//                                         overlayRadius: 9,
//                                         inactiveTrackHeight: 9.5,
//                                         trackCornerRadius: 9,
//                                         tickOffset: Offset(10, 10),
//                                         thumbRadius: 9.3,
//                                         activeTrackHeight: 9.5,
//                                         activeLabelStyle: TextStyle(
//                                             color: Colors.grey, fontSize: 14),
//                                         inactiveLabelStyle: TextStyle(
//                                             color: Colors.grey, fontSize: 14),
//                                         activeDividerRadius: 4.8),
//                                     child: SfSlider(
//                                       min: 0.0,
//                                       max: 60,
//                                       value: registerController.currentSliderValue,
//                                       interval: 10,
//                                       stepSize: 10,
//                                       showLabels: true,
//                                       showDividers: true,
//                                       onChanged: (dynamic value) {
//                                         setState(() {
//                                           registerController.currentSliderValue =
//                                               value;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                   _isNotLearningGoalRating
//                                       ? SizedBox(
//                                           height: GlobalConstants.of(context)
//                                               .spacingLarge,
//                                         )
//                                       : Container(),
//                                   _isNotLearningGoalRating
//                                       ? Text(
//                                           AppLocalizations.of(context)!
//                                               .isNotLearningGoalRating,
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w500,
//                                               color: Color(0xff707070)),
//                                         )
//                                       : Container(),
//                                   SizedBox(
//                                     height: GlobalConstants.of(context)
//                                         .spacingNormal,
//                                   ),
//                                   Visibility(
//                                     visible:
//                                         registerController.currentSliderValue ==
//                                             0.0,
//                                     child: Text(
//                                       AppLocalizations.of(context)!
//                                           .settingGoalToZero,
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.grey),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: GlobalConstants.of(context)
//                                         .spacingNormal,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 24, bottom: 20),
//                             child: Container(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ButtonStyle(
//                                   shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(40.0),
//                                       side: BorderSide.none,
//                                     ),
//                                   ),
//                                   minimumSize: MaterialStateProperty.all(
//                                     Size(60, 55),
//                                   ),
//                                   elevation:
//                                       MaterialStateProperty.all<double>(0.0),
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Color(0xff003694)),
//                                   padding:
//                                       MaterialStateProperty.all<EdgeInsets>(
//                                           EdgeInsets.all(
//                                               GlobalConstants.of(context)
//                                                   .spacingNormal)),
//                                 ),
//                                 child: Text(
//                                   AppLocalizations.of(context)!.continueAccess,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   _videoPlayerController.pause();
//                                   registerController
//                                           .user!.dailyLearningGoalInMinutes =
//                                       _learningGoalRating.round();
//                                   this
//                                       .trackingEvents
//                                       .signupCompletedDailyLearning({
//                                     "dailyLearningGoalInMinutes":
//                                         registerController
//                                             .user!.dailyLearningGoalInMinutes
//                                   });
//                                   Navigator.of(context).pushNamed(
//                                     PageRoute
//                                         .Page.registerGeolocationScreen.route,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ]),
//                       ),
//                     ]),
//                   ),
//                 ),
//               ],
//             )
//           : GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _videoPlayerController.value.isPlaying
//                       ? _videoPlayerController.pause()
//                       : _videoPlayerController.play();

//                   timerOpacity?.cancel();
//                   timerOpacity = Timer(Duration(seconds: 1),
//                       () => setState(() => timerOpacity = null));
//                 });
//               },
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: VideoPlayer(_videoPlayerController),
//                   ),
//                   _videoPlayerController.value.isPlaying
//                       ? AnimatedOpacity(
//                           opacity: timerOpacity != null ? 1 : 0.0,
//                           duration: Duration(milliseconds: 200),
//                           child: timerOpacity != null
//                               ? Center(
//                                   child: CircleAvatar(
//                                     backgroundColor: Color(0xff35AD6C),
//                                     radius: 28.5,
//                                     child: Icon(
//                                       Icons.pause,
//                                       size: 23,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 )
//                               : IgnorePointer(
//                                   child: Center(
//                                     child: CircleAvatar(
//                                       backgroundColor: Color(0xff35AD6C),
//                                       radius: 28.5,
//                                       child: Icon(
//                                         Icons.pause,
//                                         size: 23,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                         )
//                       : Center(
//                           child: CircleAvatar(
//                             backgroundColor: Color(0xff35AD6C),
//                             radius: 28.5,
//                             child: Icon(
//                               Icons.play_arrow,
//                               size: 23,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                   Positioned(
//                       bottom: 2,
//                       right: 2,
//                       child: IconButton(
//                           onPressed: () {
//                             SystemChrome.setPreferredOrientations([
//                               DeviceOrientation.portraitUp,
//                               DeviceOrientation.portraitDown
//                             ]);
//                           },
//                           icon: ImageIcon(
//                               AssetImage(
//                                   "assets/icons/icon_minimizescreen.png"),
//                               color: Color(0xFFCDCDCD),
//                               size: 16)))
//                 ],
//               ),
//             ),
//     );
//   }
// }
