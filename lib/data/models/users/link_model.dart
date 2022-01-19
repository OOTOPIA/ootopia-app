import 'package:json_annotation/json_annotation.dart';

part 'link_model.g.dart';

@JsonSerializable()
class Link {
  String URL;
  String title;

  Link({
    required this.URL,
    required this.title
  });
  
  @override
  List<Object?> get props => [URL, title];
  
  factory Link.fromJson(Map<String, dynamic> json) =>
      _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);
}