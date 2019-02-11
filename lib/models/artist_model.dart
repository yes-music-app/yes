/// A data model for an artist as returned by the Spotify API.
class ArtistModel {
  final String name;
  final String uri;

  ArtistModel.fromMap(Map map)
      : this.name = map['name'],
        this.uri = map['uri'];
}
