import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/screens/components/interests_tags_modal/interests_tags_modal.dart';

class InterestsTagsController {
  Future<List<InterestsTagsModel>?> show(
    BuildContext context,
    List<InterestsTagsModel> allTags,
    List<InterestsTagsModel>? selectedTags,
  ) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return InterestsTagsModal(
          allTags: new List<InterestsTagsModel>.from(
              allTags.map((t) => InterestsTagsModel.fromJson(t.toJson()))),
          selectedTags: (selectedTags != null
              ? new List<InterestsTagsModel>.from(selectedTags
                  .map((t) => InterestsTagsModel.fromJson(t.toJson())))
              : null),
        );
      },
    );
  }
}
