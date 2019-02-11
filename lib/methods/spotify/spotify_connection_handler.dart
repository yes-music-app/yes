import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

enum CONNECTION_STATE {
  DISCONNECTED,
  CONNECTING,
  CONNECTED,
}

class SpotifyConnectionHandler {
  static const MethodChannel channel =
      const MethodChannel("yes.yesmusic/connection");

  /// A singleton instance of the Spotify connection handler.
  static final SpotifyConnectionHandler _instance =
      new SpotifyConnectionHandler._internal();

  factory SpotifyConnectionHandler() {
    return _instance;
  }

  SpotifyConnectionHandler._internal() {
    channel.setMethodCallHandler(_handleMethod);
  }

  /// Handles method calls from native side.
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "connectionUpdate":
        this._updateConnection(call.arguments);
        break;
      default:
        throw new UnimplementedError(
            "Method called from native side not implemented.");
        break;
    }
  }

  /// An rxdart [BehaviorSubject] that publishes the current connection state.
  BehaviorSubject<CONNECTION_STATE> _connectionSubject =
      new BehaviorSubject(seedValue: CONNECTION_STATE.DISCONNECTED);

  void _updateConnection(int state) {
    switch (state) {
      case 0:
        this._connectionSubject.add(CONNECTION_STATE.DISCONNECTED);
        break;
      case 1:
        this._connectionSubject.add(CONNECTION_STATE.CONNECTING);
        break;
      case 2:
        this._connectionSubject.add(CONNECTION_STATE.CONNECTED);
        break;
    }
  }

  /// Attempt to connect to the Spotify auth API.
  void connect() {
    channel.invokeMethod('connect');
    _connectionSubject.add(CONNECTION_STATE.CONNECTING);
  }

  /// Attempt to disconnect from the Spotify auth API.
  Future<int> disconnect() async {
    channel.invokeMethod("disconnect");
    this._connectionSubject.add(CONNECTION_STATE.DISCONNECTED);
  }

  void close() {
    this._connectionSubject.close();
  }
}
