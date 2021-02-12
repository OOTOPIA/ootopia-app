import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:video_player/video_player.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ootopia',
          // 'App Teste',
          style: GoogleFonts.jomhuria(
              fontStyle: FontStyle.normal, color: Colors.blue, fontSize: 42),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          PhotoTimeline(
            urlVideo: 'https://ootopia-staging.s3.amazonaws.com/nature001.mp4',
            urlImageProfile: 'assets/images/profile01.jpeg',
            nameUser: 'Carla Esteves',
          ),
          PhotoTimeline(
            urlVideo: 'https://ootopia-staging.s3.amazonaws.com/nature002.mp4',
            urlImageProfile: 'assets/images/profile02.jpeg',
            nameUser: 'Jorge Santos',
          ),
          PhotoTimeline(
            urlVideo:
                'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
            urlImageProfile: 'assets/images/profile03.jpeg',
            nameUser: 'Alice Silva',
          ),
        ],
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}

class PhotoTimeline extends StatelessWidget {
  String urlVideo;
  String urlImageProfile;
  String nameUser;

  PhotoTimeline({this.urlVideo, this.urlImageProfile, this.nameUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(this.urlImageProfile),
                      minRadius: 16,
                    ),
                  ),
                  Text(
                    this.nameUser,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              IconButton(
                icon: ImageIcon(
                  AssetImage('assets/icons/options_group.png'),
                  color: Colors.black12,
                ),
                onPressed: null,
              ),
            ],
          ),
          PlayerVideo(url: this.urlVideo),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/icons/heart.png'),
                      color: Colors.black12,
                    ),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/icons/comment.png'),
                      color: Colors.black12,
                    ),
                    onPressed: null,
                  ),
                ],
              ),
              IconButton(
                icon: ImageIcon(
                  AssetImage('assets/icons/bookmark.png'),
                  color: Colors.black12,
                ),
                onPressed: null,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          // Row(
          //   children: [
          //     Text('Likes 241'),
          //     Row(
          //       children: [Text(' 13,55')],
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}

class PlayerVideo extends StatefulWidget {
  String url;

  PlayerVideo({this.url});

  @override
  _PlayerVideoState createState() => _PlayerVideoState(url: this.url);
}

class _PlayerVideoState extends State<PlayerVideo> {
  String url;

  _PlayerVideoState({this.url});

  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(this.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  void myFunc() {
    print("Chamado");
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });

    print(_controller);
  }

  iconPlayAndPause() {
    if (_controller.value.isPlaying) {
      return Visibility(
        child: Icon(Icons.pause),
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: false,
      );
    } else {
      return Icon(Icons.play_arrow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: double.infinity,
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(
                  alignment: AlignmentDirectional.center,
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
        IconButton(
          icon: iconPlayAndPause(),
          color: Colors.white,
          onPressed: myFunc,
        )
      ],
    );
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
