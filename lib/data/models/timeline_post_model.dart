class TimelinePost {
  String id;
  String userId;
  String description;
  String type;
  String imageUrl;
  String videoUrl;
  String thumbnailUrl;
  String photoUrl;
  String fullname;
  int likesCount;
  int commentsCount;
  DateTime createdAt;
  DateTime updatedAt;

  TimelinePost(
      {this.id,
      this.userId,
      this.description,
      this.type,
      this.imageUrl,
      this.videoUrl,
      this.thumbnailUrl,
      this.photoUrl,
      this.fullname,
      this.likesCount,
      this.commentsCount,
      this.createdAt,
      this.updatedAt});

  factory TimelinePost.fromJson(Map<String, dynamic> parsedJson) {
    return new TimelinePost(
        id: parsedJson['id'],
        userId: parsedJson['userId'],
        description: parsedJson['description'],
        type: parsedJson['type'],
        imageUrl: parsedJson['imageUrl'],
        videoUrl: parsedJson['videoUrl'],
        thumbnailUrl: parsedJson['thumbnailUrl'],
        photoUrl: parsedJson['photoUrl'],
        fullname: parsedJson['fullname'],
        likesCount: parsedJson['likesCount'].toInt(),
        commentsCount: parsedJson['commentsCount'].toInt(),
        createdAt: parsedJson['createdAt'],
        updatedAt: parsedJson['updatedAt']);
  }
}
