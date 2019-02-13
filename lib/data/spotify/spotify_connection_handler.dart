import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';

class SpotifyConnectionHandler implements ConnectionHandlerBase {
  static const MethodChannel channel =
      const MethodChannel("yes.yesmusic/connection");

  SpotifyConnectionHandler() {
    channel.setMethodCallHandler(_handleMethod);
  }

  /// Handles method calls from native side.
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "connectionUpdate":
        _updateConnection(call.arguments);
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

  @override
  BehaviorSubject<SpotifyConnectionState> get connectionSubject =>
      _connectionSubject;

  void _updateConnection(int state) {
    switch (state) {
      case 0:
        _connectionSubject.add(SpotifyConnectionState.DISCONNECTED);
        break;
      case 1:
        _connectionSubject.add(SpotifyConnectionState.CONNECTING);
        break;
      case 2:
        _connectionSubject.add(SpotifyConnectionState.CONNECTED);
        break;
      case 3:
        _connectionSubject.add(SpotifyConnectionState.FAILED);
        break;
    }
  }

  @override
  void connect() {
    channel.invokeMethod('connect');
    _connectionSubject.add(SpotifyConnectionState.CONNECTING);
  }

  @override
  void disconnect() {
    channel.invokeMethod("disconnect");
    _connectionSubject.add(SpotifyConnectionState.DISCONNECTED);
  }

  @override
  void dispose() {
    _connectionSubject.close();
  }
}
