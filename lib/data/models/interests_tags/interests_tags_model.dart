import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class InterestsTags extends Equatable {
  late String id;
  late String name;
  late String type;
  late bool active;
  late int tagOrder;
  late String language;
  late String createdAt;
  late String updatedAt;

  InterestsTags({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.tagOrder,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
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
