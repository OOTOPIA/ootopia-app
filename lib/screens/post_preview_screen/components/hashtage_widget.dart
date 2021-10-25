import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/post_preview_screen_store.dart';

class HashtagWidget extends StatefulWidget {
  MultiSelectItem<InterestsTagsModel> item;
  PostPreviewScreenStore postPreviewScreenStore;
  bool tagExists;

  HashtagWidget(
      {required this.item,
      required this.postPreviewScreenStore,
      required this.tagExists});
  @override
  _HashtagWidgetState createState() => _HashtagWidgetState();
}

class _HashtagWidgetState extends State<HashtagWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!widget.tagExists)
            widget.postPreviewScreenStore.addItem(widget.item.value);
          else
            widget.postPreviewScreenStore.removeItem(widget.item.value);

          widget.tagExists = !widget.tagExists;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, bottom: 16),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          color: !widget.tagExists ? Colors.white : Color(0xff03145C),
          border: Border.all(width: 1, color: Color(0xffE0E1E2)),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          widget.item.label,
          style: GoogleFonts.roboto(
            color: widget.tagExists ? Colors.white : Colors.black45,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
