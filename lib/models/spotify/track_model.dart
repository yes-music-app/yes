import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/album_model.dart';
import 'package:yes_music/models/spotify/artist_model.dart';

/// A data model for an track as returned by the Spotify API.
class TrackModel {
  final AlbumModel album;
  final List<ArtistModel> artists;
  final int duration;
  final String name;
  final String uri;

  TrackModel.fromMap(Map map)
      : album = AlbumModel.fromMap(map["album"]),
        artists = ArtistModel.mapArtists(map["artists"]),
        duration = map["duration_ms"],
        name = map["name"],
        uri = map["uri"];

  static List<TrackModel> mapTracks(List tracks) {
    if (tracks == null) {
      return null;
    }

    return tracks.map((track) => TrackModel.fromMap(track)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "album": album.toMap(),
      "artists": ArtistModel.toMapList(artists),
      "duration": duration,
      "name": name,
      "uri": uri,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<TrackModel> models) {
    return models?.map((model) => model.toMap())?.toList();
  }

  @override
  bool operator ==(other) =>
      other is TrackModel &&
      other.album == album &&
      listsEqual(other.artists, artists) &&
      other.duration == duration &&
      other.name == name &&
      other.uri == uri;

  @override
  int get hashCode =>
      album.hashCode ^
      artists.hashCode ^
      duration.hashCode ^
      name.hashCode ^
      uri.hashCode;
}
