import 'package:flutter/material.dart';
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
  LearningTracksModel? lastLearningTracks;

  LearningTracksStore learningTracksStore = LearningTracksStore();
  SmartPageController controller = SmartPageController.getInstance();
  bool haveSvg = false;

  @override
  void initState() {
    performRequest();

    super.initState();
  }

  void performRequest() async {
    await learningTracksStore.lastLearningTracks();
    setState(() {
      lastLearningTracks = learningTracksStore.getLastLearningTracks;
    });
  }

  @override
  Widget build(BuildContext context) {
    haveSvg = lastLearningTracks!.imageUrl.contains('.svg');
    return lastLearningTracks == null
        ? Container()
        : Container(
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
                          'list_chapters': lastLearningTracks!.chapters,
                          'description': lastLearningTracks!.description,
                          'title': lastLearningTracks!.title,
                        }));
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: haveSvg
                                  ? SvgPicture.network(
                                      lastLearningTracks!.imageUrl,
                                      width: 52,
                                      height: 52,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      lastLearningTracks!.imageUrl,
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
                                    lastLearningTracks!.title,
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
                                      '${lastLearningTracks!.totalTimeInMinutes} min',
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
                                      '${lastLearningTracks!.ooz.toString().replaceAll('.', ',')}',
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
