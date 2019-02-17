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
}
