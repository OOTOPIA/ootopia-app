import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/share_link.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class PopMenuLearningTrack extends StatefulWidget {
  final LearningTracksModel learningTrack;
  final LearningTracksStore learningTracksStore;
  PopMenuLearningTrack({
    required this.learningTrack,
    required this.learningTracksStore,
  });
  @override
  _PopMenuLearningTrackState createState() => _PopMenuLearningTrackState();
}

class _PopMenuLearningTrackState extends State<PopMenuLearningTrack> {
  @override
  void initState() {
    super.initState();
  }

  _selectedOption(String optionSelected) {
    if (optionSelected == 'shared') {
      copyLink(Type.learning_track, widget.learningTrack.id, context);
      modalSharedCopyLink(Type.learning_track, context);
      return;
    }
    if (optionSelected == 'delete') {
      showModalDeleteLearningTrack();
    }
  }

  void showModalDeleteLearningTrack() async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setstate) {
            return AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              content: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: AppLocalizations.of(context)!.removeUser,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: ' ${widget.learningTrack.title} ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                    text: AppLocalizations.of(context)!.permanently,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ]),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    )),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await widget.learningTracksStore
                          .deleteLearningTrack(widget.learningTrack.id);
                      scaffoldMensage();
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ))
              ],
            );
          });
        });
  }

  void scaffoldMensage() {
    if (widget.learningTracksStore.deleteLearning) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          AppLocalizations.of(context)!.successDeleteLearningTrack,
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            AppLocalizations.of(context)!.somethingWentWrongInLearningTrack,
            style: TextStyle(color: Colors.white),
          )));
    }
  }

  SmartPageController controller = SmartPageController.getInstance();

  @override
  Widget build(BuildContext context) {
    AuthStore authStore = Provider.of<AuthStore>(context);
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: Column(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    child: SvgPicture.asset(
                      'assets/icons/link.svg',
                      color: Color(0xff707070),
                      width: 20,
                      height: 20,
                    ),
                    padding: EdgeInsets.only(right: 4),
                  ),
                  Text(
                    AppLocalizations.of(context)!.copyLink,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          value: 'shared',
        ),
        if (authStore.currentUser!.isAdmin != null &&
            authStore.currentUser!.isAdmin!)
          PopupMenuItem<String>(
            child: Column(
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      child: Icon(Icons.delete),
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Text(
                      AppLocalizations.of(context)!.delete,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            value: 'delete',
          ),
      ],
      onSelected: (String value) => _selectedOption(value),
    );
  }
}
