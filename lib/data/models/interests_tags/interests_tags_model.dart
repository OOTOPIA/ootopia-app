import 'package:equatable/equatable.dart';

class InterestsTags extends Equatable {
  String id;
  String name;
  String type;
  bool active = true;
  int tagOrder;
  String language;
  String createdAt;
  String updatedAt;

  InterestsTags({
    this.id,
    this.name,
    this.type,
    this.active,
    this.tagOrder,
    this.language,
    this.createdAt,
    this.updatedAt,
  });

  factory InterestsTags.fromJson(Map<String, dynamic> parsedJson) {
    return InterestsTags(
      id: parsedJson['id'],
      name: parsedJson['name'],
      type: parsedJson['type'],
      active: (parsedJson['active'] == null ? false : parsedJson['active']),
      tagOrder: int.parse(parsedJson['tagOrder']),
      language: parsedJson['language'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        type,
        active,
        tagOrder,
        language,
        createdAt,
        updatedAt,
      ];
}
