const String NAME_KEY = "name";
const String ARTIST_URI_KEY = "uri";

/// A data model for an artist as returned by the Spotify API.
class ArtistModel {
  final String name;
  final String uri;

  ArtistModel.fromMap(Map map)
      : name = map[NAME_KEY],
        uri = map[ARTIST_URI_KEY];

  static List<ArtistModel> mapArtists(List artists) {
    if (artists == null) {
      return null;
    }

    return artists.map((artist) => ArtistModel.fromMap(artist)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      NAME_KEY: name,
      ARTIST_URI_KEY: uri,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<ArtistModel> models) {
    return models?.map((model) => model.toMap())?.toList();
  }

  @override
  bool operator ==(other) =>
      other is ArtistModel && other.name == name && other.uri == uri;

  @override
  int get hashCode => name.hashCode ^ uri.hashCode;
}
