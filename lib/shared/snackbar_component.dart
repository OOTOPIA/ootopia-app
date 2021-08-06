import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Snackbar extends StatefulWidget {
  String menu;
  String text;
  Map<String,dynamic>? contact;
  String about;

  Snackbar({required this.menu, required this.text, this.contact, required this.about});

  @override
  _SnackbarStates createState() => _SnackbarStates();
}

class _SnackbarStates extends State<Snackbar> {

  Future<void> _makePhoneCall(String url) async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(26),
      child: Wrap(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.menu,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ))
            ],
          ),
          Text(
            widget.text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          if(widget.contact != null && widget.contact!["text"] !=  null && widget.contact!["textLink"] != null) Padding(
            padding: EdgeInsets.only(top: 8), 
            child: Row(
              children: [
                Text(
                  widget.contact!["text"] + " ",
                  style: TextStyle(color: Colors.white, fontSize: 16)
                ),
                TextButton(
                  onPressed: () => setState(() {
                  _makePhoneCall('mailto:contact@ootopia.org');
                }),
                  child:  Text(
                    widget.contact!["textLink"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              ]
            )
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              widget.about.toUpperCase(),
              style: TextStyle(
                color: Color(0xff03DAC5),
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

}