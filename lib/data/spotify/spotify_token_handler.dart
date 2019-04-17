import 'package:cloud_functions/cloud_functions.dart';
import 'package:yes_music/data/spotify/token_handler_base.dart';

class SpotifyTokenHandler implements TokenHandlerBase {
  /// Request the authorization URL from the Spotify Web API.
  Future<String> requestAuthUrl() async {
    try {
      return await CloudFunctions.instance.call(
        functionName: "requestAuth",
      );
    } catch (e) {
      throw StateError("errors.spotify.auth_url");
    }
  }
}