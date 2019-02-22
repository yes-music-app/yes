import 'package:yes_music/models/spotify/track_model.dart';

/// A song in the app's queue.
class SongModel {
  /// The track to be played.
  final TrackModel track;

  /// The user who suggested this song.
  final String uid;

  /// A list of the string IDs of the users who upvoted this song.
  final List<String> upvotes;

  SongModel(this.track, this.uid, this.upvotes);

  SongModel.fromMap(Map map)
      : track = TrackModel.fromMap(map["track"]),
        uid = map["uid"],
        upvotes = map["upvotes"];

  static List<SongModel> fromMapList(List songs) {
    return songs?.map((song) => new SongModel.fromMap(song))?.toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "track": track.toMap(),
      "uid": uid,
      "upvotes": upvotes,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<SongModel> models) {
    return models?.map((model) => model.toMap())?.toList();
  }
}
