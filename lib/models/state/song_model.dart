import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/track_model.dart';

const String QID_KEY = "qid";
const String TRACK_KEY = "track";
const String UID_KEY = "uid";
const String UPVOTES_KEY = "upvotes";
const String TIME_KEY = "time";

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

  /// The time at which this song was added to the queue.
  final int time;

  SongModel(this.qid, this.track, this.uid, this.upvotes, this.time);

  SongModel.fromMap(Map map)
      : qid = map[QID_KEY],
        track = TrackModel.fromMap(map[TRACK_KEY]),
        uid = map[UID_KEY],
        upvotes = listToString(map[UPVOTES_KEY] ?? []),
        time = map[TIME_KEY];

  static List<SongModel> fromMapOfMaps(Map songs) {
    if (songs?.values == null) {
      return [];
    }

    // Get a list of the songs and map them.
    return songs.values.map((song) => SongModel.fromMap(song)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      QID_KEY: qid,
      TRACK_KEY: track.toMap(),
      UID_KEY: uid,
      UPVOTES_KEY: upvotes,
      TIME_KEY: time,
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
      listsEqual(other.upvotes, upvotes) &&
      other.time == time;

  @override
  int get hashCode =>
      qid.hashCode ^
      track.hashCode ^
      uid.hashCode ^
      upvotes.hashCode ^
      time.hashCode;
}
