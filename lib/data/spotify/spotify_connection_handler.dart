import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:yes_music/data/spotify/connection_handler_base.dart';

class SpotifyConnectionHandler implements ConnectionHandlerBase {
  final MethodChannel _channel = const MethodChannel("yes.yesmusic/connection");

  /// Request the authorization URL from the Spotify Web API.
  @override
  Future<String> requestAuthUrl() async {
    try {
      return await CloudFunctions.instance.call(
        functionName: "requestAuth",
      );
    } catch (e) {
      throw StateError("errors.spotify.auth_url");
    }
  }

  /// Request an access token from the Spotify Web API.
  @override
  Future<Map> requestAccessToken(String code) async {
    try {
      return await CloudFunctions.instance.call(
        functionName: "requestAccessToken",
        parameters: {"code": code},
      );
    } catch (e) {
      throw StateError("errors.spotify.auth_cancel");
    }
  }

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
