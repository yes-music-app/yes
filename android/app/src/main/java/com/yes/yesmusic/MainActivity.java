package com.yes.yesmusic;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import com.yes.yesmusic.methods.spotify.SpotifyConnectionHandler;
import com.yes.yesmusic.methods.spotify.SpotifyPlaybackHandler;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

/**
 * The native Android activity for interacting with Spotify apis.
 */
public class MainActivity extends FlutterActivity {

  // The channel paths to be used by the method channels.
  private static final String PLAYBACK_CHANNEL = "yes.yesmusic/playback";
  private static final String CONNECTION_CHANNEL = "yes.yesmusic/connection";

  private SpotifyConnectionHandler connectionHandler;
  private SpotifyPlaybackHandler playbackHandler;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // Set this app's call handlers to our Spotify call handlers.
    MethodChannel connectionChannel = new MethodChannel(getFlutterView(), CONNECTION_CHANNEL);
    MethodChannel playbackChannel = new MethodChannel(getFlutterView(), PLAYBACK_CHANNEL);
    this.connectionHandler = new SpotifyConnectionHandler(this, connectionChannel, this.playbackHandler);
    this.playbackHandler = new SpotifyPlaybackHandler(this.connectionHandler, playbackChannel);
    connectionChannel.setMethodCallHandler(this.connectionHandler);
    playbackChannel.setMethodCallHandler(this.playbackHandler);
  }

  @Override
  protected void onStop() {
    super.onStop();
    this.connectionHandler.disconnect();
  }
}
