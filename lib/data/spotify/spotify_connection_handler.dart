import 'package:flutter/services.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';

class SpotifyConnectionHandler implements ConnectionHandlerBase {
  final MethodChannel _channel = const MethodChannel("yes.yesmusic/connection");

  @override
  Future connect() async {
    await _channel.invokeMethod("connect").catchError((e) {
      throw StateError("errors.remote.connect");
    });
  }

  @override
  void disconnect() {
    _channel.invokeMethod("disconnect");
  }
}
