import 'package:yes_music/models/spotify/track_model.dart';

/// A song in the app's queue.
class SongModel {
  /// The track to be played.
  final TrackModel _track;

  TrackModel get track => _track;

  /// A list of the string IDs of the users who upvoted this song.
  final List<String> _upvotes;

  List<String> get upvotes => _upvotes;

  /// A list of the string IDs of the users who downvoted this song.
  final List<String> _downvotes;

  List<String> get downvotes => _downvotes;

  SongModel(this._track, this._upvotes, this._downvotes);
}
