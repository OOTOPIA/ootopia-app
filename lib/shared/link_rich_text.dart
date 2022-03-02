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
    teste();
    regExp.hasMatch(text) ? _hasLink() : _hasntLink();
  }

  void teste() {
    var allName = [];
    List<String> textFragmented = [];
    for (var item in userCommentsList!) {
      int startname = text.indexOf(item.fullname);
      if (startname != -1) {
        allName.add({
          "name": "@${item.fullname}",
          "start": startname,
          "end": startname + item.fullname.length + 1
        });
      }
    }

    allName.sort((actual, next) => actual["start"] > next["start"] ? 1 : -1);

    for (var i = 0; i < allName.length; i++) {
      // inicio do loop
      if (i == 0 && allName[0]["start"] > 0) {
        textFragmented.add(text.substring(0, allName[0]["start"] - 1));
        textFragmented.add(allName[0]["name"]);
      }

      // meio do loop
      if (i < (allName.length - 2) &&
          (allName[i - 1]["end"] + 1) < allName[i]["start"]) {
        if ((allName[i - 1]["end"] + 1) == allName[i]["start"]) {
          textFragmented.add(allName[i]["name"]);
        } else {
          textFragmented.add(
              text.substring(allName[i - 1]["end"], allName[i]["start"] - 1));
          textFragmented.add(allName[i]["name"]);
        }
      }

      // fim do loop
      if (i == (allName.length - 1)) {
        if ((allName[i - 1]["end"] + 1) == allName[i]["start"]) {
          textFragmented.add(allName[i]["name"]);
        } else {
          textFragmented.add(text.substring(
              allName[i - 1]["end"] - 1, allName[i]["start"] - 1));
          textFragmented.add(allName[i]["name"]);
        }
      }
    }
    print("TEXTOU INTEIRO AQUI /n \n ${allName}");
    print("TEXTOU INTEIRO AQUI /n \n ${textFragmented}");
    textFragmented.forEach((texttt) {
      textSpanWidget.add(
        TextSpan(
          text: texttt,
          style: TextStyle(
            color: texttt.contains("@") ? Colors.red : Colors.blue,
          ),
        ),
      );
    });
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
