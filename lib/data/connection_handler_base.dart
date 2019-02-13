import 'package:rxdart/rxdart.dart';

enum CONNECTION_STATE {
  DISCONNECTED,
  CONNECTING,
  CONNECTED,
}

abstract class ConnectionHandlerBase {
  /// An rxdart [BehaviorSubject] that publishes the current connection state.
  BehaviorSubject<CONNECTION_STATE> get connectionSubject;

  /// Attempt to connect to the Spotify auth API.
  void connect();

  /// Attempt to disconnect from the Spotify auth API.
  void disconnect();
}
