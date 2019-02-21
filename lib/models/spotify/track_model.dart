import 'package:yes_music/models/spotify/album_model.dart';
import 'package:yes_music/models/spotify/artist_model.dart';
import 'package:yes_music/models/spotify/searchable_model.dart';

/// A data model for an track as returned by the Spotify API.
class TrackModel implements SearchableModel {
  final AlbumModel album;
  final ArtistModel artist;
  final List<ArtistModel> artists;
  final int duration;
  final String imageUri;
  final String name;
  final String uri;

  @override
  TrackModel.fromMap(Map map)
      : album = new AlbumModel.fromMap(map["album"]),
        artist = new ArtistModel.fromMap(map["artist"]),
        artists = ArtistModel.mapArtists(map["artists"]),
        duration = map["duration"] != null ? map["duration"] : map["duration_ms"],
        imageUri = map["imageUri"],
        name = map["name"],
        uri = map["uri"];

  @override
  Map<String, dynamic> toMap() {
    return {
      "album": album.toMap(),
      "artist": artist.toMap(),
      "artists": ArtistModel.toMapList(artists),
      "duration": duration,
      "imageUri": imageUri,
      "name": name,
      "uri": uri,
    };
  }
}
