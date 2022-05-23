import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/learning_tracks/components/learning_track_item.dart';
import 'package:ootopia_app/screens/learning_tracks/components/learning_tracks_information.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/view_learning_tracks.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class LearningTracksScreen extends StatefulWidget {
  @override
  _LearningTracksScreenState createState() => _LearningTracksScreenState();
}

class _LearningTracksScreenState extends State<LearningTracksScreen> {
  LearningTracksStore store = LearningTracksStore();
  SmartPageController controller = SmartPageController.getInstance();
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  late final ScrollController _scrollController;


  @override
  void initState() {
    store.init();
    scrollControllerConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          BackgroundButterflyBottom(positioned: -50),
          body()
        ],
      ),
    );
  }

  Widget body() {
    return Observer(
        builder: (_) {
          if (store.pageError()) {
            return TryAgain(
              store.getLearningTracks,
              buttonBackgroundColor: Colors.white,
              messageTextColor: Colors.white,
              buttonTextColor: Colors.black,
            );
          }
          else if(store.pageLoading()){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (store.allLearningTracks.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.dontExistLearningTracks,
              ),
            );
          }
          else {
            return RefreshIndicator(
              onRefresh: () async {
                await store.refreshPage();
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    controller: _scrollController,
                    itemCount: store.allLearningTracks.length + 1,
                    itemBuilder: (context, index) {
                      if(index == 0 ){
                        return LearningTrackInformation(
                          onTap: () async {
                            if (store.welcomeGuideLearningTrack == null) {
                              await store.getWelcomeGuide();
                            }
                            if (store.welcomeGuideLearningTrack != null) {
                              openLearningTrack(store.welcomeGuideLearningTrack!);
                            }
                          },
                        );
                      }
                      var learningTrack = store.allLearningTracks[index - 1];
                      return LearningTrackWidget(
                        learningTrack: learningTrack,
                        currencyFormatter: currencyFormatter,
                        onTap: () => openLearningTrack(learningTrack),
                      );
                    }),
              ),
            );
          }
        }
    );
  }

  void updateWidget() {
    setState(() {});
  }

  void openLearningTrack(LearningTracksModel learningTrack) =>
      controller.insertPage(ViewLearningTracksScreen(
        {
          'list_chapters': learningTrack.chapters,
          'learning_tracks': learningTrack,
          'updateLearningTrack': updateWidget,
        },
      ));

  void scrollControllerConfig() {
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if(_scrollController.offset >= _scrollController.position.maxScrollExtent*0.8 &&
          store.hasMoreItems && !store.isLoadingMore){
        await store.loadMoreLearningTracks();
      }
    });
  }
}
