import 'package:rxdart/rxdart.dart';

enum SpotifyConnectionState {
  DISCONNECTED,
  CONNECTING,
  CONNECTED,
  FAILED,
}

abstract class ConnectionHandlerBase {
  /// An rxdart [BehaviorSubject] that publishes the current connection state.
  BehaviorSubject<SpotifyConnectionState> get connectionSubject;

  /// Attempt to connect to the Spotify auth API.
  void connect();

  /// Attempt to disconnect from the Spotify auth API.
  void disconnect();
}
