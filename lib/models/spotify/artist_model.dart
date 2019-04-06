import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/image_model.dart';
import 'package:yes_music/models/spotify/searchable_model.dart';

/// A data model for an artist as returned by the Spotify API.
class ArtistModel implements SearchableModel {
  final String name;
  final String uri;
  final String id;
  final List<ImageModel> images;

  @override
  ArtistModel.fromMap(Map map)
      : name = map["name"],
        uri = map["uri"],
        id = map["id"],
        images = ImageModel.mapImages(map["images"]);

  static List<ArtistModel> mapArtists(List artists) {
    if (artists == null) {
      return null;
    }

    return artists.map((artist) => ArtistModel.fromMap(artist)).toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uri": uri,
      "id": id,
      "images": ImageModel.toMapList(images),
    };
  }

  static List<Map<String, dynamic>> toMapList(List<ArtistModel> models) {
    return models?.map((model) => model.toMap())?.toList();
  }

  @override
  bool operator ==(other) =>
      other is ArtistModel &&
      other.name == name &&
      other.uri == uri &&
      other.id == id &&
      listsEqual(other.images, images);

  @override
  int get hashCode =>
      name.hashCode ^ uri.hashCode ^ id.hashCode ^ images.hashCode;
}
