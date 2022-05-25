import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ootopia_app/clean_arch/report/presentation/stores/store_report_post.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class ReportPostPage extends StatefulWidget {
  final TimelinePost timelinePost;
  const ReportPostPage({
    Key? key,
    required this.timelinePost,
  }) : super(key: key);

  @override
  State<ReportPostPage> createState() => _ReportPostPageState();
}

class _ReportPostPageState extends State<ReportPostPage> {
  final StoreReportPost _storeReportPost = GetIt.I.get();
  final SmartPageController _smartPageController =
      SmartPageController.getInstance();
  void sendReport() async {
    await _storeReportPost.sendReport();
    if (_storeReportPost.error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(_storeReportPost.error),
        ),
      );
      return;
    }
    if (_storeReportPost.success) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          title: Text(AppLocalizations.of(context)!.sendReport),
          content: Text(
            AppLocalizations.of(context)!.messageReportUser,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: LightColors.blue,
                maximumSize: Size(130, 35),
                fixedSize: Size(130, 35),
                minimumSize: Size(130, 35),
              ),
              onPressed: () {
                Navigator.pop(context);
                _smartPageController.back();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          BackgroundButterflyBottom(positioned: -50),
          SingleChildScrollView(
            child: Observer(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)!.report,
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      checkColor: LightColors.white,
                      activeColor: LightColors.blue,
                      value: _storeReportPost.spam,
                      onChanged: _storeReportPost.setSpam,
                      title: Text(
                        AppLocalizations.of(context)!.spam,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      checkColor: LightColors.white,
                      activeColor: LightColors.blue,
                      value: _storeReportPost.nudez,
                      onChanged: _storeReportPost.setNudez,
                      title: Text(
                        AppLocalizations.of(context)!.nudity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      checkColor: LightColors.white,
                      activeColor: LightColors.blue,
                      value: _storeReportPost.violence,
                      onChanged: _storeReportPost.setViolence,
                      title: Text(
                        AppLocalizations.of(context)!.violence,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      checkColor: LightColors.white,
                      activeColor: LightColors.blue,
                      value: _storeReportPost.other,
                      onChanged: _storeReportPost.setOther,
                      title: Text(
                        AppLocalizations.of(context)!.other,
                      ),
                    ),
                  ),
                  if (_storeReportPost.other)
                    Container(
                      height: constraints.maxHeight * .25,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(width: 0.25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(width: 0.25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(width: 0.25),
                          ),
                        ),
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        controller: _storeReportPost.reportController,
                      ),
                    ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: LightColors.blue,
                        maximumSize: Size(130, 35),
                        fixedSize: Size(130, 35),
                        minimumSize: Size(130, 35),
                      ),
                      onPressed: sendReport,
                      child: Text(
                        AppLocalizations.of(context)!.send,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: LightColors.white,
                        activeColor: LightColors.blue,
                        value: _storeReportPost.seeMorePostsAboutThisUser,
                        onChanged:
                            _storeReportPost.setSeeMorePostsAboutThisUser,
                      ),
                      Text(AppLocalizations.of(context)!
                          .dontSeeMorePosts
                          .replaceAll(
                              '%USERNAME%', widget.timelinePost.username)),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      );
    });
  }
}
