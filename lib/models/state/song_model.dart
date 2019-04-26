import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/track_model.dart';

const String QID_KEY = "qid";
const String TRACK_KEY = "track";
const String UID_KEY = "uid";
const String UPVOTES_KEY = "upvotes";

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
      : qid = map[QID_KEY],
        track = TrackModel.fromMap(map[TRACK_KEY]),
        uid = map[UID_KEY],
        upvotes = listToString(map[UPVOTES_KEY] ?? []);

  static List<SongModel> fromMapOfMaps(Map songs) {
    if (songs?.values == null) {
      return [];
    }

    // Get a list of the songs and map them.
    return songs.values.map((song) => SongModel.fromMap(song)).toList();
  }

  static List<SongModel> fromListOfMaps(List songs) {
    if (songs == null) {
      return [];
    }

    // Map the songs.
    return songs.map((map) => SongModel.fromMap(map)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      QID_KEY: qid,
      TRACK_KEY: track.toMap(),
      UID_KEY: uid,
      UPVOTES_KEY: upvotes,
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
