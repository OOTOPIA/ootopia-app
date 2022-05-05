import 'package:photo_manager/photo_manager.dart';

Future<List<MediaPathEntity>> listMediaFolders() async {
  final result = await PhotoManager.getAssetPathList(hasAll: true);
  final List<MediaPathEntity> folders =
      result.map((folder) => MediaPathEntity(path: folder.name)).toList();
  return folders;
}

class MediaPathEntity {
  final String path;

  MediaPathEntity({
    required this.path,
  });
}
