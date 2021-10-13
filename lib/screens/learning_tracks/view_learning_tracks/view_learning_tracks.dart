import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/learning_tracks/chapters_model.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/watch_video_learning_tracks.dart';

class ViewLearningTracksScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  ViewLearningTracksScreen(this.args);
  @override
  _ViewLearningTracksScreenState createState() =>
      _ViewLearningTracksScreenState();
}

class _ViewLearningTracksScreenState extends State<ViewLearningTracksScreen> {
  List<ChaptersModel>? listChapters;
  LearningTracksModel? learningTracks;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    listChapters = widget.args['list_chapters'];
    learningTracks = widget.args['learning_tracks'];
  }

  void updateStatusVideoChapter() {
    if (learningTracks?.completed != true) {
      bool allVideosOfTheChaptersSeen =
          listChapters!.every((chapter) => chapter.completed == true);
      widget.args['updateLearningTrack']();

      learningTracks!.completed = allVideosOfTheChaptersSeen;
      setState(() {});
    }
  }

  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 24),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.network(
                learningTracks!.imageUrl,
                height: 162,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.only(top: 120),
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          '${learningTracks!.title}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          "${learningTracks!.description}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listChapters!.length,
                            itemBuilder: (context, index) {
                              var chapter = listChapters![index];
                              var haveSvg =
                                  chapter.videoThumbUrl.contains('.svg');
                              return InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return WatchVideoLeaningTracks(
                                      learningTrack: learningTracks,
                                      chapter: chapter,
                                      updateStatusVideoChapter:
                                          updateStatusVideoChapter,
                                    );
                                  }));
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                child: haveSvg
                                                    ? SvgPicture.network(
                                                        chapter.videoThumbUrl,
                                                        width: 80,
                                                        height: 80,
                                                      )
                                                    : Image.network(
                                                        chapter.videoThumbUrl,
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  decoration:
                                                      BoxDecoration(boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 20,
                                                      color: Colors.black
                                                          .withOpacity(0.16),
                                                      offset: Offset(0, 3),
                                                      spreadRadius: 0,
                                                    )
                                                  ]),
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 35,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  chapter.title,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    chapter.time,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 1,
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/icons/ooz_mini_blue.svg',
                                                    height: 10,
                                                    width: 19.33,
                                                    color: chapter.completed ==
                                                            true
                                                        ? Color(0xff018F9C)
                                                        : Color(0xffA3A3A3),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    '${currencyFormatter.format(chapter.ooz)}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: chapter
                                                                  .completed ==
                                                              true
                                                          ? Color(0xff018F9C)
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (chapter.completed == true)
                                          SvgPicture.asset(
                                            'assets/icons/Icon-feather-check-circle.svg',
                                            height: 19,
                                            width: 19,
                                            color: Color(0xff018F9C),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    index == listChapters!.length - 1
                                        ? Container()
                                        : Divider(
                                            color: Colors.grey,
                                          ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
