import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';

class TryAgain extends StatefulWidget {
  final Function onClickButton;
  final Color buttonTextColor;
  final Color messageTextColor;
  final Color buttonBackgroundColor;
  TryAgain(this.onClickButton,
      {this.buttonTextColor,
      this.messageTextColor,
      this.buttonBackgroundColor});

  @override
  _TryAgainState createState() => _TryAgainState();
}

class _TryAgainState extends State<TryAgain> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Oops!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.buttonBackgroundColor != null
                            ? widget.buttonBackgroundColor
                            : Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: GlobalConstants.of(context).spacingNormal,
                      ),
                      child: Text(
                        "There was a problem,\nplease try again.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.messageTextColor != null
                              ? widget.messageTextColor
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: GlobalConstants.of(context).spacingLarge,
                  ),
                  ButtonTheme(
                    height: 48,
                    child: FlatButton(
                      child: Padding(
                        padding: EdgeInsets.all(
                          GlobalConstants.of(context).spacingSmall,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.replay,
                                color: widget.buttonTextColor != null
                                    ? widget.buttonTextColor
                                    : Colors.white,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Try again",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: widget.buttonTextColor != null
                                      ? widget.buttonTextColor
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        widget.onClickButton();
                      },
                      color: widget.buttonBackgroundColor != null
                          ? widget.buttonBackgroundColor
                          : Theme.of(context).accentColor,
                      splashColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: widget.buttonBackgroundColor != null
                              ? widget.buttonBackgroundColor
                              : Theme.of(context).accentColor,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
