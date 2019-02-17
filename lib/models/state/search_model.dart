import 'package:yes_music/models/spotify/searchable_model.dart';

/// A user's search results.
class SearchModel {
  /// The query string entered by the user.
  final String query;

  /// The results returned by Spotify.
  final List<SearchableModel> results;

  SearchModel(this.query, this.results);
}
