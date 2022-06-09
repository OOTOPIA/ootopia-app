class InterestsTagsEntity {
  InterestsTagsEntity({
    required this.id,
    required this.name,
    this.numberOfPosts = 0,
  });

  final String id;
  final String name;
  final int numberOfPosts;
}
