import 'package:ootopia_app/data/BD/base_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import './watch_video/watch_video_model.dart';
import 'package:path/path.dart';

class OOTOPIADatabase {
  static final OOTOPIADatabase instance = OOTOPIADatabase.init();

  static Database? _database;

  String _databaseName = 'ootopia.db';
  List<BaseModel> tables = [
    WatchVideoModel(),
  ];

  OOTOPIADatabase.init();

  static getInstance() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(_databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int newVersion) async {
    for (var table in tables) {
      await table.createTable(db);
    }
  }

  Future close() async => (await instance.database).close();
}
