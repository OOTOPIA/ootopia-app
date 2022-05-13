import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/user_search_model.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class LinkRichText extends StatefulWidget {
  final String text;
  final List<UserSearchModel>? userCommentsList;
  final int? maxLines;
  final Key? key;
  final bool isRegister;
  LinkRichText(
    this.text, {
    this.userCommentsList,
    this.maxLines,
    this.key,
    required this.isRegister,
  });

  @override
  State<LinkRichText> createState() => _LinkRichTextState();
}

class _LinkRichTextState extends State<LinkRichText> {
  final RegExp regExp = RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

  final List<InlineSpan> textSpanWidget = <TextSpan>[];

  final RegExp regExpUser = RegExp('');

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() {
    colorUserInText();
    if (regExp.hasMatch(widget.text)) {
      _hasLink();
    }
  }

  void colorUserInText() {
    SmartPageController controller = SmartPageController.getInstance();
    var allName = [];
    if (widget.userCommentsList != null &&
        widget.userCommentsList!.isNotEmpty) {
      List<Map<String, dynamic>> textFragmented = [];
      for (var item in widget.userCommentsList!) {
        var startName = widget.text.indexOf('@[${item.id}]');
        if (startName != -1) {
          allName.add({
            'id': item.id,
            'start': startName,
            'name': item.fullname,
            'end': startName + item.id.length + 3,
          });
        }
      }
      var countText = 0;
      allName.sort((actual, next) => actual["start"] > next["start"] ? 1 : -1);
      for (var i = 0; i < allName.length; i++) {
        var userInComment = allName[i];
        textFragmented.add({
          'isName': false,
          'string': widget.text.substring(countText, userInComment['start']),
        });
        countText = userInComment['id'].length + userInComment['start'] + 3;
        textFragmented.add({
          'id': userInComment['id'],
          'isName': true,
          'string': widget.text
              .substring(userInComment['start'], countText)
              .replaceAll('@[${userInComment['id']}]', userInComment['name']),
        });
      }
      if (widget.text.length > countText) {
        textFragmented.add({
          'isName': false,
          'string': widget.text.substring(countText, widget.text.length),
        });
      }

      for (var i = 0; i < textFragmented.length; i++) {
        var comment = textFragmented[i];
        textSpanWidget.add(
          TextSpan(
            text: comment['string'],
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                if (comment['id'] != null) {
                  if (widget.isRegister) {
                    Navigator.pushNamed(
                      context,
                      PageRoute.Page.profileScreen.route,
                      arguments: {
                        "id": comment['id'],
                        "isGetContacts": true,
                      },
                    );
                  } else {
                    controller.insertPage(
                      ProfileScreen({
                        "id": comment['id'],
                      }),
                    );
                  }
                }
              },
            style: TextStyle(
              color:
                  comment['isName'] ? LightColors.linkText : LightColors.black,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        );
      }
    } else {
      _hasntLink();
    }
  }

  _hasntLink() {
    textSpanWidget.add(TextSpan(
      text: this.widget.text,
      style: handleTextStyle(false),
    ));
  }

  _hasLink() {
    final splitedText = this.widget.text.split(RegExp(r"((?<= |\n)|(?= |\n))"));

    splitedText.forEach((element) {
      _checkTextStyleType(element);
    });
  }

  _checkTextStyleType(String text) {
    if (regExp.hasMatch(text) && _checkIfLinkIsAbsolute(_validateLink(text))) {
      var url = _validateLink(text);

      textSpanWidget.add(TextSpan(
          text: text,
          style: handleTextStyle(true),
          recognizer: new TapGestureRecognizer()..onTap = () => launch(url)));
    } else
      textSpanWidget.add(TextSpan(
        text: text,
        style: handleTextStyle(false),
      ));
  }

  _checkIfLinkIsAbsolute(String link) {
    try {
      if (Uri.parse(link).isAbsolute) return true;
    } catch (err) {
      return false;
    }
    return false;
  }

  _validateLink(String link) {
    return link.toString().contains('https://')
        ? link
        : link.toString().contains('http://')
            ? link
            : 'http://' + link;
  }

  TextStyle handleTextStyle(bool isLink) {
    return isLink
        ? TextStyle(
            color: LightColors.linkText,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          )
        : TextStyle(
            color: LightColors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.start,
        maxLines: widget.maxLines,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: textSpanWidget),
      ),
    );
  }
}
