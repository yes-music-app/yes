import 'package:yes_music/models/album_model.dart';
import 'package:yes_music/models/artist_model.dart';

/// A data model for an track as returned by the Spotify API.
class TrackModel {
  final AlbumModel album;
  final ArtistModel artist;
  final List<ArtistModel> artists;
  final int duration;
  final String imageUri;
  final bool isEpisode;
  final bool isPodcast;
  final String name;
  final String spotifyUri;

  TrackModel.fromMap(Map map)
      : this.album = new AlbumModel.fromMap(map['album']),
        this.artist = new ArtistModel.fromMap(map['artist']),
        this.artists = mapArtists(map['artists']),
        this.duration = map['duration'],
        this.imageUri = map['imageUri'],
        this.isEpisode = map['isEpisode'],
        this.isPodcast = map['isPodcast'],
        this.name = map['name'],
        this.spotifyUri = map['spotifyUri'];

  static List<ArtistModel> mapArtists(List<Map> artists) {
    return artists.map((artist) => new ArtistModel.fromMap(artist));
  }
}
