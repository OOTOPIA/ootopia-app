import 'package:ootopia_app/data/BD/base_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import './watch_video/watch_video_model.dart';
import 'package:path/path.dart';

class OOTOPIADatabase {
  static OOTOPIADatabase _instance;

  static Database _database;

  List<BaseModel> tables = [
    WatchVideoModel(),
  ];

  String _databaseName = 'ootopia_db.db';

  //OOTOPIADatabase._createInstance();

  OOTOPIADatabase();

  static getInstance() {
    if (_instance == null) {
      _instance = OOTOPIADatabase();
    }

    return _instance;
  }

  Future<Database> get database async {
    if (_database == null) {
      print("CAIU AQUI DENTRO");
      _database = await initializeDatabase();
      print("CAIU AQUI DEPOIS DE DENTRO");
    }

    print("NEM CAIU VEI");

    return _database;
  }

  Future<Database> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        for (var table in tables) {
          await table.createTable();
        }
      },
    );
  }
}
