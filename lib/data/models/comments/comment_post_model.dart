import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  String id;
  String postId;
  String userId;
  String text;
  String photoUrl;
  String username;
  bool deleted = false;
  DateTime createdAt;
  DateTime updatedAt;

  Comment(
      {this.id,
      this.postId,
      this.userId,
      this.text,
      this.photoUrl,
      this.username,
      this.deleted,
      this.createdAt,
      this.updatedAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      text: json['text'],
      photoUrl: json['photoUrl'],
      username: json['username'],
      deleted: (json['deleted'] == null ? false : json['deleted']),
      //createdAt: DateTime(json['createdAt']),
      //updatedAt: DateTime(json['updatedAt']),
    );
  }

  @override
  List<Object> get props => [
        id,
        postId,
        userId,
        text,
        photoUrl,
        username,
        deleted,
        createdAt,
        updatedAt,
      ];
}
