import 'package:yes_music/models/spotify/searchable_model.dart';

/// A user's search results.
class SearchModel {
  /// The query string entered by the user.
  final String _query;

  String get query => _query;

  /// The results returned by Spotify.
  final List<SearchableModel> _results;

  List<SearchableModel> get results => _results;

  SearchModel(this._query, this._results);
}
