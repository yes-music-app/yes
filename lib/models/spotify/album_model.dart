import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/image_model.dart';

/// A data model for an album as returned by the Spotify API.
class AlbumModel {
  final String name;
  final String uri;
  final String id;
  final List<ImageModel> images;

  AlbumModel.fromMap(Map map)
      : name = map["name"],
        uri = map["uri"],
        id = map["id"],
        images = ImageModel.mapImages(map["images"]);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uri": uri,
      "id": id,
      "images": ImageModel.toMapList(images),
    };
  }

  @override
  bool operator ==(other) =>
      other is AlbumModel &&
      other.name == name &&
      other.uri == uri &&
      other.id == id &&
      listsEqual(other.images, images);

  @override
  int get hashCode =>
      name.hashCode ^ uri.hashCode ^ id.hashCode ^ images.hashCode;
}
