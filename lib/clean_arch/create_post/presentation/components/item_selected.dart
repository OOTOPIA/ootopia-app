import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/interesting_tags_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonSelectedTag extends StatelessWidget {
  ButtonSelectedTag({Key? key, required this.tag}) : super(key: key);

  final InterestsTagsEntity tag;
  final InterestingTagsStore _interestingTags = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (tag.id == '0') {
          _interestingTags.createTag();
        }
        _interestingTags.selectedTags.add(tag);
        _interestingTags.tags.clear();
        _interestingTags.interestingTag.clear();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Text(
              '#${tag.name}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 32),
            if (tag.id != '0')
              Text(
                '${tag.numberOfPosts} ${AppLocalizations.of(context)!.publications}',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff656F7B),
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
