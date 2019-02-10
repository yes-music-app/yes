import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';
import 'package:yes_music/models/player_state_model.dart';

/// A class that handles playback interactions with the Spotify app.
class SpotifyPlaybackHandler {
  /// The method channel used for playback handling.
  static const MethodChannel platform =
      const MethodChannel("yes.yesmusic/playback");

  /// A singleton instance of the Spotify playback handler.
  static final SpotifyPlaybackHandler _instance =
      new SpotifyPlaybackHandler._internal();

  factory SpotifyPlaybackHandler() {
    return _instance;
  }

  SpotifyPlaybackHandler._internal() {
    platform.setMethodCallHandler(_handleMethod);
  }

  /// Handles method calls from native side.
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "updatePlayerState":
        break;
      default:
        throw new UnimplementedError(
            "Method called from native side not implemented.");
        break;
    }
  }

  /// An rxdart [BehaviorSubject] that publishes the current state of the music
  /// player in the Spotify app.
  BehaviorSubject<PlayerStateModel> _playerStateSubject =
      new BehaviorSubject(seedValue: null);

  void playerStateSubscribe() {
    if (this._playerStateSubject == null) {}
  }

  void close() {
    this._playerStateSubject.close();
  }
}
