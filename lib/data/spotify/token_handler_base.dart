abstract class TokenHandlerBase {
  /// Request the authorization URL from the Spotify Web API.
  Future<String> requestAuthUrl();

  /// Request an access token from the Spotify Web API.
  Future<dynamic> requestAccessToken(String code);
}