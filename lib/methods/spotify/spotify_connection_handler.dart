import 'package:flutter/services.dart';

class SpotifyConnectionHandler {
  static const MethodChannel platform =
      const MethodChannel("yes.yesmusic/connection");

  /// Attempt to connect to the Spotify auth API. Returns an integer code
  /// representing the result status, mapped as follows:
  ///  - -1: connection failure
  ///  - 0: connection success
  static Future<int> connect() async {
    int result = -1;

    try {
      result = await platform.invokeMethod('connect');
    } on PlatformException catch (e) {
      print("Failed to connect: ${e.message}");
    }

    return result;
  }

  /// Attempt to disconnect from the Spotify auth API. Returns an integer code
  /// representing the result status, mapped as follows:
  ///  - -1: disconnection failure
  ///  - 0: disconnection success
  static Future<int> disconnect() async {
    int result = -1;

    try {
      result = await platform.invokeMethod("disconnect");
    } on PlatformException catch (e) {
      print("Failed to disconnect: ${e.message}");
    }

    return result;
  }
}
