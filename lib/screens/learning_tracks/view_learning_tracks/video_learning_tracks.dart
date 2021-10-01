import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class VideoLeaningTracks extends StatefulWidget {
  @override
  _VideoLeaningTracksState createState() => _VideoLeaningTracksState();
}

class _VideoLeaningTracksState extends State<VideoLeaningTracks> {
  late VideoPlayerController _videoPlayerController;
  Timer? timerOpacity;
  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/ootopia_learning.mp4')
          ..initialize().then((value) {
            _videoPlayerController.play();
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                VideoPlayer(_videoPlayerController),
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
                        )))
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
                fontWeight: FontWeight.bold,
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
