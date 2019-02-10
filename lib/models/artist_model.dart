/// A data model for an artist as returned by the Spotify API.
class ArtistModel {
  final String name;
  final String spotifyUri;

  ArtistModel.fromMap(Map map)
      : this.name = map['name'],
        this.spotifyUri = map['spotifyUri'];
}
