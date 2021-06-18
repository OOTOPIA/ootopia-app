import 'package:ootopia_app/data/BD/database.dart';
import 'package:ootopia_app/data/BD/base_model.dart';
import 'package:sqflite/sqflite.dart';

class WatchVideoModel implements BaseModel {
  int id;
  String postId;
  int positionInMs;
  int durationInMs;

  WatchVideoModel([this.postId, this.positionInMs, this.durationInMs]);

  @override
  String tableName() {
    return (WatchVideoModel).toString();
  }

  @override
  Future createTable() async {
    print("antes do create table");
    Database db = await OOTOPIADatabase.getInstance().database;
    print("depois do create table");
    return await db.execute("""
      CREATE TABLE ${tableName()}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id TEXT,
        position_in_ms INTEGER,
        duration_in_ms INTEGER
      )
    """);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'post_id': postId,
      'position_in_ms': positionInMs,
      'duration_in_ms': durationInMs,
    };
    return map;
  }

  @override
  WatchVideoModel fromMap(Map<String, dynamic> map) {
    var model = WatchVideoModel();
    model.id = map['id'];
    model.postId = map['post_id'];
    model.positionInMs = map['position_in_ms'];
    model.durationInMs = map['duration_in_ms'];
    return model;
  }
}
