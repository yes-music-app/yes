import 'package:flutter/services.dart';

class SpotifyLoginHandler {
  static const MethodChannel platform =
      const MethodChannel("yes.yesmusic/connection");

  /// Attempt to login through the Spotify auth API. Returns an integer code
  /// representing the result status, mapped as follows:
  ///
  static Future<int> login() async {
    int loginResult = -1;

    try {
      loginResult = await platform.invokeMethod('login');
    } on PlatformException catch (e) {
      print("Failed to login: ${e.message}");
    }

    return loginResult;
  }
}
