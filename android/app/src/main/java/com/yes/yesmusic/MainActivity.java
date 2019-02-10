package com.yes.yesmusic;

import android.os.Bundle;
import handlers.methods.SpotifyCallHandler;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

/**
 * The native Android activity for interacting with Spotify apis.
 */
public class MainActivity extends FlutterActivity {

  // The channel path to be used by the method channel.
  private static final String CHANNEL = "yes.yesmusic/spotify";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // Set this app's call handler to our Spotify call handler.
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new SpotifyCallHandler());
  }
}
