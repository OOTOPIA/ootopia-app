class Comment {
  final String avatarUrl;
  final String text;
  final String username;

  Comment({
    this.avatarUrl,
    this.text,
    this.username,
  });

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    return Comment(
        avatarUrl: parsedJson['id'],
        text: parsedJson['userId'],
        username: parsedJson['description']);
  }
}
