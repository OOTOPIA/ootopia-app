import 'package:sqflite/sqflite.dart';

abstract class BaseModel {
  String tableName();
  Future createTable(Database db);
  Map<String, dynamic> toMap();
  dynamic fromMap(Map<String, dynamic> map);
}
