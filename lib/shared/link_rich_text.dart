import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/user_comment.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkRichText extends StatelessWidget {
  final String text;
  final List<UserSearchModel>? userCommentsList;
  final int? maxLines;
  final Key? key;
  final RegExp regExp = RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
  final List<InlineSpan> textSpanWidget = <TextSpan>[];
  final RegExp regExpUser = RegExp('');
  LinkRichText(
    this.text, {
    this.userCommentsList,
    this.maxLines,
    this.key,
  }) {
    _initialize();
  }

  _initialize() {
    colorUserInText();
    if (regExp.hasMatch(text)) {
      _hasLink();
    }
  }

  void colorUserInText() {
    SmartPageController controller = SmartPageController.getInstance();
    var allName = [];
    if (userCommentsList != null && userCommentsList!.isNotEmpty) {
      var positionInText = 0;

      List<Map<String, dynamic>> textFragmented = [];
      const string = 'Dartisans';
      string.indexOf(RegExp(r'sans'));
      print(text);
      for (var item in userCommentsList!) {
        var startname = text.indexOf('@${item.fullname}');
        print(startname);
        // if (startname >= 0) {
        //   allName.add({
        //     "id": item.id,
        //     "name": "${item.fullname} ",
        //     "start": startname,
        //     "end": startname + item.fullname.length
        //   });
        // }
      }
      var countText = 0;

      allName.sort((actual, next) => actual["start"] > next["start"] ? 1 : -1);
      for (var i = 0; i < allName.length; i++) {
        // textFragmented.add({
        //   'isName': false,
        //   'string': text.substring(countText, allName[i]['start']),
        // });

        // textFragmented.add({
        //   'isName': true,
        //   'string': allName[i]['name'],
        //   'id': allName[i]['id'],
        // });
        // print(
        //     'name ${allName[i]['name']} start ${allName[i]['start']} end ${allName[i]['end']}');
        // countText = allName[i]['end'];
      }
      if (text.length > countText) {
        textFragmented.add({
          'isName': false,
          'string': text.substring(countText + 1, text.length),
        });
      }
      for (var i = 0; i < textFragmented.length; i++) {
        var comment = textFragmented[i];
        textSpanWidget.add(
          TextSpan(
            text: comment['string'].replaceAll('ㅤ', ' '),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                controller.insertPage(
                  ProfileScreen({
                    "id": comment['id'],
                  }),
                );
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
      text: this.text,
      style: handleTextStyle(false),
    ));
  }

  _hasLink() {
    final splitedText = this.text.split(RegExp(r"((?<= |\n)|(?= |\n))"));

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
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: textSpanWidget),
      ),
    );
  }
}
