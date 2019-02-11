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
  private final MethodChannel channel;

  // The SpotifyAppRemote to be connection.
  private SpotifyAppRemote remote;

  SpotifyAppRemote getRemote() {
    return this.remote;
  }

  public SpotifyConnectionHandler(Activity activity, MethodChannel channel) {
    this.activity = activity;
    this.channel = channel;
  }

  @Override
  public void onMethodCall(MethodCall methodCall, Result result) {
    switch (methodCall.method) {
      case "connect":
        this.connect();
        result.success(null);
        break;
      case "disconnect":
        this.disconnect();
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
  private void connect() {
    // Get the connection parameters for this connection.
    ConnectionParams connectionParams = new ConnectionParams.Builder(CLIENT_ID)
        .setRedirectUri(REDIRECT_URI).showAuthView(true).build();

    // Actually connect to the Spotify app.
    SpotifyAppRemote.connect(this.activity, connectionParams, new ConnectionListener() {
      @Override
      public void onConnected(SpotifyAppRemote spotifyAppRemote) {
        remote = spotifyAppRemote;
        channel.invokeMethod("connectionUpdate", 2);
      }

      @Override
      public void onFailure(Throwable throwable) {
        remote = null;
        channel.invokeMethod("connectionUpdate", 0);
      }
    });

    channel.invokeMethod("connectionUpdate", 1);
  }

  /**
   * Disconnects from the spotify remote API.
   */
  public void disconnect() {
    if (this.remote != null && this.remote.isConnected()) {
      SpotifyAppRemote.disconnect(this.remote);
    }

    channel.invokeMethod("connectionUpdate", 0);
  }
}
