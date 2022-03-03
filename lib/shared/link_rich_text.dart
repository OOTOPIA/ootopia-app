import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/user_comment.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkRichText extends StatelessWidget {
  final String text;
  final List<UserComment>? userCommentsList;
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
    colorUserMarket();
    if (regExp.hasMatch(text)) {
      _hasLink();
    }
  }

  void colorUserMarket() {
    var allName = [];
    if (userCommentsList != null && userCommentsList!.isNotEmpty) {
      List<String> textFragmented = [];
      var positionEnd = 0;

      for (var item in userCommentsList!) {
        int startname = text.indexOf('@${item.fullname}', positionEnd);
        if (startname != -1) {
          allName.add({
            "id": item.id,
            "name": "@${item.fullname}",
            "start": startname,
            "end": startname + item.fullname.length,
          });
          positionEnd = startname + item.fullname.length;
        }
      }
      allName.sort((actual, next) => actual["start"] > next["start"] ? 1 : -1);

      for (var i = 0; i < text.length; i++) {
        for (var j = 0; j < allName.length; j++) {
          if (i >= allName[j]['start'] && i <= allName[j]['end']) {
            textFragmented.add(allName[j]['name']);
            i = allName[j]['end'];
            break;
          } else if (i < allName[j]['start']) {
            textFragmented.add(text.substring(i, allName[j]['start']));
            i = allName[j]['start'];
            break;
          }
        }
      }

      textFragmented.forEach((comment) {
        textSpanWidget.add(
          TextSpan(
            text: comment,
            style: TextStyle(
              color: comment.contains("@")
                  ? LightColors.errorRed
                  : LightColors.black,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        );
      });
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
