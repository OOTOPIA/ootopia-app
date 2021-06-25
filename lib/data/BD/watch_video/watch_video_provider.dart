import 'package:ootopia_app/data/BD/database.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_model.dart';
import 'package:sqflite/sqflite.dart';

class WatchVideoProvider {
  Future<WatchVideoModel> insert(WatchVideoModel watchVideoModel) async {
    if (watchVideoModel.watched == null) {
      watchVideoModel.watched = 0;
    }
    if (watchVideoModel.uploaded == null) {
      watchVideoModel.uploaded = 0;
    }

    watchVideoModel.createdAtInMs = (new DateTime.now().millisecondsSinceEpoch);
    watchVideoModel.updatedAtInMs = (new DateTime.now().millisecondsSinceEpoch);
    Database db = await OOTOPIADatabase.init().database;
    watchVideoModel.id =
        await db.insert(WatchVideoModel().tableName(), watchVideoModel.toMap());
    return watchVideoModel;
  }

  Future<WatchVideoModel> getByPostId(String postId) async {
    final db = await OOTOPIADatabase.init().database;

    final maps = await db.query(WatchVideoModel().tableName(),
        columns: WatchVideoFields.values,
        where: '''
            ${WatchVideoFields.postId} = ? AND 
            ${WatchVideoFields.watched} = 0 AND 
            ${WatchVideoFields.uploaded} = 0
            ''',
        whereArgs: [postId],
        orderBy: "${WatchVideoFields.id} DESC");

    if (maps.isNotEmpty) {
      return WatchVideoModel().fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> update(WatchVideoModel watchVideoModel) async {
    final db = await OOTOPIADatabase.init().database;

    if (watchVideoModel.watched == null) {
      watchVideoModel.watched = 0;
    }

    if (watchVideoModel.uploaded == null) {
      watchVideoModel.uploaded = 0;
    }

    watchVideoModel.updatedAtInMs = (new DateTime.now().millisecondsSinceEpoch);

    return await db.update(
      WatchVideoModel().tableName(),
      watchVideoModel.toMap(),
      where: '${WatchVideoFields.id} = ?',
      whereArgs: [watchVideoModel.id],
    );
  }

  Future<List<WatchVideoModel>> getNotUploadedPosts() async {
    final db = await OOTOPIADatabase.init().database;

    final maps = await db.query(WatchVideoModel().tableName(),
        columns: WatchVideoFields.values,
        where: '${WatchVideoFields.uploaded} = 0',
        orderBy: "${WatchVideoFields.id} DESC");

    if (maps.isNotEmpty) {
      return maps.map((post) => WatchVideoModel().fromMap(post)).toList();
    } else {
      return [];
    }
  }
}
