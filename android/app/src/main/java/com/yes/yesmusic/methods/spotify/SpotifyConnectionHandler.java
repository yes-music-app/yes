package com.yes.yesmusic.methods.spotify;

import static com.yes.yesmusic.methods.spotify.Items.CLIENT_ID;
import static com.yes.yesmusic.methods.spotify.Items.REDIRECT_URI;

import android.app.Activity;
import com.spotify.android.appremote.api.ConnectionParams;
import com.spotify.android.appremote.api.Connector.ConnectionListener;
import com.spotify.android.appremote.api.SpotifyAppRemote;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * A class that handles connecting with and disconnecting from Spotify.
 */
public class SpotifyConnectionHandler implements MethodCallHandler {

  private final Activity activity;
  private final SpotifyPlaybackHandler playbackHandler;

  public SpotifyConnectionHandler(Activity activity,
      SpotifyPlaybackHandler playbackHandler) {
    this.activity = activity;
    this.playbackHandler = playbackHandler;
  }

  @Override
  public void onMethodCall(MethodCall methodCall, Result result) {
    switch (methodCall.method) {
      case "connect":
        disconnect();
        connect(result);
        break;
      case "disconnect":
        disconnect();
        result.success(null);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * Connects to the Spotify Remote API.
   */
  private void connect(Result result) {
    // Get the connection parameters for this connection.
    ConnectionParams connectionParams = new ConnectionParams.Builder(CLIENT_ID)
        .setRedirectUri(REDIRECT_URI).showAuthView(true).build();

    // Actually connect to the Spotify app.
    SpotifyAppRemote.connect(activity, connectionParams, new ConnectionListener() {
      @Override
      public void onConnected(SpotifyAppRemote spotifyAppRemote) {
        playbackHandler.setRemote(spotifyAppRemote);
        result.success(null);
      }

      @Override
      public void onFailure(Throwable throwable) {
        playbackHandler.setRemote(null);
        result.error("Failed to connect", null, null);
      }
    });
  }

  /**
   * Disconnects from the spotify remote API.
   */
  public void disconnect() {
    SpotifyAppRemote remote = playbackHandler.getRemote();

    if (remote != null && remote.isConnected()) {
      SpotifyAppRemote.disconnect(remote);
    }
  }
}
