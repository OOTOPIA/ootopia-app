import 'package:flutter/material.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFormFieldCreatePost extends StatelessWidget {
  const TextFormFieldCreatePost({Key? key, required this.storeCreatePosts})
      : super(key: key);

  final StoreCreatePosts storeCreatePosts;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: GlobalConstants.of(context).spacingNormal),
      child: TextFormField(
        maxLines: null,
        minLines: 1,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.multiline,
        controller: storeCreatePosts.descriptionInputController,
        onChanged: storeCreatePosts.onChanged,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          hintText: AppLocalizations.of(context)!.writeADescription,
          hintStyle: TextStyle(
              color: Colors.black.withOpacity(.3),
              fontWeight: FontWeight.normal),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black54, width: .25),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff707070), width: .25),
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff707070), width: .25),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
