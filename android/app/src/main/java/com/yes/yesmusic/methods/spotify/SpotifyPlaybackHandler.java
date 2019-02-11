package com.yes.yesmusic.methods.spotify;

import static com.yes.yesmusic.methods.spotify.SpotifyDataMappers.mapPlayerState;

import com.spotify.android.appremote.api.SpotifyAppRemote;
import com.spotify.protocol.client.Subscription;
import com.spotify.protocol.types.PlayerState;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class SpotifyPlaybackHandler implements MethodCallHandler {

  public SpotifyPlaybackHandler(SpotifyConnectionHandler connectionHandler, MethodChannel channel) {
    this.connectionHandler = connectionHandler;
    this.channel = channel;
  }

  private final SpotifyConnectionHandler connectionHandler;
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
    SpotifyAppRemote remote = this.connectionHandler.getRemote();

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
