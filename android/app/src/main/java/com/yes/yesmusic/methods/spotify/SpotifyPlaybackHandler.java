package com.yes.yesmusic.methods.spotify;

import static com.yes.yesmusic.methods.spotify.SpotifyDataMappers.mapPlayerState;

import com.spotify.android.appremote.api.SpotifyAppRemote;
import com.spotify.protocol.client.Subscription;
import com.spotify.protocol.types.PlayerState;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * A class that handles playback control in Spotify.
 */
public class SpotifyPlaybackHandler implements MethodCallHandler {

  private SpotifyAppRemote remote;
  private final MethodChannel channel;
  private Subscription<PlayerState> playerStateSubscription;
  private int playerStateSubscriptions = 0;

  public SpotifyPlaybackHandler(MethodChannel channel) {
    this.channel = channel;
  }

  void setRemote(SpotifyAppRemote remote) {
    this.remote = remote;
  }

  SpotifyAppRemote getRemote() {
    return this.remote;
  }

  @Override
  public void onMethodCall(MethodCall methodCall, Result result) {
    switch (methodCall.method) {
      case "subscribeToPlayerState":
        addPlayerStateSubscription();
        result.success(null);
        break;
      case "unsubscribeFromPlayerState":
        cancelPlayerStateSubscription();
        result.success(null);
        break;
      case "resume":
        remote.getPlayerApi().resume();
        result.success(null);
        break;
      case "pause":
        remote.getPlayerApi().pause();
        result.success(null);
        break;
      case "skipNext":
        remote.getPlayerApi().skipNext();
        result.success(null);
        break;
      case "skipPrevious":
        remote.getPlayerApi().skipPrevious();
        result.success(null);
        break;
      case "seekTo":
        if (methodCall.arguments instanceof Long) {
          remote.getPlayerApi().seekTo((long) methodCall.arguments);
          result.success(null);
        } else {
          result.error("FAILURE", "Seek received a non-long argument", null);
        }
        break;
      case "play":
        if (methodCall.arguments instanceof String) {
          remote.getPlayerApi().play((String) methodCall.arguments);
          result.success(null);
        } else {
          result.error("FAILURE", "Play received a non-string argument", null);
        }
        break;
      case "queue":
        if (methodCall.arguments instanceof String) {
          remote.getPlayerApi().queue((String) methodCall.arguments);
          result.success(null);
        } else {
          result.error("FAILURE", "Queue received a non-string argument", null);
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * Creates a subscription to the Spotify API's player state events.
   */
  private void subscribeToPlayerState() {
    if (remote == null || !remote.isConnected()) {
      // If there is a problem with the remote, do nothing.
      return;
    }

    playerStateSubscription = remote.getPlayerApi().subscribeToPlayerState();
  }

  /**
   * Tells the subscription to start firing events using the updatePlayerState method.
   */
  private void addPlayerStateSubscription() {
    if (this.playerStateSubscription == null) {
      this.subscribeToPlayerState();
      this.playerStateSubscription.setEventCallback((playerState) ->
          this.channel.invokeMethod("updatePlayerState", mapPlayerState(playerState)));
      this.playerStateSubscriptions = 0;
    }

    remote.getPlayerApi().getPlayerState().setResultCallback(
        (result) -> channel.invokeMethod("updatePlayerState", mapPlayerState(result)));
    this.playerStateSubscriptions++;
  }

  /**
   * Cancels the player state subscription.
   */
  private void cancelPlayerStateSubscription() {
    if (this.playerStateSubscription == null) {
      return;
    }

    this.playerStateSubscriptions--;
    if (this.playerStateSubscriptions <= 0) {
      this.playerStateSubscription.cancel();
      this.playerStateSubscription = null;
    }
  }
}
