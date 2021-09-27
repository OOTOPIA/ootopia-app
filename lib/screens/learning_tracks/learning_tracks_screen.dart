import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class LearningTracksScreen extends StatefulWidget {
  LearningTracksScreen({Key? key}) : super(key: key);

  @override
  _LearningTracksScreenState createState() => _LearningTracksScreenState();
}

class _LearningTracksScreenState extends State<LearningTracksScreen> {
  LearningTracksStore learningTracksStore = LearningTracksStore();

  @override
  void initState() {
    super.initState();
    learningTracksStore.listLearningTracks(50, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return LoadingOverlay(
        isLoading: learningTracksStore.isloading,
        child: RefreshIndicator(
          onRefresh: () async {},
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
                        'Learning Tracks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Here you will find learning tracks that will bring you a deeper understanding of the main regenerative practices. Watch, answer the quizzes, and earn even more OOz.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          learningTracksStore.listOfLearningTracks.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                PageRoute.Page.viewLearningTracksScreen.route,
                                arguments: {
                                  'list_chapters': learningTracksStore
                                      .listOfLearningTracks[index].chapters,
                                });
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        learningTracksStore
                                            .listOfLearningTracks[index]
                                            .userPhotoUrl),
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
                                        learningTracksStore
                                            .listOfLearningTracks[index]
                                            .userName,
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(learningTracksStore
                                          .listOfLearningTracks[index].location)
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
                                          .listOfLearningTracks[index].imageUrl,
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
                                            .listOfLearningTracks[index].title,
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
                                    '${learningTracksStore.listOfLearningTracks[index].chapters.length.toString()} lessons',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${learningTracksStore.listOfLearningTracks[index].totalTimeInMinutes} min',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
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
                                        '${learningTracksStore.listOfLearningTracks[index].ooz.toString().replaceAll('.', ',')}',
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
                                    .listOfLearningTracks[index].description,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Divider(
                                color: Colors.grey,
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
