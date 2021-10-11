import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';

class SnackBarWidget extends StatefulWidget {
  String menu;
  String text;
  String? emailToConcatenate;
  Map<String, dynamic>? contact;
  String about;
  bool? marginBottom = false;
  Function? onClose;

  SnackBarWidget(
      {required this.menu,
      required this.text,
      this.contact,
      required this.about,
      this.marginBottom,
      this.emailToConcatenate,
      this.onClose});

  @override
  _SnackbarStates createState() => _SnackbarStates();
}

class _SnackbarStates extends State<SnackBarWidget> {
  Future<void> _openEmail(String url) async {
    await launch(url);
  }

  @override
  void initState() {
    Timer(Duration(milliseconds: 5000), () {
      setState(() {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 26),
        color: Color(0xff018F9C),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.menu,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (widget.onClose != null) widget.onClose!();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ))
              ],
            ),
            widget.emailToConcatenate != null
                ? RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: widget.text),
                        new TextSpan(
                            text: widget.emailToConcatenate,
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : Text(
                    widget.text,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
            if (widget.contact != null &&
                widget.contact!["text"] != null &&
                widget.contact!["textLink"] != null)
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: widget.contact!["text"] + " ",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                TextSpan(
                  text: widget.contact!["textLink"],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => setState(() {
                          _openEmail('mailto:contact@ootopia.org');
                        }),
                ),
              ])),
            Visibility(
              visible: widget.about.isNotEmpty,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  widget.about.toUpperCase(),
                  style: TextStyle(
                    color: Color(0xff03DAC5),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      if (widget.marginBottom == true)
        Container(
          color: Colors.black.withAlpha(1),
          height: 50,
        )
    ]);
  }
}
