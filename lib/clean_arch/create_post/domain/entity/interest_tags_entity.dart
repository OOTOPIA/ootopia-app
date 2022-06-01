class InterestsTagsEntity {
  InterestsTagsEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.tagOrder,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    this.selectedTag,
  });

  String id;
  String name;
  String type;
  bool active;
  bool? selectedTag = false;
  int tagOrder;
  String language;
  String createdAt;
  String updatedAt;
}
