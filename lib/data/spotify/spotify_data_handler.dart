import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yes_music/data/spotify/data_handler_base.dart';
import 'package:yes_music/helpers/data_utils.dart';
import 'package:yes_music/models/spotify/track_model.dart';
import 'package:yes_music/models/state/search_model.dart';

/// A class that handles data interactions with the Spotify app.
class SpotifyDataHandler implements DataHandlerBase {
  /// Searches with the given [query], using [accessToken] for authorization.
  @override
  Future<SearchModel> search(
    String query,
    String accessToken, {
    int limit = 20,
    int offset = 0,
  }) async {
    // The url of the search endpoint.
    final baseUrl = "https://api.spotify.com/v1/search";
    final Map<String, String> params = {
      "q": query,
      "type": "track",
      "limit": limit.toString(),
      "offset": offset.toString(),
    };

    // Set the auth header with the access token.
    final Map<String, String> headers = {
      "Authorization": "Bearer " + accessToken,
    };

    // Perform a search query on the generated url.
    dynamic res = await http.get(
      generateUrl(baseUrl, params),
      headers: headers,
    );

    // Decode the received objects.
    final Map items = jsonDecode(res.body);
    List<TrackModel> tracks = TrackModel.mapTracks(items["tracks"]["items"]);
    int total = items["tracks"]["total"];

    return SearchModel(tracks, total - tracks.length - offset);
  }
}
