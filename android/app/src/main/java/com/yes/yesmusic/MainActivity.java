package com.yes.yesmusic;

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

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // Set this app's call handlers to our Spotify call handlers.
    new MethodChannel(getFlutterView(), PLAYBACK_CHANNEL).setMethodCallHandler(new SpotifyPlaybackHandler());
    new MethodChannel(getFlutterView(), CONNECTION_CHANNEL).setMethodCallHandler(new SpotifyConnectionHandler());
  }
}
