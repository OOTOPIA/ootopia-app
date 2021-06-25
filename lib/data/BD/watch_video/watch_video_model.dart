import 'package:ootopia_app/data/BD/database.dart';
import 'package:ootopia_app/data/BD/base_model.dart';
import 'package:sqflite/sqflite.dart';

class WatchVideoModel implements BaseModel {
  int id;
  String postId;
  int timeInMilliseconds;
  int durationInMs;
  int watched;
  int uploaded; //To check if this is uploaded to the server
  int createdAtInMs;
  int updatedAtInMs;

  WatchVideoModel([
    this.postId,
    this.timeInMilliseconds,
    this.durationInMs,
    this.watched,
    this.uploaded,
    this.createdAtInMs,
    this.updatedAtInMs,
  ]);

  @override
  String tableName() {
    return (WatchVideoModel).toString();
  }

  @override
  Future createTable(Database db) async {
    return await db.execute("""
      CREATE TABLE ${tableName()}(
        ${WatchVideoFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${WatchVideoFields.postId} TEXT,
        ${WatchVideoFields.timeInMilliseconds} INTEGER,
        ${WatchVideoFields.durationInMs} INTEGER,
        ${WatchVideoFields.watched} INTEGER,
        ${WatchVideoFields.uploaded} INTEGER,
        ${WatchVideoFields.createdAtInMs} INTEGER,
        ${WatchVideoFields.updatedAtInMs} INTEGER
      )
    """);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      WatchVideoFields.id: id,
      WatchVideoFields.postId: postId,
      WatchVideoFields.timeInMilliseconds: timeInMilliseconds,
      WatchVideoFields.durationInMs: durationInMs,
      WatchVideoFields.watched: watched,
      WatchVideoFields.uploaded: uploaded,
      WatchVideoFields.createdAtInMs: createdAtInMs,
      WatchVideoFields.updatedAtInMs: updatedAtInMs,
    };
    return map;
  }

  @override
  WatchVideoModel fromMap(Map<String, dynamic> map) {
    var model = WatchVideoModel();
    model.id = map[WatchVideoFields.id];
    model.postId = map[WatchVideoFields.postId];
    model.timeInMilliseconds = map[WatchVideoFields.timeInMilliseconds];
    model.durationInMs = map[WatchVideoFields.durationInMs];
    model.watched = map[WatchVideoFields.watched];
    model.uploaded = map[WatchVideoFields.uploaded];
    model.createdAtInMs = map[WatchVideoFields.createdAtInMs];
    model.updatedAtInMs = map[WatchVideoFields.updatedAtInMs];
    return model;
  }
}

class WatchVideoFields {
  static final List<String> values = [
    id,
    postId,
    timeInMilliseconds,
    durationInMs,
    watched,
    uploaded,
    createdAtInMs,
    updatedAtInMs
  ];

  static final String id = '_id';
  static final String postId = 'post_id';
  static final String timeInMilliseconds = 'time_in_milliseconds';
  static final String durationInMs = 'duration_in_ms';
  static final String watched = 'watched';
  static final String uploaded = 'uploaded';
  static final String createdAtInMs = 'created_at_in_ms';
  static final String updatedAtInMs = 'updated_at_in_ms';
}
