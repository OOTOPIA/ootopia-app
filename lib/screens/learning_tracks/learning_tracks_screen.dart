import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/view_learning_tracks.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LearningTracksScreen extends StatefulWidget {
  @override
  _LearningTracksScreenState createState() => _LearningTracksScreenState();
}

class _LearningTracksScreenState extends State<LearningTracksScreen> {
  LearningTracksStore learningTracksStore = LearningTracksStore();
  SmartPageController controller = SmartPageController.getInstance();
  bool hasError = false;

  int currentPage = 1;
  final int _itemsPerPageCount = 10;
  int _nextPageThreshold = 5;

  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await learningTracksStore
          .listLearningTracks(
              limit: _itemsPerPageCount, offset: 0, locale: Platform.localeName)
          .onError((error, stackTrace) {
        setState(() {
          hasError = true;
        });
      });
      setState(() {
        _hasMoreItems =
            learningTracksStore.allLearningTracks.length == _itemsPerPageCount;
      });
    });
  }

  bool _hasMoreItems = true;
  Future<void> _getData() async {
    hasError = false;
    await learningTracksStore
        .listLearningTracks(
            limit: _itemsPerPageCount,
            offset: (currentPage - 1) * _itemsPerPageCount,
            locale: Platform.localeName)
        .onError((error, stackTrace) {
      setState(() {
        hasError = true;
      });
    });
    setState(() {
      _hasMoreItems =
          learningTracksStore.allLearningTracks.length == _itemsPerPageCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return TryAgain(
        _getData,
        buttonBackgroundColor: Colors.white,
        messageTextColor: Colors.white,
        buttonTextColor: Colors.black,
      );
    } else if (learningTracksStore.allLearningTracks.isEmpty) {
      return Observer(builder: (context) {
        if (learningTracksStore.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Text(
            AppLocalizations.of(context)!.dontExistLearningTracks,
          ),
        );
      });
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            learningTracksStore.allLearningTracks = [];
            currentPage = 1;
          });
          await _getData();
        },
        child: Container(
          child: ListView(
            children: [
              SizedBox(
                height: 17,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.learningTracks,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppLocalizations.of(context)!.aboutLearningTracks,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: learningTracksStore.allLearningTracks.length +
                        (_hasMoreItems ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index ==
                              learningTracksStore.allLearningTracks.length -
                                  _nextPageThreshold &&
                          _hasMoreItems) {
                        currentPage++;
                        _getData();
                      }
                      if (index ==
                          learningTracksStore.allLearningTracks.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _hasMoreItems
                                ? CircularProgressIndicator()
                                : Container(),
                          ),
                        );
                      }
                      var learningTrack =
                          learningTracksStore.allLearningTracks[index];
                      return InkWell(
                        key: Key(learningTrack.id.toString()),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          controller.insertPage(ViewLearningTracksScreen({
                            'list_chapters': learningTrack.chapters,
                            'learning_tracks': learningTrack,
                          }));
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(learningTrack.userPhotoUrl),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      learningTrack.userName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Visibility(
                                      visible:
                                          learningTrack.location != 'null' &&
                                              learningTrack.location != null,
                                      child: Text(
                                        learningTrack.location!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 370,
                                  height: 210,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        learningTrack.imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 16.0, left: 16),
                                    child: Text(
                                      learningTrack.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${learningTrack.chapters.length.toString()} ${AppLocalizations.of(context)!.lessons}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      learningTrack.time,
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
                                      '${currencyFormatter.format(learningTrack.ooz)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                learningTrack.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 16,
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
                    }),
              ),
            ],
          ),
        ),
      );
    }
  }
}
