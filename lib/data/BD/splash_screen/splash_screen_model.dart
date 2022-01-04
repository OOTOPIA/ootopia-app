import 'package:ootopia_app/data/BD/base_model.dart';
import 'package:sqflite/sqflite.dart';

class SplashScreenModel implements BaseModel {
  String? lastDateTime;

  SplashScreenModel({
    this.lastDateTime,
  });

  @override
  String tableName() {
    return (SplashScreenModel).toString();
  }

  @override
  Future createTable(Database db) async {
    return await db.execute("""
      CREATE TABLE ${tableName()}(
        ${SplashScreenFields.lastDateTime} TEXT,
      )
    """);
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SplashScreenFields.lastDateTime: lastDateTime,
    };
    return map;
  }

  @override
  SplashScreenModel fromMap(Map<String, dynamic> map) {
    var model = SplashScreenModel(
      lastDateTime: map[SplashScreenFields.lastDateTime],
    );
    return model;
  }
}

class SplashScreenFields {
  static final List<String> values = [
    lastDateTime,
  ];

  static final String lastDateTime = '_lastDateTime';
}
