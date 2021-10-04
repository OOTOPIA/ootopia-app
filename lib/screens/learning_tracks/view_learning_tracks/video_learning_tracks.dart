import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:video_player/video_player.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class VideoLeaningTracks extends StatefulWidget {
  @override
  _VideoLeaningTracksState createState() => _VideoLeaningTracksState();
}

class _VideoLeaningTracksState extends State<VideoLeaningTracks> {
  late VideoPlayerController _videoPlayerController;
  double currentValueSlider = 0;
  Timer? timerOpacity;
  double startTime = 0;
  Duration? teste;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    print('${DeviceOrientation.landscapeLeft}');
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/ootopia_learning.mp4')
          ..initialize().then((value) {
            _videoPlayerController.play();
          });
    // teste = _videoPlayerController.value.duration;
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == DeviceOrientation.landscapeLeft) {
      print('t');
    }
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Padding(
      //     padding: EdgeInsets.all(3),
      //     child: Image.asset(
      //       'assets/images/logo.png',
      //       height: 34,
      //     ),
      //   ),
      //   toolbarHeight: 45,
      //   elevation: 2,
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   leading: Padding(
      //     padding: EdgeInsets.only(
      //       left: GlobalConstants.of(context).screenHorizontalSpace,
      //     ),
      //     child: InkWell(
      //         onTap: () => Navigator.of(context).pop(),
      //         child: Padding(
      //             padding: const EdgeInsets.only(left: 3.0),
      //             child: Row(
      //               children: [
      //                 Icon(
      //                   FeatherIcons.arrowLeft,
      //                   color: Colors.black,
      //                   size: 20,
      //                 ),
      //                 Text(
      //                   AppLocalizations.of(context)!.back,
      //                   style: GoogleFonts.roboto(
      //                     fontSize:
      //                         Theme.of(context).textTheme.subtitle1!.fontSize,
      //                     color: Colors.black,
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                 )
      //               ],
      //             ))),
      //   ),
      // ),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                OrientationBuilder(builder: (context, orientation) {
                  print(orientation);
                  return VideoPlayer(_videoPlayerController);
                }),
                Align(
                    alignment: Alignment.center,
                    child: AnimatedOpacity(
                        opacity: timerOpacity != null ? 1 : 0.0,
                        duration: Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _videoPlayerController.value.isPlaying
                                  ? _videoPlayerController.pause()
                                  : _videoPlayerController.play();
                              startTime = _videoPlayerController
                                  .value.position.inSeconds
                                  .toDouble();
                              currentValueSlider = _videoPlayerController
                                  .value.position.inSeconds
                                  .toDouble();

                              timerOpacity?.cancel();
                              timerOpacity = Timer(Duration(seconds: 1),
                                  () => setState(() => timerOpacity = null));
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Color(0xff35AD6C),
                            radius: 28.5,
                            child: Icon(
                              (_videoPlayerController.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              size: 23,
                              color: Colors.white,
                            ),
                          ),
                        ))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 25,
                    color: Colors.amber,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text('1'),
                        Expanded(
                          child: Slider(
                            thumbColor: Colors.transparent,
                            min: 0,
                            max: _videoPlayerController
                                .value.buffered.first.end.inMilliseconds
                                .toDouble(),
                            value: currentValueSlider,
                            onChanged: (value) {
                              setState(() {
                                startTime = value;
                                currentValueSlider = value;
                                print(value);
                              });
                            },
                          ),
                        ),
                        Text(_videoPlayerController.value.duration.inMinutes
                            .toString()),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 26,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 68.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(276, 53)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide.none),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff003694)),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                ),
                onPressed: () {
                  _videoPlayerController.pause();
                  Navigator.of(context)
                      .pushNamed(PageRoute.Page.aboutQuizScreen.route);
                },
                child: Text(
                  AppLocalizations.of(context)!.quiz,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 68.0),
            child: Text(
              AppLocalizations.of(context)!.respondQuiz,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 19,
          ),
        ],
      ),
    );
  }
}
