abstract class TokenHandlerBase {
  /// Request the authorization URL from the Spotify Web API.
  Future<String> requestAuthUrl();
}