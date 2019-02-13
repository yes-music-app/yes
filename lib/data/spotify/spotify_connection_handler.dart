import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';

class SpotifyConnectionHandler implements ConnectionHandlerBase {
  static const MethodChannel channel =
      const MethodChannel("yes.yesmusic/connection");

  /// A singleton instance of the Spotify connection handler.
  static final SpotifyConnectionHandler _instance =
      new SpotifyConnectionHandler._internal();

  factory SpotifyConnectionHandler() => _instance;

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
  BehaviorSubject<SpotifyConnectionState> _connectionSubject =
      new BehaviorSubject(seedValue: SpotifyConnectionState.DISCONNECTED);

  BehaviorSubject<SpotifyConnectionState> get connectionSubject =>
      this._connectionSubject;

  void _updateConnection(int state) {
    switch (state) {
      case 0:
        this._connectionSubject.add(SpotifyConnectionState.DISCONNECTED);
        break;
      case 1:
        this._connectionSubject.add(SpotifyConnectionState.CONNECTING);
        break;
      case 2:
        this._connectionSubject.add(SpotifyConnectionState.CONNECTED);
        break;
    }
  }

  /// Attempt to connect to the Spotify auth API.
  void connect() {
    channel.invokeMethod('connect');
    _connectionSubject.add(SpotifyConnectionState.CONNECTING);
  }

  void disconnect() {
    channel.invokeMethod("disconnect");
    this._connectionSubject.add(SpotifyConnectionState.DISCONNECTED);
  }

  void close() {
    this._connectionSubject.close();
  }
}
