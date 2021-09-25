import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';

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
    return LoadingOverlay(
      isLoading: learningTracksStore.isloading,
      child: RefreshIndicator(
        onRefresh: () async {},
        child: Container(
          child: Center(
            child: Text("Learning Tracks"),
          ),
        ),
      ),
    );
  }
}
