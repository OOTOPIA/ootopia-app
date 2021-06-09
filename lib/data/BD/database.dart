import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import './models_bd/watch_video_model.dart';

class OOTOPIADatabase {
  static OOTOPIADatabase _instance;

  static Database _database;

  //Names data table
  String watchVideoTable = 'Watch';
  String id = 'id';
  String postId = 'post_id';
  String watched = 'watched';
  String uploaded = 'uploaded';

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
    String path = databasesPath + 'ootopia_db.db';

    var watchDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );

    return watchDatabase;
  }

// openDatabase("ootopia_db.db")
  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE Watch (id INTEGER PRIMARY KEY, post_id TEXT, watched TEXT, uploaded TEXT)');
  }

  // void insertWatchVideo(Database db, videoData) async {
  //   await db.insert(this.watchVideoTable, values)
  // }
}
