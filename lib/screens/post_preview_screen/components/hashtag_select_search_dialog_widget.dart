import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/hashtage_widget.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/post_preview_screen_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class HashtagSelectSearchDialogWidget extends StatefulWidget {
  final List<MultiSelectItem<InterestsTagsModel>> items;
  final PostPreviewScreenStore postPreviewScreenStore;

  HashtagSelectSearchDialogWidget(
      {required this.items, required this.postPreviewScreenStore});

  @override
  _HashtagSelectSearchDialogWidgetState createState() =>
      _HashtagSelectSearchDialogWidgetState();
}

class _HashtagSelectSearchDialogWidgetState
    extends State<HashtagSelectSearchDialogWidget> {
  String filterValue = "";
  List<HashtagWidget> allTags = [];

  @override
  void initState() {
    super.initState();
    allTags = widget.items
        .map((item) => HashtagWidget(
            item: item,
            postPreviewScreenStore: widget.postPreviewScreenStore,
            tagExists: widget.postPreviewScreenStore.hasTagInList(item)))
        .toSet()
        .toList();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        insetPadding: EdgeInsets.symmetric(horizontal: 10),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    AppLocalizations.of(context)!.selectAtLeast1Tag,
                    style: GoogleFonts.roboto(
                        fontSize: 22, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    widget.postPreviewScreenStore.onFilterTagChanged(value);
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchForAtag,
                    hintStyle: GoogleFonts.roboto(
                        color: Colors.black.withOpacity(0.2),
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: Color(0xff707070), width: 0.25)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide:
                            BorderSide(color: Color(0xff707070), width: 0.25)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Divider(
                    thickness: 1,
                    height: 1,
                  ),
                ),
                Observer(
                  builder: (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: GlobalConstants.of(context).spacingSmall,
                        children: [
                          SizedBox(
                            height: 10,
                            width: double.infinity,
                          ),
                          ...widget.postPreviewScreenStore.filterValue.isEmpty
                              ? allTags
                              : widget.postPreviewScreenStore
                                  .filterTagsPerName(allTags)
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.postPreviewScreenStore.selectedTags.clear();
                          widget.postPreviewScreenStore.filterValue = "";
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: GoogleFonts.roboto(
                              color: Color(0xff018F9C),
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            widget.postPreviewScreenStore.filterValue = "";

                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.confirm,
                            style: GoogleFonts.roboto(
                                color: Color(0xff018F9C),
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
