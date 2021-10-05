import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/screens/components/interests_tags_modal/interests_tags_modal.dart';

class InterestsTagsController {
  Future<List<InterestsTags>?> show(
    BuildContext context,
    List<InterestsTags> allTags,
    List<InterestsTags>? selectedTags,
  ) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return InterestsTagsModal(
          allTags: new List<InterestsTags>.from(allTags),
          selectedTags: (selectedTags != null
              ? new List<InterestsTags>.from(selectedTags)
              : null),
        );
      },
    );
  }
}
