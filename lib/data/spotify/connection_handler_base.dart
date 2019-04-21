/// Interface for a class that handles connections with Spotify.
abstract class ConnectionHandlerBase {
  /// Request the authorization URL from the Spotify Web API.
  Future<String> requestAuthUrl();

  /// Request an access token from the Spotify Web API.
  Future<dynamic> requestAccessToken(String code);

  /// Attempt to connect to the Spotify auth API.
  Future connect();

  /// Attempt to disconnect from the Spotify auth API.
  void disconnect();
}
