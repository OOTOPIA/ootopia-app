import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkRichText extends StatelessWidget {
  final String? text;
  final int? maxLines;
  final Key? key;
  final RegExp regExp = RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
  final List<InlineSpan> textSpanWidget = <TextSpan>[];

  LinkRichText(
    this.text, {
    this.maxLines,
    this.key,
  }) {
    _initialize();
  }

  _initialize() {
    regExp.hasMatch(text!) ? _hasLink() : _hasntLink();
  }

  _hasntLink() {
    textSpanWidget.add(TextSpan(
      text: this.text,
      style: TextStyle(
        color: LightColors.black,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ));
  }

  _hasLink() {
    final splitedText = text?.split(' ');

    splitedText?.forEach((element) {
      _checkTextStyleType(element);
      textSpanWidget.add(TextSpan(text: " "));
    });
  }

  _checkTextStyleType(String text) {
    if (regExp.hasMatch(text)) {
      var url = _validateLink(text);

      textSpanWidget.add(TextSpan(
          text: text,
          style: TextStyle(
            color: LightColors.linkText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          recognizer: new TapGestureRecognizer()..onTap = () => launch(url)));
    } else
      textSpanWidget.add(TextSpan(
        text: text,
        style: TextStyle(
          color: LightColors.black,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ));
  }

  _validateLink(String link) {
    return link.toString().contains('https://')
        ? link
        : link.toString().contains('http://')
            ? link
            : 'http://' + link;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.start,
        overflow: TextOverflow.clip,
        maxLines: maxLines,
        text: TextSpan(children: textSpanWidget),
      ),
    );
  }
}
