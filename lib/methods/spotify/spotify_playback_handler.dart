import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';
import 'package:yes_music/methods/playback_handler_base.dart';
import 'package:yes_music/models/player_state_model.dart';

/// A class that handles playback interactions with the Spotify app.
class SpotifyPlaybackHandler implements PlaybackHandlerBase {
  /// The method channel used for playback handling.
  static const MethodChannel channel =
      const MethodChannel("yes.yesmusic/playback");

  /// A singleton instance of the Spotify playback handler.
  static final SpotifyPlaybackHandler _instance =
      new SpotifyPlaybackHandler._internal();

  factory SpotifyPlaybackHandler() {
    return _instance;
  }

  SpotifyPlaybackHandler._internal() {
    channel.setMethodCallHandler(_handleMethod);
  }

  /// Handles method calls from native side.
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "updatePlayerState":
        _updatePlayerState(call.arguments);
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

  BehaviorSubject<PlayerStateModel> get playerStateSubject =>
      this._playerStateSubject;

  /// Adds a [PlayerStateModel] to the [_playerStateSubject] stream.
  void _updatePlayerState(Map map) {
    this._playerStateSubject?.add(new PlayerStateModel.fromMap(map));
  }

  @override
  void subscribeToPlayerState() {
    channel.invokeMethod("subscribeToPlayerState");
  }

  @override
  void unsubscribeFromPlayerState() {
    channel.invokeMethod("unsubscribeFromPlayerState");
  }

  @override
  void resume() {
    channel.invokeMethod("resume");
  }

  @override
  void pause() {
    channel.invokeMethod("pause");
  }

  @override
  void skipNext() {
    channel.invokeMethod("skipNext");
  }

  @override
  void skipPrevious() {
    channel.invokeMethod("skipPrevious");
  }

  @override
  void seekTo(int position) {
    channel.invokeMethod("seekTo", position);
  }

  @override
  void play(String trackUri) {
    channel.invokeMethod("play", trackUri);
  }

  @override
  void queue(String trackUri) {
    channel.invokeMethod("queue", trackUri);
  }

  void close() {
    this._playerStateSubject.close();
  }
}
