/// A data model for an album as returned by the Spotify API.
class AlbumModel {
  final String name;
  final String spotifyUri;

  AlbumModel.fromMap(Map map)
      : this.name = map['name'],
        this.spotifyUri = map['spotifyUri'];
}
