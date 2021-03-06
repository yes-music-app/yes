import 'package:yes_music/models/spotify/track_model.dart';
import 'package:yes_music/models/state/search_model.dart';

abstract class DataHandlerBase {
  /// Searches with the given [query], using [accessToken] for authorization.
  /// Uses [limit] and [offset] for paging.
  Future<SearchModel> search(
    String query,
    String accessToken, {
    List<TrackModel> prevTracks = const [],
    int limit = 20,
  });
}
