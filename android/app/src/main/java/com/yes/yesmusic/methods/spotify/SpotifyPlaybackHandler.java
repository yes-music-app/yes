package com.yes.yesmusic.methods.spotify;

import com.spotify.android.appremote.api.SpotifyAppRemote;
import com.spotify.protocol.client.Subscription;
import com.spotify.protocol.types.PlayerState;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class SpotifyPlaybackHandler implements MethodCallHandler {

  // A singleton instance of a Spotify playback handler.
  private static SpotifyPlaybackHandler instance = null;

  private SpotifyPlaybackHandler(MethodChannel channel) {
    this.channel = channel;
  }

  /**
   * Retrieves the current SpotifyPlaybackHandler instance. If it not yet set up, sets it up using
   * the given channel.
   *
   * @param channel the method channel to use for this instance
   * @return The current SpotifyPlaybackHandler instance.
   */
  public static SpotifyPlaybackHandler getInstance(MethodChannel channel) {
    if (instance == null) {
      instance = new SpotifyPlaybackHandler(channel);
    }

    return instance;
  }

  // The method channel to used for all flutter interactions.
  private final MethodChannel channel;

  // The subscription to the player state.
  private Subscription<PlayerState> playerStateSubscription;
  private int playerStateSubscriptions = 0;

  @Override
  public void onMethodCall(MethodCall methodCall, Result result) {
    switch (methodCall.method) {
      case "subscribeToPlayerState":
        this.addPlayerStateSubscription();
        result.success(null);
        break;
      case "unsubscribeFromPlayerState":
        this.cancelPlayerStateSubscription();
        result.success(null);
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
    SpotifyAppRemote remote = SpotifyConnectionHandler.getRemote();

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
          this.channel.invokeMethod("updatePlayerState", playerState));
      this.playerStateSubscriptions = 0;
    }

    this.playerStateSubscriptions++;
  }

  /**
   * Cancels the player state subscription.
   */
  private void cancelPlayerStateSubscription() {
    this.playerStateSubscriptions--;
    if (this.playerStateSubscriptions <= 0) {
      this.playerStateSubscription.cancel();
      this.playerStateSubscription = null;
    }
  }
}
