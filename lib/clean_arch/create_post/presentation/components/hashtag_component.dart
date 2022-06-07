import 'package:flutter/material.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';

class hashtagComponent extends StatelessWidget {
  const hashtagComponent({
    Key? key,
    required this.tagSelected,
    required this.deleteHashTag,
  }) : super(key: key);

  final InterestsTagsEntity tagSelected;
  final void Function() deleteHashTag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Chip(
        labelPadding: EdgeInsets.all(4),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xffD4D6D8)),
            borderRadius: BorderRadius.all(Radius.circular(24))),
        label: Text(
          tagSelected.name,
          style: TextStyle(
            color: Color(0xff656F7B),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        deleteIcon: Image.asset(
          'assets/icons/close.png',
          color: Colors.black,
          height: 16,
          width: 16,
        ),
        onDeleted: deleteHashTag,
      ),
    );
  }
}
