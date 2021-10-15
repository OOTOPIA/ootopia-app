import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/screens/auth/register_second_phase/register_second_phase_controller.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class InterestsTagsModal extends StatefulWidget {
  final List<InterestsTagsModel> allTags;
  final List<InterestsTagsModel>? selectedTags;
  InterestsTagsModal({
    required this.allTags,
    this.selectedTags,
  });

  @override
  _InterestsTagsModalState createState() => _InterestsTagsModalState();
}

class _InterestsTagsModalState extends State<InterestsTagsModal> {
  List<InterestsTagsModel> filterTags = [];
  List<InterestsTagsModel> tagsSelected = [];

  @override
  void initState() {
    super.initState();
    filterTags.clear();
    tagsSelected.clear();

    widget.allTags.forEach((tag) => filterTags.add(tag));

    if (widget.selectedTags != null) {
      widget.selectedTags!.forEach((tag) => tagsSelected.add(tag));
    }

    if (tagsSelected.length > 0) {
      updateTagsSelected();
    }
  }

  void filterTagsByText(String text) {
    setState(() {
      filterTags = [
        ...widget.allTags
            .where((tag) => tag.name.toLowerCase().contains(text.toLowerCase()))
            .toList()
      ];

      updateTagsSelected();
    });
  }

  void updateTagsSelected() {
    filterTags.forEach((tag) {
      if (tagsSelected
              .singleWhereOrNull((element) => element.id == tag.id)
              ?.id !=
          null) {
        tag.selectedTag = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: Colors.white,
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pleaseSelectAtLeast1Tag,
                      style:
                          GoogleFonts.roboto(fontSize: 22, color: Colors.black),
                    ),
                    SizedBox(
                      height: GlobalConstants.of(context).intermediateSpacing,
                    ),
                    TextFormField(
                      style: TextStyle(height: 0.1),
                      onChanged: (value) {
                        filterTagsByText(value);
                      },
                      decoration: GlobalConstants.of(context).loginInputTheme(
                          AppLocalizations.of(context)!
                              .selectAtLeastOneHashtag),
                    ),
                    SizedBox(
                      height: GlobalConstants.of(context).spacingMedium,
                    ),
                    Container(
                      color: LightColors.grey.withOpacity(.3),
                      width: double.infinity,
                      height: 1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 26,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: GlobalConstants.of(context).spacingSmall,
                        children: filterTags.map((tag) {
                          return ChoiceChip(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  GlobalConstants.of(context).spacingNormal,
                              vertical: 0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xffE0E1E2),
                              ),
                            ),
                            label: Text(
                              '${tag.name}',
                              style: GoogleFonts.roboto(
                                color: tag.selectedTag == true
                                    ? Colors.white
                                    : LightColors.blackText.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .fontSize,
                              ),
                            ),
                            selectedColor: LightColors.darkBlue,
                            backgroundColor: Colors.white,
                            selected: tag.selectedTag == true,
                            onSelected: (bool selected) {
                              setState(() {
                                tag.selectedTag = selected;
                              });
                              if (selected) {
                                tagsSelected.add(tag);
                              } else {
                                tagsSelected
                                    .removeWhere((_tag) => _tag.id == tag.id);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height:
                            GlobalConstants.of(context).screenHorizontalSpace,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 65,
                child: Column(
                  children: [
                    Container(
                      color: LightColors.grey.withOpacity(.3),
                      width: double.infinity,
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingSmall,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(
                                  color: Color(0xff018F9C),
                                  fontWeight: FontWeight.w500,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .fontSize),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: GlobalConstants.of(context).spacingSmall,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(tagsSelected);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.confirm,
                              style: TextStyle(
                                  color: Color(0xff018F9C),
                                  fontWeight: FontWeight.w500,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .fontSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
