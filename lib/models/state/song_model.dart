import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/track_model.dart';

/// A song in the app's queue.
class SongModel {
  /// The automatically generated queue ID for this song.
  final String qid;

  /// The track to be played.
  final TrackModel track;

  /// The user who suggested this song.
  final String uid;

  /// A list of the string IDs of the users who upvoted this song.
  final List<String> upvotes;

  SongModel(this.qid, this.track, this.uid, this.upvotes);

  SongModel.fromMap(Map map)
      : qid = map["qid"],
        track = TrackModel.fromMap(map["track"]),
        uid = map["uid"],
        upvotes = listToString(map["upvotes"] ?? []);

  static List<SongModel> fromMapList(List songs) {
    if (songs == null) {
      return [];
    }
    return songs.map((song) => SongModel.fromMap(song)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "qid": qid,
      "track": track.toMap(),
      "uid": uid,
      "upvotes": upvotes,
    };
  }

  static List<Map<String, dynamic>> toMapList(List<SongModel> models) {
    return models?.map((model) => model.toMap())?.toList();
  }

  @override
  bool operator ==(other) =>
      other is SongModel &&
      other.qid == qid &&
      other.track == track &&
      other.uid == uid &&
      listsEqual(other.upvotes, upvotes);

  @override
  int get hashCode =>
      qid.hashCode ^ track.hashCode ^ uid.hashCode ^ upvotes.hashCode;
}
