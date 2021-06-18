abstract class BaseModel {
  String tableName();
  Future createTable();
  Map<String, dynamic> toMap();
  dynamic fromMap(Map<String, dynamic> map);
}
