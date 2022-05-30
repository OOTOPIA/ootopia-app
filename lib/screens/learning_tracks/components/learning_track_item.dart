import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/share_link.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_store.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class LearningTrackWidget extends StatefulWidget {
  final LearningTracksModel learningTrack;
  final onTap;
  final NumberFormat currencyFormatter;
  final LearningTracksStore learningTracksStore;
  LearningTrackWidget({
    Key? key,
    required this.learningTrack,
    required this.learningTracksStore,
    required this.onTap,
    required this.currencyFormatter,
  }) : super(key: key);

  @override
  State<LearningTrackWidget> createState() => _LearningTrackWidgetState();
}

class _LearningTrackWidgetState extends State<LearningTrackWidget> {
  SmartPageController controller = SmartPageController.getInstance();
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

  @override
  Widget build(BuildContext context) {
    AuthStore authStore = Provider.of<AuthStore>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        key: Key(widget.learningTrack.id.toString()),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: widget.onTap,
        onLongPress: authStore.currentUser!.isAdmin
            ? showModalDeleteLearningTrack
            : null,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        widget.learningTrack.userPhotoUrl,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - (48 + 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.learningTrack.userName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Visibility(
                            visible: widget.learningTrack.location != 'null' &&
                                widget.learningTrack.location != null,
                            child: Text(
                              widget.learningTrack.location!,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                ShareLink(
                  type: Type.learning_track,
                  id: widget.learningTrack.id,
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: widget.learningTrack.completed == true
                        ? Border.all(
                            color: Color(0xff018F9C),
                            width: 3,
                          )
                        : Border.all(
                            color: Color.fromARGB(1, 0, 0, 0), width: 0),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.learningTrack.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
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
                    width: MediaQuery.of(context).size.width - 48,
                    padding: const EdgeInsets.only(bottom: 16.0, left: 16),
                    child: Text(
                      widget.learningTrack.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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
                  '${widget.learningTrack.chapters.length.toString()} ${AppLocalizations.of(context)!.lessons}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      widget.learningTrack.completed == true
                          ? AppLocalizations.of(context)!
                              .completed
                              .toUpperCase()
                          : widget.learningTrack.time,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: widget.learningTrack.completed == true
                            ? Color(0xff018F9C)
                            : Colors.grey,
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
                    if (!widget.learningTrack.completed) ...[
                      Text(
                        AppLocalizations.of(context)!.receive,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                    SvgPicture.asset(
                      'assets/icons/ooz_mini_blue.svg',
                      height: 10,
                      width: 19.33,
                      color: widget.learningTrack.completed == true
                          ? Color(0xff018F9C)
                          : Color(0xffA3A3A3),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${widget.currencyFormatter.format(widget.learningTrack.ooz)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: widget.learningTrack.completed == true
                            ? Color(0xff018F9C)
                            : Colors.grey,
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
                widget.learningTrack.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
