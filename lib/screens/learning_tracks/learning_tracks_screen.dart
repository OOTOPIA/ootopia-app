import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await learningTracksStore
          .listLearningTracks(_itemsPerPageCount, 0)
          .onError((error, stackTrace) {
        setState(() {
          hasError = true;
        });
      });

      setState(() {});
    });
  }

  int currentPage = 1;

  final int _itemsPerPageCount = 6;

  int _nextPageThreshold = 3;

  bool _hasMoreItems = true;
  Future<void> _getData() async {
    hasError = false;
    await learningTracksStore
        .listLearningTracks(
      _itemsPerPageCount,
      (currentPage - 1) * _itemsPerPageCount,
    )
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
    }
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
                      fontWeight: FontWeight.bold,
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

                    if (index == learningTracksStore.allLearningTracks.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: _hasMoreItems
                              ? CircularProgressIndicator()
                              : Container(),
                        ),
                      );
                    }
                    return InkWell(
                      key: Key(learningTracksStore.allLearningTracks[index].id
                          .toString()),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        controller.insertPage(ViewLearningTracksScreen({
                          'list_chapters': learningTracksStore
                              .allLearningTracks[index].chapters,
                          'description': learningTracksStore
                              .allLearningTracks[index].description,
                          'title': learningTracksStore
                              .allLearningTracks[index].title,
                        }));
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    learningTracksStore
                                        .allLearningTracks[index].userPhotoUrl),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    learningTracksStore
                                        .allLearningTracks[index].userName,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(learningTracksStore
                                      .allLearningTracks[index].location)
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: Image.network(
                                  learningTracksStore
                                      .allLearningTracks[index].imageUrl,
                                  width: 370,
                                  height: 210,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16.0, left: 16),
                                  child: Text(
                                    learningTracksStore
                                        .allLearningTracks[index].title,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${learningTracksStore.allLearningTracks[index].chapters.length.toString()} lessons',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${learningTracksStore.allLearningTracks[index].totalTimeInMinutes} min',
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
                                    '${learningTracksStore.allLearningTracks[index].ooz.toString().replaceAll('.', ',')}',
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
                          Text(
                            learningTracksStore
                                .allLearningTracks[index].description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
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
