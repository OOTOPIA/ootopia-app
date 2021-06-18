import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import './models_bd/watch_video_model.dart';

class OOTOPIADatabase {
  static OOTOPIADatabase _instance;

  static Database _database;

  //Names data table
  String _databaseName = 'ootopia_db.db';
  String _watchVideoTable = 'watch_video';
  String id = 'id';
  String postId = 'post_id';
  String currentPosition = 'current_position';
  String duration = 'duration';

  OOTOPIADatabase._createInstance();

  factory OOTOPIADatabase() {
    if (_instance == null) {
      _instance = OOTOPIADatabase._createInstance();
    }

    return _instance;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + _databaseName;

    var _watchDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );

    return _watchDatabase;
  }

// openDatabase("ootopia_db.db")
  void _createDB(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $_watchVideoTable ($id INTEGER PRIMARY KEY, $postId TEXT NOT NULL, $currentPosition INTEGER NOT NULL, $duration INTEGER NOT NULL)',
    );
  }

  // void insertWatchVideo(Database db, videoData) async {
  //   await db.insert(this.watchVideoTable, values)
  // }

  Future<int> insertWatchVideo(
      {String postId, int position, int duration}) async {
    Database db = await _instance.database;

    if (postId != null && position != null && duration != null) {
      var res = await db.rawInsert(
          'INSERT Into $_watchVideoTable ($postId,$currentPosition,$duration)'
          " VALUES ($postId,$position;$position,$duration)");
      return res;
    }
  }

  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await _instance.database;
  //   int id = row[columnId];
  //   return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  // }

  // // Deletes the row specified by the id. The number of affected rows is
  // // returned. This should be 1 as long as the row exists.
  // Future<int> delete(int id) async {
  //   Database db = await _instance.database;
  //   return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  // }
}
