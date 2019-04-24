import 'package:yes_music/models/spotify/track_model.dart';

/// A class representing a search on the Spotify search endpoint.
///  - [tracks] == null => tracks loading
///  - [tracks] == [] => no tracks
class SearchModel {
  /// The tracks that have been returned by this search.
  final List<TrackModel> tracks;

  /// The amount of tracks left that can be loaded.
  final int remainder;

  /// Creates a [SearchModel] with the given [tracks] and [remainder].
  SearchModel(this.tracks, this.remainder);

  /// Creates an empty [SearchModel].
  SearchModel.empty() : tracks = null, remainder = 0;
}
