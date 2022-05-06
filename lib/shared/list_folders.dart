import 'package:photo_manager/photo_manager.dart';

Future<List<MediaPathEntity>> listMediaFolders() async {
  final result = await PhotoManager.getAssetPathList(hasAll: true);
  final List<MediaPathEntity> folders = result
      .map((folder) => MediaPathEntity(
            name: folder.name,
            assetPathEntity: folder,
          ))
      .toList();
  return folders;
}

class MediaPathEntity {
  final String name;
  final AssetPathEntity _assetPathEntity;

  MediaPathEntity({
    required this.name,
    required AssetPathEntity assetPathEntity,
  }) : _assetPathEntity = assetPathEntity;

  Future<List<AssetEntity>> getAssetListRange(int start, int end) async {
    return _assetPathEntity.getAssetListRange(start: start, end: end);
  }
}
