import 'package:flutter/services.dart';
import 'package:yes_music/methods/spotify/spotify_method_handler.dart';

class SpotifyLoginHandler {
  /// Attempt to login through the Spotify auth API. Returns an integer code
  /// representing the result status, mapped as follows:
  ///
  static Future<int> login() async {
    int loginResult = -1;

    try {
      loginResult = await SpotifyMethodHandler.platform.invokeMethod('login');
    } on PlatformException catch (e) {
      print("Failed to login: ${e.message}");
    }

    return loginResult;
  }
}
