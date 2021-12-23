import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/learning_tracks/chapters_model.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/learning_tracks/components/video_player_learning_tracks.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:provider/provider.dart';
import '../../../data/repositories/learning_tracks_repository.dart';

class WatchVideoLeaningTracks extends StatefulWidget {
  final ChaptersModel chapter;
  final LearningTracksModel? learningTrack;
  final Function updateStatusVideoChapter;

  WatchVideoLeaningTracks({
    required this.chapter,
    this.learningTrack,
    required this.updateStatusVideoChapter,
  });
  @override
  _WatchVideoLeaningTracksState createState() =>
      _WatchVideoLeaningTracksState();
}

class _WatchVideoLeaningTracksState extends State<WatchVideoLeaningTracks> {
  LearningTracksRepositoryImpl learningTracksRepositoryImpl =
      LearningTracksRepositoryImpl();
  late WalletStore walletStore;

  @override
  void dispose() {
    super.dispose();
  }

  updateStatusVideo() async {
    if (widget.chapter.completed != true) {
      widget.chapter.completed = true;
      await learningTracksRepositoryImpl.updateStatusVideoLearningTrack(
        widget.learningTrack!.id,
        widget.chapter.id,
      );
      await this.walletStore.getWallet();
      setState(() {
        widget.updateStatusVideoChapter();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    walletStore = Provider.of<WalletStore>(context);
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: isPortrait
          ? DefaultAppBar(
              components: [
                AppBarComponents.back,
              ],
              onTapLeading: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      body: VideoPlayerLearningTracks(
        videoUrl: widget.chapter.videoUrl,
        thumbVideo: widget.chapter.videoThumbUrl,
        viewQuiz: viewButtonQuiz(isPortrait),
        updateStatusVideo: updateStatusVideo,
      ),
    );
  }

  Widget viewButtonQuiz(bool isPortrait) {
    return Visibility(
      visible: isPortrait,
      child: Column(
        children: [
          SizedBox(
            height: 24,
          ),
          ElevatedButton(
            style: ButtonStyle(
              maximumSize: MaterialStateProperty.all<Size>(
                Size(276, 53),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(276, 53),
              ),
              fixedSize: MaterialStateProperty.all<Size>(
                Size(276, 53),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Color(0xff003694))),
              ),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff003694)),
              padding:
                  MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(PageRoute.Page.aboutQuizScreen.route);
            },
            child: Text(
              AppLocalizations.of(context)!.quiz.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 68.0),
            child: Text(
              AppLocalizations.of(context)!.respondQuiz,
              style: TextStyle(
                height: 1,
                color: Color(0xff707070),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 19,
          ),
        ],
      ),
    );
  }
}
