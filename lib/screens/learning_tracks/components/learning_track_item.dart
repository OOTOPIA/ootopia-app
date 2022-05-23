import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/screens/components/share_link.dart';

class LearningTrackWidget extends StatelessWidget {
  final LearningTracksModel learningTrack;
  final onTap;
  final NumberFormat currencyFormatter;
  const LearningTrackWidget({Key? key,
    required this.learningTrack,
    required this.onTap,
    required this.currencyFormatter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        key: Key(learningTrack.id.toString()),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
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
                        learningTrack.userPhotoUrl,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - (48  + 140) ,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            learningTrack.userName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Visibility(
                            visible: learningTrack.location !=
                                'null' &&
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
                      ),
                    )
                  ],
                ),
                ShareLink(
                  type: Type.learning_track,
                  id: learningTrack.id,
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
                    border: learningTrack.completed == true
                        ? Border.all(
                      color: Color(0xff018F9C),
                      width: 3,
                    )
                        : Border.all(
                        color: Color.fromARGB(1, 0, 0, 0),
                        width: 0),
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
                    width: MediaQuery.of(context).size.width  - 48,
                    padding: const EdgeInsets.only(
                        bottom: 16.0, left: 16),
                    child: Text(
                      learningTrack.title,
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
                      learningTrack.completed == true
                          ? AppLocalizations.of(context)!
                          .completed
                          .toUpperCase()
                          : learningTrack.time,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: learningTrack.completed == true
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
                    if (!learningTrack.completed)...[
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
                      color: learningTrack.completed == true
                          ? Color(0xff018F9C)
                          : Color(0xffA3A3A3),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${currencyFormatter.format(learningTrack.ooz)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: learningTrack.completed == true
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
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
