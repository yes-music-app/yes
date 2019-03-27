import 'package:yes_music/helpers/list_utils.dart';
import 'package:yes_music/models/spotify/track_model.dart';

/// A user's search results.
class SearchModel {
  /// The query string entered by the user.
  final String query;

  /// The results returned by Spotify.
  final List<TrackModel> results;

  SearchModel(this.query, this.results);

  SearchModel.fromMap(Map map)
      : query = map["query"],
        results = TrackModel.mapTracks(map["results"]);

  Map<String, dynamic> toMap() {
    return {
      "query": query,
      "results": TrackModel.toMapList(results),
    };
  }

  @override
  bool operator ==(other) =>
      other is SearchModel &&
      other.query == query &&
      listsEqual(other.results, results);

  @override
  int get hashCode => query.hashCode ^ results.hashCode;
}
