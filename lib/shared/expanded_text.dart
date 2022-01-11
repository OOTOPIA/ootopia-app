
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'link_rich_text.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text, this.maxLines);

  final String text;
  final int maxLines;


  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  bool moreThan4Lines = false;
  bool isExpanded = false;

  void init() {
    final span = TextSpan(text: widget.text);
    final tp = TextPainter(text: span, maxLines: 3, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width-40);
    moreThan4Lines = tp.didExceedMaxLines;
  }



  @override
  Widget build(BuildContext context) {
    init();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedSize(
            alignment: Alignment.topLeft,
              duration: const Duration(milliseconds: 200),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                ),
                child: LinkRichText(widget.text, maxLines: isExpanded ? 1000 : 3),

              )),
          if(isExpanded)...[
              Visibility(
                visible: moreThan4Lines,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Material(
                    child: Ink(
                      width: 75,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            '${AppLocalizations.of(context)!.hide}...',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffA3A3A3),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ]else...[
            Visibility(
              visible: moreThan4Lines,
              child: Container(
                alignment: Alignment.topLeft,
                child: Material(
                  //color: Colors.blueAccent,
                  child: Ink(
                    width: 120,
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '${AppLocalizations.of(context)!.readMode}...',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffA3A3A3),
                              fontWeight: FontWeight.w400),

                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ]);
  }
}







