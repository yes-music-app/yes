package com.yes.yesmusic.methods.spotify;

import static com.yes.yesmusic.methods.spotify.Items.CLIENT_ID;
import static com.yes.yesmusic.methods.spotify.Items.REDIRECT_URI;

import android.app.Activity;
import android.net.Uri;
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

  // A singleton instance of a Spotify connection handler.
  private static SpotifyConnectionHandler instance = null;

  private SpotifyConnectionHandler(Activity activity, MethodChannel channel) {
    this.activity = activity;
    this.channel = channel;
    if (this.remote != null && this.remote.isConnected()) {
      SpotifyAppRemote.disconnect(this.remote);
      this.remote = null;
    }
  }

  /**
   * Retrieves the current SpotifyConnectionHandler instance. If it not yet set up, sets it up using
   * the given activity and channel.
   *
   * @param activity the activity to use for this connection
   * @param channel the method channel to use for this connection
   * @return The current SpotifyConnectionHandler instance.
   */
  public static SpotifyConnectionHandler getInstance(Activity activity, MethodChannel channel) {
    if (instance == null) {
      instance = new SpotifyConnectionHandler(activity, channel);
    }

    return instance;
  }

  // The activity to be used for all UI interactions.
  private final Activity activity;

  // The method channel to used for all flutter interactions.
  private final MethodChannel channel;

  // The SpotifyAppRemote to be connection.
  private SpotifyAppRemote remote;

  public static SpotifyAppRemote getRemote() {
    if (instance == null) {
      return null;
    }

    return instance.remote;
  }

  @Override
  public void onMethodCall(MethodCall methodCall, Result result) {
    int val;

    switch (methodCall.method) {
      case "connect":
        val = this.connect();

        if (val < 0) {
          result.error("FAILURE", "Connection to Spotify failed", null);
        } else {
          result.success(val);
        }
        break;
      case "disconnect":
        val = this.disconnect();

        if (val < 0) {
          result.error("FAILURE", "Disconnection from Spotify failed", null);
        } else {
          result.success(val);
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * Connects to the Spotify Remote API.
   *
   * @return The success code of connection attempt.
   */
  private int connect() {
    // Get the connection parameters for this connection.
    ConnectionParams connectionParams = new ConnectionParams.Builder(CLIENT_ID)
        .setRedirectUri(REDIRECT_URI).showAuthView(true).build();

    // Actually connect to the Spotify app.
    try {
      SpotifyAppRemote.connect(this.activity, connectionParams, new ConnectionListener() {
        @Override
        public void onConnected(SpotifyAppRemote spotifyAppRemote) {
          remote = spotifyAppRemote;
        }

        @Override
        public void onFailure(Throwable throwable) {
          remote = null;
        }
      });

      return remote == null ? -1 : 0;
    } catch (Exception e) {
      return -1;
    }
  }

  /**
   * Disconnects from the spotify remote API.
   *
   * @return The success code of the disconnection attempt.
   */
  public int disconnect() {
    if (this.remote != null && this.remote.isConnected()) {
      SpotifyAppRemote.disconnect(this.remote);
      return 0;
    } else {
      return -1;
    }
  }
}
