import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';

class SnackBarWidget extends StatefulWidget {
  String menu;
  String text;
  String? emailToConcatenate;
  Map<String, dynamic>? contact;
  String about;
  bool? marginBottom = false;
  Function? onTapAbout;
  Function? onClose;

  SnackBarWidget(
      {required this.menu,
      required this.text,
      this.contact,
      required this.about,
      this.marginBottom,
      this.emailToConcatenate,
      this.onClose,
      this.onTapAbout});

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
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        color: Color(0xff018F9C),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.menu,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  constraints: BoxConstraints.loose(Size(22, 24)),
                  onPressed: () {
                    if (widget.onClose != null) widget.onClose!();
                    Navigator.of(context).pop();
                  },
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              child: widget.emailToConcatenate != null
                  ? RichText(
                      text: TextSpan(
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(text: widget.text),
                          TextSpan(
                            text: widget.emailToConcatenate,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      widget.text,
                      style:
                          GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                    ),
            ),
            if (widget.contact != null &&
                widget.contact!["text"] != null &&
                widget.contact!["textLink"] != null)
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: widget.contact!["text"] + " ",
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                ),
                TextSpan(
                  text: widget.contact!["textLink"],
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => setState(() {
                          _openEmail('mailto:contact@ootopia.org');
                        }),
                ),
              ])),
            SizedBox(height: 16),
            Visibility(
              visible: widget.about.isNotEmpty,
              child: GestureDetector(
                onTap: () {
                  if (widget.onTapAbout != null) widget.onTapAbout!();
                },
                child: Text(
                  widget.about.toUpperCase(),
                  style: GoogleFonts.roboto(
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
