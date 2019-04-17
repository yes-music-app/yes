import 'package:flutter/services.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';

class SpotifyConnectionHandler implements ConnectionHandlerBase {
  static const MethodChannel channel =
      const MethodChannel("yes.yesmusic/connection");

  @override
  Future connect() async {
    await channel.invokeMethod("connect").catchError((e) {
      throw StateError("errors.remote.connect");
    });
  }

  @override
  void disconnect() {
    channel.invokeMethod("disconnect");
  }
}
