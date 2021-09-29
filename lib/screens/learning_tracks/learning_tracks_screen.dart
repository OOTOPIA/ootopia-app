import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
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
  List<LearningTracksModel> _allLearningTracks = [];
  @override
  void initState() {
    super.initState();
    learningTracksStore.listLearningTracks(50, 0);
    _hasMoreItems = _allLearningTracks.length == _itemsPerPageCount;
  }

  int currentPage = 1;

  final int _itemsPerPageCount = 3;

  int _nextPageThreshold = 5;

  bool _hasMoreItems = true;
  Future<void> _getData() async {
    //_allPosts.addAll(learningTracksStore.listOfLearningTracks);
    learningTracksStore.listLearningTracks(
        _itemsPerPageCount, (currentPage - 1) * _itemsPerPageCount);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      _allLearningTracks.addAll(learningTracksStore.listOfLearningTracks);
      return LoadingOverlay(
        isLoading: learningTracksStore.isloading,
        child: RefreshIndicator(
          edgeOffset: 10,
          onRefresh: () async {
            //await learningTracksStore.listLearningTracks(5, _itemsPerPageCount);
            setState(() {
              _allLearningTracks = [];
              currentPage = 1;
            });
            _getData();
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
                      itemCount: _allLearningTracks.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            controller.insertPage(ViewLearningTracksScreen({
                              'list_chapters': learningTracksStore
                                  .listOfLearningTracks[index].chapters,
                              'description': learningTracksStore
                                  .listOfLearningTracks[index].description,
                              'title': learningTracksStore
                                  .listOfLearningTracks[index].title,
                            }));
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        _allLearningTracks[index].userPhotoUrl),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        _allLearningTracks[index].userName,
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(_allLearningTracks[index].location)
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
                                      _allLearningTracks[index].imageUrl,
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
                                        _allLearningTracks[index].title,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_allLearningTracks[index].chapters.length.toString()} lessons',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${_allLearningTracks[index].totalTimeInMinutes} min',
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
                                        '${_allLearningTracks[index].ooz.toString().replaceAll('.', ',')}',
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
                                _allLearningTracks[index].description,
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
        ),
      );
    });
  }
}
