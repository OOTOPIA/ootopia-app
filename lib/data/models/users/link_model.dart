import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'link_model.g.dart';

@JsonSerializable()
class Link {
  String URL;
  String title;
  String? textToShow;

  Link({
    required this.URL,
    required this.title
  });
  
  @override
  List<Object?> get props => [URL, title];
  
  factory Link.fromJson(Map<String, dynamic> json) =>
      _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);


  String setTextWith3dots(double size){
    textToShow = "$title: $URL";
    bool status = true;
    final style = TextStyle(fontSize: 16);
    final span = TextSpan(text: textToShow , style: style);
    final tp = TextPainter(text: span, maxLines: 1, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: size);

    if(tp.didExceedMaxLines){
      int i = textToShow!.length;

      while(status && i > 0){
        final span = TextSpan(text: textToShow!.substring(0,i) + "...", style: style );
        final tp = TextPainter(text: span, maxLines: 1,  textDirection: TextDirection.ltr);
        tp.layout(maxWidth: size);
        i--;
        if(tp.didExceedMaxLines == false){
          status = false;
          textToShow = textToShow!.substring(0,i) + "...";
        }
      }
    }
    return textToShow!;
  }

}