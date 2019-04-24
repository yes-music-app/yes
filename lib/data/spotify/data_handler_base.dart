import 'package:yes_music/models/state/search_model.dart';

abstract class DataHandlerBase {
  /// Searches with the given [query], using [accessToken] for authorization.
  /// Uses [limit] and [offset] for paging.
  Future<SearchModel> search(
    String query,
    String accessToken, {
    int limit = 20,
    int offset = 0,
  });
}
