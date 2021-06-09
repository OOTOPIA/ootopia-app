class WatchVideoModelDB {
  String id;
  String postId;
  String watched;
  String uploaded;

  WatchVideoModelDB(this.id, this.postId, this.watched, this.uploaded);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'post_id': postId,
      'watched': watched,
      'uploaded': uploaded,
    };
    return map;
  }

  WatchVideoModelDB.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    postId = map['post_id'];
    watched = map['watched'];
    uploaded = map['uploaded'];
  }
}
