import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/view_learning_tracks.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LastLearningTrackComponents extends StatefulWidget {
  const LastLearningTrackComponents({Key? key}) : super(key: key);

  @override
  _LastLearningTrackComponentsState createState() =>
      _LastLearningTrackComponentsState();
}

class _LastLearningTrackComponentsState
    extends State<LastLearningTrackComponents> {
  LearningTracksStore learningTracksStore = LearningTracksStore();
  SmartPageController controller = SmartPageController.getInstance();
  LearningTracksModel? teste;
  bool haveSvg = false;
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await learningTracksStore.lastLearningTracks();
      setState(() {
        teste = learningTracksStore.getLastLearningTracks[0];
        haveSvg = teste!.imageUrl.contains('.svg');
        imageUrl = teste!.imageUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/compass.png',
                    width: 21,
                    height: 21,
                  ),
                  SizedBox(
                    width: 9.5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.learningTracks,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  controller.selectBottomTab(1);
                },
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.seeAll,
                      style: TextStyle(
                        color: Color(0xff003694),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xff003694),
                      size: 15,
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 16,
              ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  controller.insertPage(ViewLearningTracksScreen({
                    'list_chapters': teste!.chapters,
                    'description': teste!.description,
                    'title': teste!.title,
                  }));
                },
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: haveSvg
                            ? SvgPicture.network(
                                imageUrl,
                                width: 52,
                                height: 52,
                              )
                            : Image.network(
                                imageUrl,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
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
                              teste!.title,
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
                                '${teste!.totalTimeInMinutes} min',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              CircleAvatar(
                                radius: 1,
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              SvgPicture.asset(
                                'assets/icons/ooz_mini_blue.svg',
                                height: 10,
                                width: 19.33,
                                color: Color(0xffA3A3A3),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '${teste!.ooz.toString().replaceAll('.', ',')}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 13,
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
