abstract class PlaybackHandlerBase {
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
}
