import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ootopia_app/clean_arch/core/constants/colors.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/hashtag_component.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/components/item_selected.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/interesting_tags_store.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InterestingTagsPage extends StatefulWidget {
  const InterestingTagsPage({Key? key}) : super(key: key);

  @override
  State<InterestingTagsPage> createState() => _InterestingTagsPageState();
}

class _InterestingTagsPageState extends State<InterestingTagsPage> {
  PreferredSizeWidget get appbar => DefaultAppBar(
        components: [
          AppBarComponents.back,
          AppBarComponents.close,
        ],
        onTapLeading: () {
          Navigator.pop(context);
        },
        onTapAction: () {},
      );

  final InterestingTagsStore _interestingTags = GetIt.I.get();

  @override
  void dispose() {
    _interestingTags.clearVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            BackgroundButterflyTop(positioned: -59),
            BackgroundButterflyBottom(positioned: -50),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Observer(builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.addHashtags,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.selectAtLeastOneHashtag,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_interestingTags.selectedTags.isNotEmpty)
                      Observer(builder: (context) {
                        return Container(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _interestingTags.selectedTags.length,
                            itemBuilder: (BuildContext context, int index) {
                              var tagSelected =
                                  _interestingTags.selectedTags[index];
                              return hashtagComponent(
                                tagSelected: tagSelected,
                                deleteHashTag: () {
                                  _interestingTags.selectedTags
                                      .remove(tagSelected);
                                },
                              );
                            },
                          ),
                        );
                      }),
                    SizedBox(height: 16),
                    TextField(
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      onChanged: _interestingTags.getTags,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.close),
                        prefixIcon: Icon(
                          Icons.search,
                          color: LightColors.blue,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(.3),
                            fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff707070), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff707070), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_interestingTags.tags.isNotEmpty)
                      Expanded(
                        child: NotificationListener(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent &&
                                !_interestingTags.lastPage) {
                              _interestingTags.getMoreTags();
                            }
                            return true;
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _interestingTags.tags.length,
                            itemBuilder: (BuildContext context, int index) {
                              var tag = _interestingTags.tags[index];
                              return ButtonSelectedTag(tag: tag);
                            },
                          ),
                        ),
                      ),
                    if (_interestingTags.loadingMoreTags)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
