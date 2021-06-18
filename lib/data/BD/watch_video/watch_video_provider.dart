import 'package:ootopia_app/data/BD/database.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_model.dart';
import 'package:sqflite/sqflite.dart';

class WatchVideoProvider {
  Future<WatchVideoModel> insert(WatchVideoModel watchVideoModel) async {
    print("antes do insert");
    Database db = await OOTOPIADatabase().database;
    print("vai?");
    watchVideoModel.id =
        await db.insert(watchVideoModel.tableName(), watchVideoModel.toMap());
    print('nao foi');
    return watchVideoModel;
  }

  Future close() async => (await OOTOPIADatabase().database).close();
}
