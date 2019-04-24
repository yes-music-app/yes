import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yes_music/models/spotify/player_state_model.dart';
import 'package:yes_music/models/state/search_model.dart';

abstract class PlaybackHandlerBase {
  /// A stream of player state objects.
  ValueObservable<PlayerStateModel> get playerState;

  /// Adds a subscription to [_playerStateSubject].
  void subscribeToPlayerState();

  /// Removes a subscription from the Spotify API player state stream.
  void unsubscribeFromPlayerState();

  /// Resumes playback if it was paused.
  void resume();

  /// Pauses playback if it was playing.
  void pause();

  /// Skips to the next song in the queue.
  void skipNext();

  /// Skips to the previous song in the queue.
  void skipPrevious();

  /// Seeks to the position denoted by [position] in the currently playing song.
  void seekTo(int position);

  /// Plays the song with the given [trackUri].
  void play(String trackUri);

  /// Queues the song with the given [trackUri].
  void queue(String trackUri);

  /// Gets the image with the given [imageUri].
  Future<Image> getImage(String imageUri);

  /// Closes the handler's connections.
  void dispose();

  /// Searches with the given [query], using [accessToken] for authorization.
  /// Uses [limit] and [offset] for paging.
  Future<SearchModel> search(
    String query,
    String accessToken, {
    int limit = 20,
    int offset = 0,
  });
}
