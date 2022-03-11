import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_store.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFieldComment extends StatefulWidget {
  final CommentStore commentStore;
  final TextEditingController inputController;
  final Function()? onTap;
  final Function(String)? onChange;
  final FocusNode focusNode;
  final AuthStore authStore;
  final Widget suffixIcon;
  const TextFieldComment({
    Key? key,
    required this.commentStore,
    required this.inputController,
    required this.onChange,
    required this.onTap,
    required this.focusNode,
    required this.authStore,
    required this.suffixIcon,
  }) : super(key: key);

  @override
  State<TextFieldComment> createState() => _TextFieldCommentState();
}

class _TextFieldCommentState extends State<TextFieldComment> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: true,
      enableSuggestions: true,
      textCapitalization: TextCapitalization.sentences,
      maxLines: widget.commentStore.isLoading ? 1 : null,
      minLines: 1,
      focusNode: widget.focusNode,
      onTap: widget.authStore.currentUser == null
          ? () {
              FocusScope.of(context).requestFocus(new FocusNode());
              Navigator.of(context).pushNamed(
                PageRoute.Page.loginScreen.route,
                arguments: {
                  "returnToPageWithArgs": {
                    "currentPageName": "wallet",
                    "arguments": null
                  }
                },
              );
            }
          : null,
      onChanged: widget.onChange,
      style: TextStyle(color: LightColors.grey),
      controller: widget.inputController,
      decoration: InputDecoration(
        fillColor:
            Colors.white.withOpacity(!widget.focusNode.hasFocus ? 0.3 : 1.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.grey, width: 0.25),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.grey, width: 0.25),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.grey, width: 0.25),
          borderRadius: BorderRadius.circular(5),
        ),
        contentPadding: EdgeInsets.all(16),
        hintText: AppLocalizations.of(context)!.writeYourComment,
        hintStyle: TextStyle(color: LightColors.grey),
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
