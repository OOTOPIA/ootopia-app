import 'package:ootopia_app/data/BD/database.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:sqflite/sqflite.dart';

class WatchVideoProvider with SecureStoreMixin {
  Future<WatchVideoModel> insert(WatchVideoModel watchVideoModel) async {
    if (watchVideoModel.watched == null) {
      watchVideoModel.watched = 0;
    }
    if (watchVideoModel.uploaded == null) {
      watchVideoModel.uploaded = 0;
    }

    if (watchVideoModel.createdAtInMs == null) {
      watchVideoModel.createdAtInMs =
          (new DateTime.now().millisecondsSinceEpoch);
    }
    watchVideoModel.updatedAtInMs = (new DateTime.now().millisecondsSinceEpoch);
    Database db = await OOTOPIADatabase.init().database;
    watchVideoModel.id =
        await db.insert(WatchVideoModel().tableName(), watchVideoModel.toMap());
    return watchVideoModel;
  }

  Future<WatchVideoModel?> getByPostId(String postId) async {
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

    if (maps.isNotEmpty && maps.length > 0) {
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

    User? user;
    bool loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
    }
    String? userId = (user != null ? user.id : null);

    if (userId == null) {
      return [];
    }

    final maps = await db.query(WatchVideoModel().tableName(),
        columns: WatchVideoFields.values,
        where:
            '${WatchVideoFields.uploaded} = 0 AND ${WatchVideoFields.userId} = ?',
        whereArgs: [userId],
        orderBy: "${WatchVideoFields.id} DESC");

    if (maps.isNotEmpty) {
      return maps.map((post) => WatchVideoModel().fromMap(post)).toList();
    } else {
      return [];
    }
  }

  Future<List<WatchVideoModel>> removeDuplicateEntries(
      List<WatchVideoModel> notUploadedPosts) async {
    final db = await OOTOPIADatabase.init().database;

    final List<int> entriesToRemove = [];

    for (WatchVideoModel watchVideo in notUploadedPosts) {
      bool checkDuplicate = (notUploadedPosts
              .where((obj) =>
                  obj.postId == watchVideo.postId &&
                  obj.timeInMilliseconds == watchVideo.timeInMilliseconds &&
                  obj.id != watchVideo.id)
              .toList()
              .length) >
          1;
      if (checkDuplicate && entriesToRemove.indexOf(watchVideo.id!) == -1) {
        entriesToRemove.add(watchVideo.id!);
      }
    }

    for (int id in entriesToRemove) {
      await db.delete(
        WatchVideoModel().tableName(),
        where: '${WatchVideoFields.id} = ?',
        whereArgs: [id],
      );
      notUploadedPosts.removeWhere((obj) => obj.id == id);
    }

    return notUploadedPosts;
  }
}
