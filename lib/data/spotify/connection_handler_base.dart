/// Interface for a class that handles connections with Spotify.
abstract class ConnectionHandlerBase {
  /// Attempt to connect to the Spotify auth API.
  Future connect();

  /// Attempt to disconnect from the Spotify auth API.
  void disconnect();
}
